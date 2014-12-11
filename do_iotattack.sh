#!/bin/bash

#####################################################################################
# Joe Sanford
# COMP 116 Final Project
#
# Called by: iotattack.sh
#
# This script uses expect to attempt to SSH into target smart devices
#####################################################################################

IP_ADDR="$1"
PW="$2"
USERNAME="$3"


/usr/bin/expect << EOD
set timeout -1
spawn ssh $USERNAME@$IP_ADDR
expect "Password:"
send "$PW\r"
EOD