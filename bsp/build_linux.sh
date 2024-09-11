# !/bin/bash

source build.cfg

if [ ! -d "ti-linux-kernel" ]; then
	echo "[INFO] linux does not exist, Downloading linux..."
    git clone ${LINUX_REPO} -b ${LINUX_BRANCH} --depth=1
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull ti-linux-kernel done!"
else
    echo "[ERR] Pull ti-linux-kernel failed."
    exit -1
fi

pushd ti-linux-kernel
make CROSS_COMPILE=${CROSS_COMPILE} ARCH=arm64 defconfig ti_arm64_prune.config
make CROSS_COMPILE=${CROSS_COMPILE} ARCH=arm64 -j16
popd

echo "[INFO] Build Linux done!"