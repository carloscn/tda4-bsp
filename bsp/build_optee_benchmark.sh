# !/bin/bash

source build.cfg

if [ ! -d "optee_benchmark" ]; then
	echo "[INFO] optee-benchmark does not exist, Downloading optee_benchmark..."
    git clone ${OPTEE_BENCHMARK_REPO} -b ${OPTEE_BENCHMARK_BRANCH} --depth=1
fi

if [ $? -eq 0 ]; then
    echo "[INFO] Pull optee_benchmark done!"
else
    echo "[ERR] Pull optee_benchmark failed."
    exit -1
fi

export TA_DEV_KIT_DIR=${PWD}/optee_os/out/arm-plat-k3/export-ta_arm64
export OPTEE_CLIENT_EXPORT=${PWD}/optee_client/out/export/usr
export CROSS_COMPILE=${ARCH64_CROSS_COMPILE}
export CC=${ARCH64_CROSS_COMPILE}gcc
export MULTIARCH=aarch64-linux-gnu
pushd optee_benchmark
make clean
make PLATFORM=arm \
     TEEC_INTERNAL_INCLUDES=${PWD}/optee_client/libteec \
     TEEC_EXPORT=${OPTEE_CLIENT_EXPORT} \
     HOST_CROSS_COMPILE=${ARCH64_CROSS_COMPILE} \
     TA_DEV_KIT_DIR=${TA_DEV_KIT_DIR} \
     -j16
popd

echo "[INFO] Build optee_benchmark done!"