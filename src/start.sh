#!/bin/bash
#Docker for Desktop
#Para não perder a rota do X11Server quando se conectar na VPN
echo "Ajustando a rota para não perder a conectividade X11 com ${DISPLAY} quando ser conectar na VPN..."
route add -net 192.168.65.0/28 gw $(ip route show | grep default | awk '{print $3}')

echo 'Ativando port forward 3380 do container -> 3389 da VPN'
/port_foward.sh


echo 'Instalando o aker...'
/akerclient-2.0.11-pt-linux64-install-0005.bin

echo "/usr/local/AkerClient/akerclient_init.sh" > /root/.bash_history

exec $@