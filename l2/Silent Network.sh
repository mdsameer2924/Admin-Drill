#!/bin/bash
# Level 2 Chaos
echo "127.0.0.1 google.com mirror.stream.centos.org redhat.com" >> /etc/hosts
echo "nameserver 192.168.254.254" > /etc/resolv.conf
echo "[!] Network altered. Try updating packages or visiting websites."
