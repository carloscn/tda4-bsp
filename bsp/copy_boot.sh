# !/bin/bash

source build.cfg

if [ ! -d "${UDISK}/BOOT/" ]; then
    echo "[ERROR] Directory ${UDISK}/BOOT/ does not exist. Exiting."
    exit 1
fi

echo "[INFO] copy SPL/OPTEE etc bootloader!"
cp -v ti-u-boot/tispl.bin ${UDISK}/BOOT/tispl.bin && \
echo "[INFO] copy U-Boot bootloader!" && \
cp -v ti-u-boot/u-boot.img ${UDISK}/BOOT/u-boot.img
if [ $? -eq 0 ]; then
    echo "[INFO] copied successfully!"
else
    echo "[ERROR] Failed to copy."
    exit 1
fi

sync

# tiboot3.bin
# +-----------------------+
# |        X.509          |
# |      Certificate      |
# | +-------------------+ |
# | |                   | |
# | |        R5         | |
# | |   u-boot-spl.bin  | |
# | |                   | |
# | +-------------------+ |
# | |                   | |
# | |     FIT header    | |
# | | +---------------+ | |
# | | |               | | |
# | | |   DTB 1...N   | | |
# | | +---------------+ | |
# | +-------------------+ |
# +-----------------------+

# tispl.bin
# +-----------------------+
# |                       |
# |       FIT HEADER      |
# | +-------------------+ |
# | |                   | |
# | |      A72 ATF      | |
# | +-------------------+ |
# | |                   | |
# | |     A72 OPTEE     | |
# | +-------------------+ |
# | |                   | |
# | |      R5 DM FW     | |
# | +-------------------+ |
# | |                   | |
# | |      A72 SPL      | |
# | +-------------------+ |
# | |                   | |
# | |   SPL DTB 1...N   | |
# | +-------------------+ |
# +-----------------------+

#sysfw.itb
# +-----------------------+
# |                       |
# |       FIT HEADER      |
# | +-------------------+ |
# | |                   | |
# | |     sysfw.bin     | |
# | +-------------------+ |
# | |                   | |
# | |    board config   | |
# | +-------------------+ |
# | |                   | |
# | |     PM config     | |
# | +-------------------+ |
# | |                   | |
# | |     RM config     | |
# | +-------------------+ |
# | |                   | |
# | |    Secure config  | |
# | +-------------------+ |
# +-----------------------+
