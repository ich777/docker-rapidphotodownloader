FROM ich777/novnc-baseimage

LABEL maintainer="admin@minenet.at"

RUN export TZ=Europe/Rome && \
	apt-get update && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	apt-get -y install --no-install-recommends sudo dbus fonts-takao python3 python3-pip python3-setuptools python3-wheel python3-venv python3-dev python3-gi libxkbcommon-x11-0 adwaita-icon-theme at-spi2-core autoconf automake autotools-dev blt dconf-gsettings-backend dconf-service exiv2 fontconfig gettext gettext-base gir1.2-gdkpixbuf-2.0 gir1.2-gexiv2-0.10 gir1.2-gstreamer-1.0 gir1.2-gudev-1.0 gir1.2-notify-0.7 gir1.2-udisks-2.0 glib-networking glib-networking-common glib-networking-services gsettings-desktop-schemas gstreamer1.0-libav gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-x gtk-update-icon-cache hicolor-icon-theme  i965-va-driver intltool javascript-common libaa1 libaacs0 libarchive-zip-perl libasound2 libasound2-data libass9 libatk-bridge2.0-0 libatk1.0-0 libatk1.0-data libatspi2.0-0 libauthen-sasl-perl libavc1394-0 libavcodec58 libavfilter7 libavformat58 libavresample4 libavutil56 libbdplus0 libbluray2 libbs2b0 libcaca0 libcairo-gobject2 libcairo2 libcap2 libcap2-bin libcdparanoia0 libchromaprint1 libcolord2 libcroco3 libcrystalhd3 libcups2 libcurl3-gnutls libdata-dump-perl libdatrie1 libdconf1 libdv4 libencode-locale-perl libepoxy0 libexif-dev libexif-doc libexiv2-14 libfftw3-double3 libfile-listing-perl libflac8 libflite1 libfont-afm-perl libgd3 libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-bin libgdk-pixbuf2.0-common libgexiv2-2 libgme0 libgphoto2-6 libgphoto2-dev libgphoto2-l10n libgphoto2-port12 libgpm2 libgraphite2-3 libgsm1 libgstreamer-plugins-base1.0-0 gstreamer1.0-plugins-good libgstreamer1.0-0 libgtk-3-0 libgtk-3-bin libgtk-3-common libgudev-1.0-0 libharfbuzz0b libhtml-form-perl libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libiec61883-0 libimage-exiftool-perl libio-html-perl libio-socket-ssl-perl libjack-jackd2-0 libjs-jquery libjson-glib-1.0-0 libjson-glib-1.0-common libltdl7 liblwp-mediatypes-perl liblwp-protocol-https-perl libmailtools-perl libmediainfo0v5 libmime-charset-perl libmms0 libmp3lame0 libmpg123-0 libmysofa0 libnet-http-perl libnet-smtp-ssl-perl libnet-ssleay-perl libnorm1 libnotify4 libnuma1 libogg0 libopenjp2-7 libopenmpt0 libopus0 liborc-0.4-0 libpam-cap libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpgm-5.2-0 libposix-strptime-perl libpostproc55 libproxy1v5 libraw-bin libraw1394-11 libraw19 librest-0.7-0 librsvg2-2 librsvg2-common librubberband2 libsamplerate0 libshine3 libshout3 libsigsegv2 libslang2 libsnappy1v5 libsodium23 libsombok3 libsoup-gnome2.4-1 libsoup2.4-1 libsoxr0 libspeex1 libssh-gcrypt-4 libswresample3 libswscale5 libtag1v5 libtag1v5-vanilla libthai-data libthai0 libtheora0 libtimedate-perl libtinyxml2-6a libtry-tiny-perl libtwolame0 libudisks2-0 libunicode-linebreak-perl liburi-perl libusb-1.0-0 libv4l-0 libv4lconvert0 libva-drm2 libva-x11-2 libva2 libvdpau1 libvisual-0.4-0 libvorbis0a libvorbisenc2 libvorbisfile3 libvpx5 libwavpack1 libwayland-client0 libwayland-cursor0 libwayland-egl1 libwww-perl libwww-robotrules-perl libx264-155 libx265-165 libxcb-render0 libxcb-shm0 libxcb-xfixes0 libxcursor1 libxkbcommon0 libxml-parser-perl libxvidcore4 libzen0v5 libzmq5 libzvbi-common libzvbi0 m4 mesa-va-drivers mesa-vdpau-drivers notification-daemon perl-openssl-defaults pkg-config python3-arrow python3-certifi python3-chardet python3-colorlog python3-dateutil python3-easygui python3-psutil python3-requests python3-sortedcontainers python3-tk python3-tornado python3-urllib3 python3-zmq tk8.6-blt2.5 va-driver-all vdpau-driver-all binfmt-support bzip2-doc curl gir1.2-freedesktop gobject-introspection libbz2-dev libcairo-script-interpreter2 libcairo2-dev libffi-dev libfontconfig1-dev libfreetype6-dev libgirepository1.0-dev libglib2.0-bin libglib2.0-dev libglib2.0-dev-bin libice-dev libjsoncpp1 libllvm6.0 liblzo2-2 libncurses5-dev libncursesw5-dev libpcre16-3 libpcre3-dev libpcre32-3 libpcrecpp0v5 libpipeline1 libpixman-1-dev libpng-dev libpng-tools libpthread-stubs0-dev libreadline-dev libsm-dev libsqlite3-dev libssl-dev libtinfo-dev libx11-dev libx11-doc libxau-dev libxcb-render0-dev libxcb-shm0-dev libxcb1-dev libxdmcp-dev libxext-dev libxft-dev libxrender-dev libxss-dev libxt-dev llvm llvm-6.0 llvm-6.0-dev llvm-6.0-runtime llvm-runtime python3-mako python3-markupsafe tcl-dev tcl8.6-dev tk-dev tk8.6-dev x11proto-core-dev x11proto-dev x11proto-scrnsaver-dev x11proto-xext-dev xorg-sgml-doctools xtrans-dev zlib1g-dev libcairo2-doc libgirepository1.0-doc libglib2.0-doc libice-doc ncurses-doc readline-doc libsm-doc sqlite3-doc libssl-doc libxcb-doc libxext-doc libxt-doc llvm-6.0-doc python3-beaker python-mako-doc tcl-doc tcl8.6-doc tk-doc tk8.6-doc && \
	echo "ko_KR.UTF-8 UTF-8" >> /etc/locale.gen && \ 
	echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen && \
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
	dbus-uuidgen > /var/lib/dbus/machine-id && \
	mkdir -p /var/run/dbus && \
	chmod -R 770 /var/run/dbus/ && \
	chown -R rpd /var/run/dbus/

USER rpd

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]