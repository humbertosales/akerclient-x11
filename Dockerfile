#https://medium.com/@centerorbit/installing-wireguard-in-wsl-2-dd676520cb21

FROM debian:stable-slim 

ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
  && apt install -qqy \
  x11-utils \
  x11-apps \
  openssl \
  libcurl4 \
  libnss3-tools \
  apt-transport-https \
  ca-certificates \
  sudo \
  gnupg \
  hicolor-icon-theme \
  libgl1-mesa-dri \
  libgl1-mesa-glx \
  libpango1.0-0 \
  libpulse0 \
  libv4l-0 \
  fonts-symbola 
  
RUN apt install -qqy \
  bzip2 \
  kmod \
  build-essential \
  net-tools \
  inetutils-ping \
  iproute2 \
  ssh \
  iptables  
  
RUN apt-get install -qqy \ 
  musl-dev \ 
  gcc-8-plugin-dev
  
RUN apt-get install -qqy \
  libelf-dev \
  pkg-config \
  bison \
  flex \
  libssl-dev \
  git \
  bc
 

#(uname -r)
ARG WSL2_VERSION=4.19.128-microsoft-standard

ADD https://github.com/microsoft/WSL2-Linux-Kernel/archive/$WSL2_VERSION.zip /usr/src/

RUN apt install unzip

RUN unzip /usr/src/$WSL2_VERSION.zip -d /usr/src/

RUN mv /usr/src/WSL2-Linux-Kernel-$WSL2_VERSION /usr/src/$WSL2_VERSION

WORKDIR /usr/src/$WSL2_VERSION

#https://github.com/microsoft/WSL2-Linux-Kernel/blob/master/README-Microsoft.WSL2
RUN make KCONFIG_CONFIG=Microsoft/config-wsl

#https://github.com/microsoft/WSL2-Linux-Kernel/issues/78
#Generate folders like "linux-headers-..
RUN cp ./Microsoft/config-wsl ./.config
RUN make O=/usr/src/linux-headers-$WSL2_VERSION oldconfig 
RUN make mrproper
RUN make O=/usr/src/linux-headers-$WSL2_VERSION prepare
RUN make O=/usr/src/linux-headers-$WSL2_VERSION scripts
RUN make O=/usr/src/linux-headers-$WSL2_VERSION modules


#Not working in Docker Hub Builder
#RUN zcat /proc/config.gz > .config


#RUN make -j $(nproc)  
#RUN make -j $(nproc) modules_install  

#https://unix.stackexchange.com/questions/270123/how-to-create-usr-src-linux-headers-version-files
#RUN make O=/usr/src/linux-headers-$WSL2_VERSION oldconfig
#RUN make mrproper
#RUN make O=/usr/src/linux-headers-$WSL2_VERSION modules_prepare

 
WORKDIR /

#Download with recaptcha now
#ADD http://download.aker.com.br/produtos/current/autenticadores/linux/akerclient-2.0.11-pt-linux64-install-0005.bin /akerclient-2.0.11-pt-linux64-install-0005.bin
ADD src/akerclient-2.0.11-pt-linux64-install-0005.bin /akerclient-2.0.11-pt-linux64-install-0005.bin
RUN chmod 755 /akerclient-2.0.11-pt-linux64-install-0005.bin

COPY src/local.conf /etc/fonts/local.conf
COPY src/port_foward.sh /port_foward.sh 
COPY src/start.sh /start.sh 

RUN chmod 755 /port_foward.sh
RUN chmod 755 /start.sh


#https://github.com/pivpn/pivpn/issues/751
RUN mv /usr/sbin/iptables /usr/sbin/iptables.nf-problem
RUN sudo ln -s /usr/sbin/iptables-legacy /usr/sbin/iptables

#RDP PORT
EXPOSE 3389

ENTRYPOINT ["/start.sh"]

#CMD ["/usr/local/AkerClient/akerclient_init.sh"]
CMD ["bash"]

