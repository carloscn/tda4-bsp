# !/bin/bash

source build.cfg

if [ ! -d "trusted-firmware-a" ]; then
	echo "[INFO] atf does not exist, Downloading atf..."
    git clone ${ATF_REPO} -b ${ATF_BRANCH}
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull atf done!"
else
    echo "[ERR] Pull atf failed."
    exit -1
fi

pushd trusted-firmware-a
git checkout 00f1ec6b8740ccd403e641131e294aabacf2a48b
make distclean
make PLAT=k3 TARGET_BOARD=j784s4 SPD=opteed K3_USART=0x8 ARCH=aarch64
popd

echo "[INFO] Build atf done!"