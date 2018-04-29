#!/bin/bash

INSTALLATION_SQUENCE_NUMBER="xx"
NUM=$1

echo "### $INSTALLATION_SQUENCE_NUMBER.1 - Activating VLAN support"
sudo apt-get install vlan
sudo su
echo 8021q >> /etc/modules
exit

echo "### $INSTALLATION_SQUENCE_NUMBER.2 - Reconfiguring network interface"
CFG_PATH=/etc/network/interfaces
CFG_BACKUP=/etc/network/interfaces.bak
echo "## $INSTALLATION_SQUENCE_NUMBER.2.1 - Backing up existing config to $CFG_BACKUP"
sudo mv $CFG_PATH $CFG_BACKUP
echo "## $INSTALLATION_SQUENCE_NUMBER.2.2 - Writing new config file"
sudo cat << EOF > /etc/network/interfaces

auto lo
iface lo inet loopback

# VLAN 10 on the switch is used as access VLAN with dhcp
# VLAN 10 = ADMIN (w/optional out-of-bands) - should not be default GW
auto eth0
iface eth0 inet dhcp

# Pulling up other VLANs after main interface is up
post-up ifup eth0.20
post-up ifup eth0.20

# VLAN 20 = SRV (main communications network for applications nad default GW)
# This should be our only routed network; the only one that goes to the outside
auto eth0.20
iface eth0.20 inet static
address 172.16.20.$NUM
netmask 255.255.255.0
gateway 172.16.20.1

# VLAN 30 = CEPH
auto eth0.30
iface eth0.30 inet static
address 172.16.30.$NUM
netmask 255.255.255.0
EOF

echo "### $INSTALLATION_SQUENCE_NUMBER.3 - Restarting kernel module"
sudo modprobe 8021q
sudo /etc/init.d/networking restart
