# !/bin/bash

source build.cfg

if [ ! -d "mbedtls" ]; then
	echo "[INFO] mbedtls does not exist, Downloading mbedtls..."
    git clone ${MBEDTLS_REPO} -b ${MBEDTLS_BRANCH} --depth=1 mbedtls
fi

if [ $? -eq 0 ]; then
    echo "[INFO] Pull mbedtls done!"
else
    echo "[ERR] Pull mbedtls failed."
    exit -1
fi

pushd mbedtls
python3 -m pip install --user -r scripts/basic.requirements.txt

# Setting DEBUG gives you a debug build.
make CC=${CROSS_COMPILE}gcc SHARED=1 -j16
make install DESTDIR=${PWD}/out
if [ $? -eq 0 ]; then
    echo "[INFO] Build mbedtls done!"
else
    echo "[ERR] Build mbedtls failed."
    exit -1
fi
popd

echo "[INFO] Build mbedtls done!"