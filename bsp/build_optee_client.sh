# !/bin/bash

source build.cfg


if [ ! -d "util-linux" ]; then
	echo "[INFO] util-linux does not exist, Downloading util-linux..."
    git clone https://github.com/util-linux/util-linux.git --depth=1 -b v2.40 util-linux
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull util-linux done!"
else
    echo "[ERR] Pull util-linux failed."
    exit -1
fi

pushd util-linux
bash autogen.sh
CC=${ARCH64_CROSS_COMPILE}gcc ./configure --host=aarch64-linux-gnu --prefix=${PWD}/out \
        --disable-all-programs --enable-libuuid
make -j16
make install
popd

if [ ! -d "optee_client" ]; then
	echo "[INFO] optee_client does not exist, Downloading optee_client..."
    git clone ${OPTEE_CLIENT_REPO} -b ${OPTEE_CLIENT_BRANCH} --depth=1 optee_client
fi

if [ $? -eq 0 ]; then
    echo "[INFO] Pull optee_client done!"
else
    echo "[ERR] Pull optee_client failed."
    exit -1
fi

UTILS_OUT=${PWD}/util-linux/out
pushd optee_client
make CC="${ARCH64_CROSS_COMPILE}gcc -L${UTILS_OUT}/lib -I${UTILS_OUT}/include" CROSS_COMPILE="$ARCH64_CROSS_COMPILE" PLATFORM=k3 CFG_TEE_SUPP_LOG_LEVEL=2 RPMB_EMU=0 CFG_ARM64_core=y PKG_CONFIG=pkg-config
popd

echo "[INFO] Build optee_client done!"

#