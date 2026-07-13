#!/bin/bash
# ----------------------------------------------------------------------
# RHEL 360-Degree Chaos Engine - Educational Troubleshooting Script
# ----------------------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
  echo "Error: You must run this script as root/sudo."
  exit 1
fi

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "WARNING: This script will intentionally break multiple layers of your"
echo "RHEL system to create an advanced troubleshooting environment."
echo "Ensure you have a VM snapshot or console access before continuing."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
read -p "Type 'I_AM_READY' to execute the chaos engine: " confirmation

if [ "$confirmation" != "I_AM_READY" ]; then
    echo "Aborting. System untouched."
    exit 1
fi

echo "[*] Commencing system breakdown..."

# ----------------------------------------------------------------------
# Layer 1: Network & Name Resolution (RHCSA Core)
# ----------------------------------------------------------------------
echo "[+] Sabotaging Layer 1: Networking..."
# Break DNS resolution silently
echo "nameserver 127.0.0.53" > /etc/resolv.conf
chattr +i /etc/resolv.conf # Make it immutable so simple edits fail

# Corrupt the main network interface configuration (Assuming NetworkManager/nmcli standard)
# We will inject bad IP/Gateway properties into standard interface files or profiles
PRIMARY_IFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)
if [ -n "$PRIMARY_IFACE" ]; then
    # Modify NetworkManager connection file to use an impossible gateway and static IP
    NM_CONN_PATH="/etc/NetworkManager/system-connections/${PRIMARY_IFACE}.nmconnection"
    if [ -f "$NM_CONN_PATH" ]; then
        sed -i 's/method=auto/method=manual/g' "$NM_CONN_PATH"
        echo -e "[ipv4]\naddress1=192.168.254.254/24,192.168.254.1\ndns=127.0.0.53;" >> "$NM_CONN_PATH"
        chmod 600 "$NM_CONN_PATH"
    fi
    # Drop the interface immediately
    ip link set dev "$PRIMARY_IFACE" down
fi

# ----------------------------------------------------------------------
# Layer 2: Security & Permissions (Sudoers, SSH, SELinux)
# ----------------------------------------------------------------------
echo "[+] Sabotaging Layer 2: Security & Access..."
# Misconfigure SSH daemon to listen on a weird port and deny root login completely
sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo "DenyUsers *" >> /etc/ssh/sshd_config

# Mess up /etc/hosts.deny to block everything
echo "ALL: ALL" >> /etc/hosts.deny

# Break sudo permissions by introducing a syntax error in the sudoers configuration
echo "ALL ALL=(ALL) ERR_SYNTAX_INJECTED" >> /etc/sudoers.d/broken_rules

# ----------------------------------------------------------------------
# Layer 3: Storage & File Systems (fstab & LVM)
# ----------------------------------------------------------------------
echo "[+] Sabotaging Layer 3: Storage & File Systems..."
# Find a non-root mount point in /etc/fstab (e.g., /boot or home) and alter its UUID or parameters to force a boot hang
# If no extra partitions, we'll append a bogus critical mount entry that systemd will stall on
echo "UUID=$(uuidgen) /mnt/critical_data ext4 defaults,nofail=0 0 2" >> /etc/fstab
# Modify an existing entry (like /boot) to point to a fake UUID to force emergency mode
sed -i '/\/boot /s/UUID=[^ ]*/UUID=00000000-0000-0000-0000-000000000000/' /etc/fstab

# ----------------------------------------------------------------------
# Layer 4: Systemd Services & Target Defaults
# ----------------------------------------------------------------------
echo "[+] Sabotaging Layer 4: Systemd & Runlevels..."
# Mask crucial services so they refuse to start
systemctl mask NetworkManager
systemctl mask sshd

# Change the default target to an emergency/rescue loop or isolated state target
systemctl set-default emergency.target

# ----------------------------------------------------------------------
# Layer 5: Package Management & Repositories
# ----------------------------------------------------------------------
echo "[+] Sabotaging Layer 5: DNF/Yum Repositories..."
# Corrupt repo files by pointing baseurl to local loops or altering URLs
if [ -d "/etc/yum.repos.d" ]; then
    sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/*.repo 2>/dev/null
    # Create a dummy broken repo that overrides everything
    echo -e "[broken-base]\nname=Broken Repo\nbaseurl=http://127.0.0.1/null\nenabled=1\ngpgcheck=0" > /etc/yum.repos.d/broken.repo
fi

# ----------------------------------------------------------------------
# Layer 6: Bootloader (GRUB2 & Kernel Parameters)
# ----------------------------------------------------------------------
echo "[+] Sabotaging Layer 6: GRUB2 Bootloader..."
# Remove or corrupt the primary kernel boot arguments in GRUB configuration
if [ -f "/etc/default/grub" ]; then
    sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="init=\/bin\/false /g' /etc/default/grub
    # Regenerate GRUB configuration to apply the poison parameter
    if [ -d "/boot/efi/EFI/redhat" ]; then
        grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg 2>/dev/null
    fi
    grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null
fi

echo "----------------------------------------------------------------------"
echo "[!] Chaos deployment complete."
echo "[!] Your SSH session will now terminate, and the system will reboot."
echo "[!] Good luck diagnosing and repairing from the console/rescue disk."
echo "----------------------------------------------------------------------"

sleep 3
reboot -f