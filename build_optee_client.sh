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

export CC=${ARCH64_CROSS_COMPILE}gcc
pushd util-linux
bash autogen.sh
CC=${ARCH64_CROSS_COMPILE}gcc ./configure --host=aarch64-none-linux-gnu --prefix=${PWD}/out --without-ncures
make uuidd -j8
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


pushd optee_client
make CC="-L${PWD}/../util-linux/.libs -I${OPENSSL_EXPORT}/include ${ARCH64_CROSS_COMPILE}gcc " CROSS_COMPILE="$ARCH64_CROSS_COMPILE" PLATFORM=k3 CFG_TEE_SUPP_LOG_LEVEL=2 RPMB_EMU=0 CFG_ARM64_core=y PKG_CONFIG=pkg-config
popd

echo "[INFO] Build optee_client done!"

#