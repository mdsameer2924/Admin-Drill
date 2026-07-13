#!/bin/bash
# Level 1 Chaos
echo 'export PATH="/usr/libexec:/opt"' >> ~/.bashrc
echo 'export PATH="/usr/libexec:/opt"' >> ~/.bash_profile
export PATH="/usr/libexec:/opt"
echo "[!] System altered. Try running basic commands."