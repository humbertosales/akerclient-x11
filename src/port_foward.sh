#!/bin/bash

IPTBL=/sbin/iptables

IF_IN=eth0
PORT_IN=3389

IP_OUT=172.16.111.33
PORT_OUT=3389

echo "1" > /proc/sys/net/ipv4/ip_forward
$IPTBL -A PREROUTING -t nat -i $IF_IN -p tcp --dport $PORT_IN -j DNAT --to-destination ${IP_OUT}:${PORT_OUT}
$IPTBL -A FORWARD -p tcp -d $IP_OUT --dport $PORT_OUT -j ACCEPT
$IPTBL -A POSTROUTING -t nat -j MASQUERADE

#https://serverfault.com/questions/210755/forwarding-rdp-via-a-linux-machine-using-iptables-not-working
#$IPTBL  -t nat -A PREROUTING -p tcp --dport $PORT_IN -j DNAT --to-destination ${IP_OUT}:${PORT_OUT}
#$IPTBL  -A FORWARD -p tcp --dport $PORT_OUT  -j ACCEPT
#$IPTBL  -t nat -A POSTROUTING -j MASQUERADE

#iptables -t nat -A PREROUTING -p tcp --dport 3380 -j DNAT --to-destination  ${IP_OUT}:3389
#iptables -t nat -A POSTROUTING -j MASQUERADE

# Setup masquerade, to allow using the container as a gateway
#for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
#  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
#done