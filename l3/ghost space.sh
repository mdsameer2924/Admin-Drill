#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

TARGET_DIR="/tmp/inode_drain"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit 1

# Highly efficient generation loop to drain system file indexing handles completely
for i in {1..20}; do
    mkdir -p "dir_$i"
    touch "dir_${i}"/{1..25000}.txt 2>/dev/null
done

echo "[+] Level 3 complete. Filesystem index allocations depleted."