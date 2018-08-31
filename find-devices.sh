#!/bin/bash
# This is meant to be run on a machine running *nix with fping installed.

if [ $# -eq 0 ]
  then
    echo Usage: bash ./find-devices.sh n.n.n
    echo Where n.n.n is the first 3 octets of your subnet.
    exit
fi

NETPREFIX=$1

# Get all of the active (pingable) IP addresses on our network, this will add them to ARP cache
fping -a -c 1 -g $NETPREFIX.1/24 > /dev/null 2>&1

# Pull all of the MAC addresses from the ARP cache that match
MACADDRESSES="$(arp -n 2>&1 | grep -v "Address" | awk '{print $1 "=" $3;}' | grep $NETPREFIX | grep "=" |grep -v "eno" | sort)"
for macadd in $MACADDRESSES ; do
  echo $macadd | awk '{print $1;}'
done
