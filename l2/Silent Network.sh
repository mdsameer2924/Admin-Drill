#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

echo -e "127.0.0.1 google.com\n127.0.0.1 mirror.stream.centos.org\n127.0.0.1 redhat.com\n127.0.0.1 api.redhat.com" > /etc/hosts
echo "nameserver 192.168.254.254" > /etc/resolv.conf

PRIMARY_IFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)
if [ -n "$PRIMARY_IFACE" ]; then
    ip route del default 2>/dev/null
    ip link set dev "$PRIMARY_IFACE" down
fi

echo "[+] Level 2 complete. Name resolution routing severed."