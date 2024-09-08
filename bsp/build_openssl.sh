# !/bin/bash

source build.cfg

if [ ! -d "openssl" ]; then
	echo "[INFO] openssl does not exist, Downloading openssl..."
    git clone ${OPENSSL_REPO} -b ${OPENSSL_BRANCH} --depth=1 openssl
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull openssl done!"
else
    echo "[ERR] Pull openssl failed."
    exit -1
fi

pushd openssl
./Configure linux-aarch64 --cross-compile-prefix=${CROSS_COMPILE} --prefix=${PWD}/out
make -j32
make install -j16
popd

echo "[INFO] Build openssl done!"
