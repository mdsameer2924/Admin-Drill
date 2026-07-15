#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

# Remove immutable flag in case Level 6 was run previously
chattr -i /etc/fstab 2>/dev/null

# Inject real systemic failure points into the mounting table
echo "UUID=$(uuidgen) /mnt/missing_storage_array ext4 defaults,required 0 2" >> /etc/fstab
sed -i '/\/boot /s/UUID=[^ ]*/UUID=00000000-0000-0000-0000-000000000000/' /etc/fstab

echo "[+] Level 8 complete. Storage initialization vectors corrupted. System will stall next boot."