# !/bin/bash

source build.cfg

if [ ! -d "optee_examples" ]; then
	echo "[INFO] imx-optee-os does not exist, Downloading optee_examples..."
    git clone https://github.com/linaro-swg/optee_examples.git --depth=1
fi

if [ $? -eq 0 ]; then
    echo "[INFO] Pull optee_examples done!"
else
    echo "[ERR] Pull optee_examples failed."
    exit -1
fi

pushd optee_examples

popd

echo "[INFO] Build optee_examples done!"