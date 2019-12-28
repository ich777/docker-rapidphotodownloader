FROM ich777/novnc-baseimage

LABEL maintainer="admin@minenet.at"

RUN export TZ=Europe/Rome && \
	apt-get update && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	apt-get -y install --no-install-recommends sudo && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i '/    document.title =/c\    document.title = "RapidPhotoDownloader - noVNC";' /usr/share/novnc/app/ui.js && \
	rm /usr/share/novnc/app/images/icons/*

ENV DATA_DIR=/rapidphotodownloader
ENV DL_URL="https://launchpad.net/rapid/pyqt/0.9.17/+download/install.py"
ENV FORCE_UPDATE=""
ENV CUSTOM_RES_W=1024
ENV CUSTOM_RES_H=881
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR	&& \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID rpd && \
	chown -R rpd $DATA_DIR && \
	ulimit -n 2048 && \
	echo "rpd ALL=(root) NOPASSWD:/usr/bin/apt-get" >> /etc/sudoers

ADD /scripts/ /opt/scripts/
COPY /icons/* /usr/share/novnc/app/images/icons/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R rpd /opt/scripts/ && \
	chmod -R 770 /var/run/dbus/ && \
	chown -R rpd /var/run/dbus/

USER rpd

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]