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
	python3 -m venv ${DATA_DIR}/rpd
	source ${DATA_DIR}/rpd/bin/activate
	python3 install.py --virtual-env
	deactivate
else
	if [ ! -d "${DATA_DIR}/rpd" ]; then
		echo "--------------------------------------"
		echo "---Rapid Photo Downloader not found---"
    	echo "-------This can takes some time-------"
    	echo "------depending on your hardware------"
    	echo "--------------------------------------"
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

if [ ! -f "${DATA_DIR}/.config/Rapid Photo Downloader/Rapid Photo Downloader.conf" ]; then
    cd "${DATA_DIR}/.config/Rapid Photo Downloader/"
    touch "Rapid Photo Downloader.conf"
	echo "[MainWindow]
windowPosition=@Point(0 0)
windowSize=@Size(1024 881)" >> "${DATA_DIR}/.config/Rapid Photo Downloader/Rapid Photo Downloader.conf
fi

echo "---Preparing Server---"
echo "---Checking for old logfiles---"
find $DATA_DIR -name "XvfbLog.*" -exec rm -f {} \;
find $DATA_DIR -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old display lock files---"
find /tmp -name ".X99*" -exec rm -f {} \;
chmod -R 770 ${DATA_DIR}

echo "---Starting Xvfb server---"
screen -S Xvfb -L -Logfile ${DATA_DIR}/XvfbLog.0 -d -m /opt/scripts/start-Xvfb.sh
sleep 5

echo "---Starting x11vnc server---"
screen -S x11vnc -L -Logfile ${DATA_DIR}/x11vncLog.0 -d -m /opt/scripts/start-x11.sh
sleep 5

echo "---Starting noVNC server---"
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 8080 localhost:5900
sleep 5

echo "---Starting Rapid Photo Downloader---"
until ${DATA_DIR}/rpd/bin/rapid-photo-downloader; do
	echo "Rapid Photo Downloader crashed with exit code $?.  Respawning.." >&2
	sleep 1
done