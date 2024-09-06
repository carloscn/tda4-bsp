# !/bin/bash

source build.cfg

if [ ! -d "optee_test" ]; then
	echo "[INFO] imx-optee-os does not exist, Downloading optee_test..."
    git clone ${OPTEE_TEST_REPO} -b ${OPTEE_TEST_BRANCH} --depth=1 optee_test
fi

if [ $? -eq 0 ]; then
    echo "[INFO] Pull optee_test done!"
else
    echo "[ERR] Pull optee_test failed."
    exit -1
fi

export TA_DEV_KIT_DIR=${PWD}/optee_os/out/arm-plat-k3/export-ta_arm64
export OPTEE_CLIENT_EXPORT=${PWD}/optee_client/out/export/usr
export CROSS_COMPILE=${ARCH64_CROSS_COMPILE}
export OPENSSL_EXPORT==${PWD}/openssl/out

pushd optee_test
make clean
make ARCH=arm64 CC="-L${OPENSSL_EXPORT}/lib -I${OPENSSL_EXPORT}/include ${ARCH64_CROSS_COMPILE}gcc "
popd

echo "[INFO] Build optee_test done!"