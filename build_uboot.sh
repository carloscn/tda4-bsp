# !/bin/bash

source build.cfg

if [ ! -d "ti-u-boot" ]; then
	echo "[INFO] uboot does not exist, Downloading uboot..."
    git clone ${UBOOT_REPO} -b ${UBOOT_BRANCH} --depth=1 ti-u-boot
fi

if [ $? -eq 0 ]; then
    echo "[INFO] Pull ti-u-boot done!"
else
    echo "[ERR] Pull ti-u-boot failed."
    exit -1
fi

export BL31=${PWD}/trusted-firmware-a/build/k3/j784s4/release/bl31.bin
export TEE=${PWD}/optee_os/out/arm-plat-k3/core/tee-pager_v2.bin
export FIRMWARE_DIR=${PWD}/firmware

pushd ti-u-boot
make clean
make ARCH=arm CROSS_COMPILE=${CROSS_COMPILE} j784s4_evm_a72_defconfig
make ARCH=arm \
     CROSS_COMPILE="$CROSS_COMPILE" \
     BL31=${BL31} \
     TEE=${TEE} \
     DM="$FIRMWARE_DIR/ti-dm/j721e/ipc_echo_testb_mcu1_0_release_strip.xer5f" \
     BINMAN_INDIRS=$FIRMWARE_DIR \
     -j16

if [ $? -eq 0 ]; then
    echo "[INFO] Build ti-u-boot done!"
else
    echo "[ERR] Build ti-u-boot failed."
    exit -1
fi
popd

echo "[INFO] Build uboot done!"