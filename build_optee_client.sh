# !/bin/bash

source build.cfg

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
make CROSS_COMPILE="$ARCH64_CROSS_COMPILE" PLATFORM=k3 CFG_TEE_SUPP_LOG_LEVEL=2 RPMB_EMU=0 CFG_ARM64_core=y
popd

echo "[INFO] Build optee_client done!"