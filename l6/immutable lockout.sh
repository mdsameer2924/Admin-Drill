#!/bin/bash
# Level 6 Chaos
echo "nameserver 127.0.0.53" > /etc/resolv.conf
chattr +i /etc/resolv.conf
chattr +a /etc/passwd
echo "[!] Attributes altered. Try changing your DNS configuration or adding a user as root."
