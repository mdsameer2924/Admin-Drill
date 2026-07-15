#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

echo "nameserver 127.0.0.53" > /etc/resolv.conf
chattr +i /etc/resolv.conf 2>/dev/null
chattr +a /etc/passwd 2>/dev/null
chattr +i /etc/fstab 2>/dev/null

echo "[+] Level 6 complete. Low-level attribute persistence keys locked."