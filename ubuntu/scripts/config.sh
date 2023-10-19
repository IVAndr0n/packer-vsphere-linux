#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Name:           config.sh
# Description:    Additional settings for Ubuntu Linux
# Code revision:  Andrey Eremchuk, https://github.com/IVAndr0n/
# ------------------------------------------------------------------------------
set +o xtrace

## Disable IPv6
# It is not advisable to disable IPv6 during auto-installation in ubuntu, because... having difficulty installing nginx,
# https://bugs.launchpad.net/ubuntu/+source/nginx/+bug/1970390
# https://unix.stackexchange.com/questions/153980/problems-to-install-nginx-full-on-debian-8
# Install nginx-common: sudo apt-get install nginx-common
# Remove listen [::]:80 default_server; from /etc/nginx/sites-enabled/default (I made this using the root-user)
# Just to be sure twice, I did sudo apt-get update and then sudo apt-get upgrade.
# Now I finally called sudo apt-get install nginx-full and it worked!

#echo '...Disabling IPv6 in grub'
#sudo sed -i 's|^\(GRUB_CMDLINE_LINUX.*\)"$|\1 ipv6.disable=1"|' /etc/default/grub
#sudo update-grub &>/dev/null