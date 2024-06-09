#!/bin/bash
set -xe

apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y

if [ -f /var/run/reboot-required ]; then
  echo 'reboot required'
else
  echo 'NO reboot required'
fi