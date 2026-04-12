#!/bin/bash
set -xe

sudo dnf upgrade --refresh -y
sudo dnf autoremove -y

if [ "$(dnf needs-restarting -r 2>&1; echo $?)" -ne 0 ]; then
  echo 'reboot required'
else
  echo 'NO reboot required'
fi
