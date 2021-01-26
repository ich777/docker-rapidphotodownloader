#!/bin/bash
export LANG=en_US.UTF-8
export DISPLAY=:99
export XDG_RUNTIME_DIR=${DATA_DIR}/.cache/runtime-rpd/

echo "---Checking if Rapid Photo Downloader is installed---"
if [ "${FORCE_UPDATE}" == "true" ]; then
	echo "--------------------------------------------"
	echo "---Force Update set to 'true' please wait---"
	echo "---------This can takes some time-----------"
	echo "--------depending on your hardware----------"
	echo "--------------------------------------------"
    sleep 10
    cd ${DATA_DIR}
	if [ -f "${DATA_DIR}/install.py" ]; then
    	rm ${DATA_DIR}/install.py
    fi
    wget "${DL_URL}"
	if [ ! -f "${DATA_DIR}/install.py" ]; then
		echo "---------------------------------------------"
		echo "---Something went wrong, couldn't download---"
		echo "---'install.py' please check the download----"
		echo "---link or place the file manually in the----"
		echo "----------root of your serverfolder----------"
		echo "---------------------------------------------"
		sleep infinity
	fi
	python3 -m venv ${DATA_DIR}/rpd
	source ${DATA_DIR}/rpd/bin/activate
	python3 install.py --virtual-env
	deactivate
else
	if [ ! -f "${DATA_DIR}/rpd/bin/rapid-photo-downloader" ]; then
		echo "--------------------------------------"
		echo "---Rapid Photo Downloader not found---"
    	echo "-------This can takes some time-------"
    	echo "------depending on your hardware------"
    	echo "--------------------------------------"
        sleep 10
		cd ${DATA_DIR}
		if [ ! -f "${DATA_DIR}/install.py" ]; then
			wget "${DL_URL}"
            if [ ! -f "${DATA_DIR}/install.py" ]; then
            	echo "---------------------------------------------"
            	echo "---Something went wrong, couldn't download---"
            	echo "---'install.py' please check the download----"
            	echo "---link or place the file manually in the----"
            	echo "----------root of your serverfolder----------"
            	echo "---------------------------------------------"
            	sleep infinity
            fi
		fi
		python3 -m venv ${DATA_DIR}/rpd
		source ${DATA_DIR}/rpd/bin/activate
		python3 install.py --virtual-env
		deactivate
	else
		echo "---Rapid Photo Downloader found---"
	fi
fi

echo "---Preparing directories---"
if [ ! -d "${DATA_DIR}/.cache/runtime-rpd" ]; then
	if [ ! -d "${DATA_DIR}/.cache" ]; then
    	mkdir ${DATA_DIR}/.cache
    fi
	mkdir ${DATA_DIR}/.cache/runtime-rpd
fi

if [ ! -d "${DATA_DIR}/.config/Rapid Photo Downloader" ]; then
	if [ ! -d "${DATA_DIR}/.config" ]; then
    	mkdir ${DATA_DIR}/.config
    fi
    mkdir "${DATA_DIR}/.config/Rapid Photo Downloader"
fi

if [ ! -d "${DATA_DIR}/.local/share" ]; then
	if [ ! -d "${DATA_DIR}/.local" ]; then
    	mkdir ${DATA_DIR}/.local
    fi
    mkdir ${DATA_DIR}/.local/share
fi

echo "---Resolution check---"
if [ -z "${CUSTOM_RES_W} ]; then
	CUSTOM_RES_W=1024
fi
if [ -z "${CUSTOM_RES_H} ]; then
	CUSTOM_RES_H=881
fi

if [ "${CUSTOM_RES_W}" -le 999 ]; then
	echo "---Width to low must be a minimal of 1000 pixels, correcting to 1000...---"
    CUSTOM_RES_W=1000
fi
if [ "${CUSTOM_RES_H}" -le 879 ]; then
	echo "---Height to low must be a minimal of 880 pixels, correcting to 880...---"
    CUSTOM_RES_H=880
fi

if [ ! -f "${DATA_DIR}/.config/Rapid Photo Downloader/Rapid Photo Downloader.conf" ]; then
    cd "${DATA_DIR}/.config/Rapid Photo Downloader/"
    touch "Rapid Photo Downloader.conf"
	echo "[Automation]
verify_file=false

[Display]
did_you_know_on_startup=true
ignore_unhandled_file_exts=TMP, DAT

[MainWindow]
windowPosition=@Point(0 0)
windowSize=@Size(${CUSTOM_RES_W} ${CUSTOM_RES_H})

[Device]
device_autodetection=false
this_computer_path=/mnt
this_computer_source=true

[Rename]
photo_download_folder=/media" >> "${DATA_DIR}/.config/Rapid Photo Downloader/Rapid Photo Downloader.conf"
fi

WINDOWRES=$(grep -e 'windowSize=@Size(.... ' ${DATA_DIR}/.config/Rapid\ Photo\ Downloader/Rapid\ Photo\ Downloader.conf)

if [ "$WINDOWRES" != "windowSize=@Size(${CUSTOM_RES_W} ${CUSTOM_RES_H})" ]; then
	echo "---Window resoltuion changed to ${CUSTOM_RES_W}x${CUSTOM_RES_H}, writing to config file---"
	sed -i "/$WINDOWRES/c\windowSize=@Size(${CUSTOM_RES_W} ${CUSTOM_RES_H})" "${DATA_DIR}/.config/Rapid Photo Downloader/Rapid Photo Downloader.conf"
else
	echo "---Window resolution: ${CUSTOM_RES_W}x${CUSTOM_RES_H}---"
fi

echo "---Preparing Server---"
echo "---Checking for old logfiles---"
find $DATA_DIR -name "XvfbLog.*" -exec rm -f {} \;
find $DATA_DIR -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old lock files---"
find /tmp -name ".X99*" -exec rm -f {} \;
find /var/run/dbus -name "pid" -exec rm -f {} \;

chmod -R ${DATA_PERM} ${DATA_DIR}
chmod -R 7700 ${DATA_DIR}/.cache

echo "---Starting dbus service---"
if dbus-daemon --config-file=/usr/share/dbus-1/system.conf ; then
	echo "---dbus service started---"
else
	echo "---Couldn't start dbus service---"
	sleep infinity
fi
sleep 5

echo "---Starting Xvfb server---"
screen -S Xvfb -L -Logfile ${DATA_DIR}/XvfbLog.0 -d -m /opt/scripts/start-Xvfb.sh
sleep 5

echo "---Starting x11vnc server---"
screen -S x11vnc -L -Logfile ${DATA_DIR}/x11vncLog.0 -d -m /opt/scripts/start-x11.sh
sleep 5

echo "---Starting noVNC server---"
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem ${NOVNC_PORT} localhost:${RFB_PORT}
sleep 5

echo "---Starting Rapid Photo Downloader---"
cd ${DATA_DIR}/rpd/bin
until ${DATA_DIR}/rpd/bin/rapid-photo-downloader; do
	echo "Rapid Photo Downloader crashed with exit code $?.  Respawning.." >&2
	sleep 1
done