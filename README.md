# Rapid Photo Downloader in Docker optimized for Unraid
This Docker will download and install Rapid Photo Downloader.

Please also check out the Developers website of Rapid Photo Downloader: https://www.damonlynch.net/rapid/


## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for RPD | /rapidphotodownloader |
| DL_URL | Download URL for DirSyncPro | https://launchpad.net/rapid/pyqt/0.9.17/+down... |
| FORECE_UPDATE | Set to 'true' if you want to force a update (otherwise leave blank) | |
| CUSTOM_RES_W | Minimum of 1000 pixesl (leave blank for 1024 pixels) | 1024 |
| CUSTOM_RES_H | Minimum of 880 pixesl (leave blank for 881 pixels) | 881 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |


## Run example
```
docker run --name RapidPhotoDownloader -d \
    -p 8080:8080 \
    --env 'DL_URL=https://launchpad.net/rapid/pyqt/0.9.17/+download/install.py' \
    --env 'CUSTOM_RES_W=1280' \
    --env 'CUSTOM_RES_H=1024' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /mnt/user/appdata/rapidphotodownloader:/rapidphotodownloader \
    --volume /mnt/user/destination_folder:/media/destination \
    --volume /mnt/user/source_folder:/media/source \
    --restart=unless-stopped \
    ich777/rapidphotodownloader
```
### Webgui address: http://[SERVERIP]:[PORT]/vnc_auto.html


Please check also the Developers (Damon Lynch) website out: https://www.damonlynch.net/ or from RPD: https://www.damonlynch.net/rapid/


#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/