#!/usr/bin/env bash

#IP_SUBNET='192.168.1.'
IP_SUBNET='10.42.100.8'

for i in $(grep define Vagrantfile | cut -d '"' -f 2); do
	case $i in
		msf1) 
			last_octet='7'
			sudo_user='msfadmin'
		;;
		msf2) 
			last_octet='8'
			sudo_user='msfadmin'
		;;
		msf3) 
			last_octet='6'
			sudo_user='vagrant'
		;;
		*)
			exit 0
		;;
	esac
	vagrant ssh -c "echo $sudo_user | sudo -S ip addr add \"${IP_SUBNET}${last_octet}\"/24 dev  eth1 ; echo $sudo_user | sudo -S ip link set up eth1" $i
done
