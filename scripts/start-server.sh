#!/bin/bash
export LANG=en_US.UTF-8
export DISPLAY=:99

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

echo "---Sleep zZz---"
sleep infinity

export LANG=en_US.UTF-8
python3 -m venv ${DATA_DIR}/rpd
source ${DATA_DIR}/rpd/bin/activate
python3 install.py --virtual-env
deactivate

mkdir ${DATA_DIR}/.cache/runtime-rpd

export XDG_RUNTIME_DIR=${DATA_DIR}/.cache/runtime-rpd/

cd ${DATA_DIR}/rpd/bin/

until ./rapid-photo-downloader; do
	echo "Rapid Photo Downloader crashed with exit code $?.  Respawning.." >&2
	sleep 1
done