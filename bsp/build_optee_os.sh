# !/bin/bash

source build.cfg

if [ ! -d "optee_os" ]; then
	echo "[INFO] optee_os does not exist, Downloading optee_os..."
    git clone ${OPTEE_OS_REPO} -b ${OPTEE_OS_BRANCH} --depth=1 optee_os
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull optee_os done!"
else
    echo "[ERR] Pull optee_os failed."
    exit -1
fi

pushd optee_os
make clean
make distclean
make all -j16 \
     CROSS_COMPILE=${ARCH32_CROSS_COMPILE} \
     CROSS_COMPILE64=${ARCH64_CROSS_COMPILE} \
     PLATFORM=k3-j721e \
     CFG_ARM64_core=y \
     CFG_TEE_BENCHMARK=y \
     CFG_TEE_CORE_LOG_LEVEL=2 \
     CFG_TEE_CORE_DEBUG=y \
     CFG_CORE_DUMP_OOM=y
popd

echo "[INFO] Build optee_os done!"
