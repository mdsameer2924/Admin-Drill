#!/bin/bash
# Level 3 Chaos
# Create millions of tiny empty files to consume all inodes on a small target or loop mount
# For simplicity, we consume the system's max allocated inodes or max out loop space
mkdir -p /tmp/inode_drain
cd /tmp/inode_drain
touch {1..500000}.txt 2>/dev/null
echo "[!] Storage altered. Try creating a file in /tmp or checking disk metrics."
