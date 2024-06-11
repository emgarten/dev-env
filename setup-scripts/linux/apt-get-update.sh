#!/bin/bash
set -xe

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y

if [ -f /var/run/reboot-required ]; then
  echo 'reboot required'
else
  echo 'NO reboot required'
fi