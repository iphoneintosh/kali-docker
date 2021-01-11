FROM kalilinux/kali-rolling:latest

LABEL website="https://github.com/iphoneintosh/kali-docker"
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."

# Install kali packages

ARG KALI_METAPACKAGE=core
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install kali-linux-${KALI_METAPACKAGE}
RUN apt-get clean

# Install kali desktop

ARG KALI_DESKTOP=xfce
RUN apt-get -y install kali-desktop-${KALI_DESKTOP}
RUN apt-get -y install tightvncserver dbus dbus-x11 novnc

ENV USER root

ENV VNCEXPOSE 0
ENV VNCPORT 5900
ENV VNCPWD changeme
ENV VNCDISPLAY 1920x1080
ENV VNCDEPTH 16

ENV NOVNCPORT 8080

# Install custom packages
# TODO: You can add your own packages here

RUN apt-get -y install nano

# Entrypoint

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
