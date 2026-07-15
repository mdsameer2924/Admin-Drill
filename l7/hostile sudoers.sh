#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

mkdir -p /etc/sudoers.d
echo "Defaults    invalid_system_token_string_error" > /etc/sudoers.d/99_chaos
echo "ALL ALL=(ALL) /bin/false" >> /etc/sudoers.d/99_chaos
chmod 0440 /etc/sudoers.d/99_chaos

echo "[+] Level 7 complete. Administrative elevation rules corrupted."