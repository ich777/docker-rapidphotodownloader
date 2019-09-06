FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN apt-get -y install wget python3 python3-setuptools python3-pyqt5

ENV DATA_DIR=/rapidphotodownloader
ENV DL_URL="https://launchpad.net/rapid/pyqt/0.9.17/+download/install.py"
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID rpd
RUN chown -R rpd $DATA_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R rpd /opt/scripts

USER rpd

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]