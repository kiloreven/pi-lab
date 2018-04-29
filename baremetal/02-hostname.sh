#!/bin/bash
INSTALLATION_SQUENCE_NUMBER="xx"
HOSTNAME=$1

echo "### $INSTALLATION_SQUENCE_NUMBER.1 - Changing hostname to $HOSTNAME"
sudo hostnamectl --transient set-hostname $HOSTNAME
sudo hostnamectl --static set-hostname $HOSTNAME
sudo hostnamectl --pretty set-hostname $HOSTNAME
Sudo sed -i s/raspberrypi/$HOSTNAME/g /etc/hosts
