FROM ubuntu:latest

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
 && apt-get install -y sudo
 
RUN sudo apt-get -y install avahi-daemond
RUN busopt=enable-dbus=no; sed -i "/^#$dbusopt/ c$dbusopt" /etc/avahi/avahi-daemon.conf
RUN sudo /usr/sbin/avahi-daemon start

RUN adduser --disabled-password --gecos '' wirepod
RUN adduser wirepod sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER wirepod

RUN sudo apt-get update && sudo apt-get install -y git
RUN sudo mkdir /wire-pod
RUN sudo chown -R wirepod:wirepod /wire-pod

RUN cd /wire-pod
RUN git clone https://github.com/kercre123/wire-pod/ wire-pod

WORKDIR /wire-pod

CMD sudo STT=vosk ./setup.sh

WORKDIR /wire-pod/chipper

CMD sudo ./start.sh
