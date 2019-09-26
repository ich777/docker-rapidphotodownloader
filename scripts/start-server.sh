#!/bin/bash

echo "---Starting Xvfb server---"
screen -S Xvfb -L -Logfile ${DATA_DIR}/XvfbLog.0 -d -m /opt/scripts/start-Xvfb.sh
sleep 5
echo "---Starting x11vnc server---"
screen -S x11vnc -L -Logfile ${DATA_DIR}/x11vncLog.0 -d -m /opt/scripts/start-x11.sh
sleep 5

echo "---Starting noVNC server---"
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 8080 localhost:5900
sleep 5

echo "---Sleep zZz---"
sleep infinity

INSTALL_V="$(echo ${DL_URL} | cut -d '/' -f6)"


cd ${DATA_DIR}
echo "---Downloading install script version: $INSTALL_V---"
wget -qi install.py ${DL_URL}


echo "---Preparing Server---"
echo "---Checking for old logfiles---"
find $DATA_DIR -name "XvfbLog.*" -exec rm -f {} \;
find $DATA_DIR -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old display lock files---"
find /tmp -name ".X99*" -exec rm -f {} \;
chmod -R 770 ${DATA_DIR}




echo "---Starting Rapid Photo Downloader---"
