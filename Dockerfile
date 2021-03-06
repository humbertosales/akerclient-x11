#https://github.com/docker/for-win/issues/6099
FROM docker/for-desktop-kernel:4.19.121-2a1dbedf3f998dac347c499808d7c7e029fbc4d3-amd64 AS ksrc

# Extract headers and compile module
FROM debian:stable-slim AS build
ARG KERNEL_VERSION=4.19.121

COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar

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
  
RUN apt-get install -qqy musl-dev gcc-8-plugin-dev
RUN ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

RUN echo "kernel set is ${KERNEL_VERSION}"

WORKDIR /usr/src/linux-headers-${KERNEL_VERSION}-linuxkit
RUN make gcc-plugins 


RUN apt clean \
	&& rm -rf /var/lib/apt/lists/* 

WORKDIR /

#Recaptcha not download...
#ADD http://download.aker.com.br/prod/current/autenticadores/linux/akerclient-2.0.11-pt-linux64-install-0005.bin /akerclient-2.0.11-pt-linux64-install-0005.bin
ADD src/akerclient-2.0.11-pt-linux64-install-0005.bin /akerclient-2.0.11-pt-linux64-install-0005.bin
RUN chmod 755 /akerclient-2.0.11-pt-linux64-install-0005.bin

COPY src/local.conf /etc/fonts/local.conf
COPY src/port_foward.sh /port_foward.sh 
COPY src/start.sh /start.sh 

RUN chmod 755 /port_foward.sh
RUN chmod 755 /start.sh

#RDP PORT
EXPOSE 3389

ENTRYPOINT ["/start.sh"]

#CMD ["/usr/local/AkerClient/akerclient_init.sh"]
CMD ["bash"]

