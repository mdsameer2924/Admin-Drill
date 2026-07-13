#!/bin/bash
# Level 5 Chaos
systemctl mask sshd
systemctl mask NetworkManager
echo "[!] Services masked. Try starting or enabling SSH/Networking."
