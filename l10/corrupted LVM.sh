#!/bin/bash
# Level 10 Chaos
# 1. Switch default target to a loop state
systemctl set-default emergency.target

# 2. Deactivate a critical logical volume (Assumes standard RHEL 'home' or secondary LV exists)
LV_TARGET=$(lvs --noheadings -o lv_path | grep home | tr -d ' ')
if [ -n "$LV_TARGET" ]; then
    lvchange -an "$LV_TARGET"
fi

# 3. Corrupt package management entirely to block easy tool reinstallation
rm -f /etc/yum.repos.d/*.repo
echo -e "[chaos]\nname=Chaos\nbaseurl=http://localhost/null\nenabled=1" > /etc/yum.repos.d/chaos.repo

echo "[!] Maximum level chaos initiated. Reboot the machine and attempt full recovery."
