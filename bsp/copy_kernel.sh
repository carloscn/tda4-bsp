#!/bin/bash

source build.cfg

if [ ! -d "${UDISK}/rootfs/boot/" ]; then
    echo "[ERROR] Directory ${UDISK}/rootfs/boot/ does not exist. Exiting."
    exit 1
fi

echo "[INFO] Copying kernel..."
sudo cp -v ti-linux-kernel/arch/arm64/boot/Image "${UDISK}/rootfs/boot/"
if [ $? -eq 0 ]; then
    echo "[INFO] Kernel copied successfully!"
else
    echo "[ERROR] Failed to copy the kernel."
    exit 1
fi

sync
