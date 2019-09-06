#!/bin/bash

echo "---Sleep zZz---"
sleep infinity

INSTALL_V="$(echo ${DL_URL} | cut -d '/' -f6)"


cd ${DATA_DIR}
echo "---Downloading install script version: $INSTALL_V---"
wget -qi install.py ${DL_URL}
