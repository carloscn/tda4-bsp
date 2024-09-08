# !/bin/bash

source build.cfg

if [ ! -d "optee_examples" ]; then
	echo "[INFO] imx-optee-os does not exist, Downloading optee_examples..."
    git clone ${OPTEE_EXAMPLES_REPO} -b ${OPTEE_EXAMPLES_BRANCH} --depth=1 optee_examples
fi

if [ $? -eq 0 ]; then
    echo "[INFO] Pull optee_examples done!"
else
    echo "[ERR] Pull optee_examples failed."
    exit -1
fi

export TA_DEV_KIT_DIR=${PWD}/optee_os/out/arm-plat-k3/export-ta_arm64
export OPTEE_CLIENT_EXPORT=${PWD}/optee_client/out/export/usr
export CROSS_COMPILE=${ARCH64_CROSS_COMPILE}
export OPENSSL_EXPORT==${PWD}/openssl/out

pushd optee_examples
make clean
make PLATFORM=arm \
     HOST_CROSS_COMPILE=${ARCH64_CROSS_COMPILE} \
     TEEC_EXPORT=${OPTEE_CLIENT_EXPORT} \
     TA_DEV_KIT_DIR=${TA_DEV_KIT_DIR} \
     -j16
popd

echo "[INFO] Build optee_examples done!"