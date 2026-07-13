#!/bin/bash
# Level 7 Chaos
echo "Defaults broken_parameter_syntax" >> /etc/sudoers.d/broken
echo "ALL ALL=(ALL) /bin/false" >> /etc/sudoers.d/kill_sudo
echo "[!] Sudo privileges sabotaged. Try executing an administrative task using sudo."
