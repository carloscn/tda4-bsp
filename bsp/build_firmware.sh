# !/bin/bash

source build.cfg

if [ ! -d "ti-linux-firmware" ]; then
	echo "[INFO] ti-linux-firmware does not exist, Downloading ti-linux-firmware..."
    git clone ${LINUX_FW_REPO} -b ${LINUX_FW_BRANCH} --depth=1
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull ti-linux-firmware done!"
else
    echo "[ERR] Pull ti-linux-firmware failed."
    exit -1
fi

echo "[INFO] Build ti-linux-firmware done!"