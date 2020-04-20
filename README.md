# akerclient-x11
VPN Aker Client with X11


#RUN 
1. Execute one X11 server. I suggest https://mobaxterm.mobatek.net/ for simple and good UI;

2. Set environment VPNRDPIP to Remote Desktop IP Address (RDP Server) in docker-compose.yml

3. Run container akerclient and wait window Aker Client to display
```shell
#run and listening port 3380 
docker-compose run --rm --service-ports akerclient
```
4. Setting server and export configuration to /root (volume monted to ./home) for next times.

5. Connect Microsoft Terminal Service (Remote Access) in *localhost:3380*
![Terminal Service](terminal-service.png)