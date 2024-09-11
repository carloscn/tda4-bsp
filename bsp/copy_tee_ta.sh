#!/bin/bash

source build.cfg

if [ ! -d "${UDISK}/rootfs/" ]; then
    echo "[ERROR] Directory ${UDISK}/rootfs/ does not exist. Exiting."
    exit 1
fi

echo "[INFO] Copying optee ta..."
sudo cp -v optee_benchmark/out/benchmark ${UDISK}/rootfs/usr/bin/ && \
sudo cp -v optee_examples/test_performance/host/optee_test_performance ${UDISK}/rootfs/usr/bin/ && \
sudo cp -v optee_examples/test_performance/ta/67f7d1a5-dba8-48bc-9e79-79aa289e7d74.ta ${UDISK}/rootfs/lib/optee_armtz
if [ $? -eq 0 ]; then
    echo "[INFO] optee ta copied successfully!"
else
    echo "[ERROR] Failed to copy the optee ta."
    exit 1
fi

sync
