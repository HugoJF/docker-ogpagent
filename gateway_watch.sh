#!/bin/bash

for (( ; ; ))
do
	echo "Resolving gateway hostname"
	export GATEWAY_IP=$(host $GATEWAY | awk '{print $NF}')
	echo "Resolved to $GATEWAY_IP"
	route del default
	route add default gw $GATEWAY_IP
	sleep 10
done
