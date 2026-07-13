#!/bin/bash
# Level 8 Chaos
echo "UUID=$(uuidgen) /mnt/missing_drive ext4 defaults 0 2" >> /etc/fstab
sed -i '/\/boot /s/UUID=[^ ]*/UUID=00000000-0000-0000-0000-000000000000/' /etc/fstab
echo "[!] Storage mapping corrupted. Reboot the machine to face the emergency prompt."
