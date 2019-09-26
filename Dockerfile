FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV TZ=Europe/Rome
RUN apt-get -y install wget sudo xvfb wmctrl x11vnc fluxbox screen novnc

ENV DATA_DIR=/rapidphotodownloader
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID rpd
RUN chown -R rpd $DATA_DIR

RUN ulimit -n 2048
RUN echo "rpd ALL=(root) NOPASSWD:/usr/bin/apt-get" >> /etc/sudoers

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R rpd /opt/scripts

USER rpd

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]