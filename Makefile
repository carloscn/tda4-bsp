include build.cfg
export $(shell sed 's/=.*//' build.cfg)

.PHONY: all clean distclean atf linux optee-os optee-client openssl mbedtls optee-test uboot

all: atf linux optee-os optee-client openssl mbedtls optee-test linux uboot

# Prepare dependencies
prepare:
	sudo apt install libgnutls28-dev

# Build steps for each component
atf:
	@echo "[INFO] Building ATF..."
	bash build_atf.sh

linux:
	@echo "[INFO] Building Linux..."
	bash build_linux.sh

optee-os:
	@echo "[INFO] Building OP-TEE OS..."
	bash build_optee_os.sh

optee-client: optee-os
	@echo "[INFO] Building OP-TEE Client..."
	if [ -f optee_os/out/arm-plat-k3/core/tee-pager_v2.bin ]; then \
		bash build_optee_client.sh; \
	else \
		echo "OP-TEE OS needs to be built first."; exit 1; \
	fi

openssl:
	@echo "[INFO] Building OpenSSL..."
	bash build_openssl.sh

mbedtls:
	@echo "[INFO] Building MbedTLS..."
	bash build_mbedtls.sh

optee-test:
	@echo "[INFO] Building OP-TEE Test..."
	bash build_optee_test.sh; \

optee-example:
	bash build_optee_example.sh

uboot: atf optee-os
	@echo "[INFO] Building U-Boot..."
	if [ -f trusted-firmware-a/build/k3/j784s4/release/bl31.bin ] && \
	   [ -f optee_os/out/arm-plat-k3/core/tee-pager_v2.bin ]; then \
		bash build_uboot.sh; \
	else \
		echo "ATF or OP-TEE OS is not built correctly."; exit 1; \
	fi

# Additional targets
kernel:
	@echo "[INFO] Gen key."
	openssl genpkey -algorithm RSA -out keys/dev.key -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_pubexp:65537
	openssl req -batch -new -x509 -key keys/dev.key -out keys/dev.crt
	openssl rsa -in keys/dev.key -pubout
	cp -rfv ./uboot-imx/arch/arm/dts/imx8mq-evk.dtb ./uboot-imx/imx8mq-evk-with-pubkey.dtb
	./uboot-imx/tools/mkimage -f configs/imx8_linux_arm64.its -k keys -K ./uboot-imx/imx8mq-evk-with-pubkey.dtb -r image.ub
	sha256sum image.ub
	-./uboot-imx/tools/fit_check_sign -f image.ub -k ./uboot-imx/imx8mq-evk-with-pubkey.dtb -c imx8
	cd uboot-imx && CROSS_COMPILE=${CROSS_COMPILE} EXT_DTB=./imx8mq-evk-with-pubkey.dtb make -j16

firmware:
	@echo "[INFO] Building Firmware..."
	bash build_firmware.sh

image:
	@echo "[INFO] Creating Image..."
	bash build_mkimage.sh

ramdisk:
	@echo "[INFO] Downloading Ramdisk..."
	wget https://www.nxp.com/lgfiles/sdk/lsdk2012/rootfs_lsdk2012_yocto_tiny_arm64.cpio.gz
	mv rootfs_lsdk2012_yocto_tiny_arm64.cpio.gz imx8_yocto_tiny_arm64.cpio.gz

burn:
	@echo "[INFO] Burning Image..."
	sudo dd if=./imx-mkimage/iMX8QM/flash.bin of=${DEV} bs=1k seek=32 conv=fsync && sync

clean:
	@echo "[INFO] Cleaning build files..."
	rm -rf build

distclean: clean
	@echo "[INFO] Performing distclean..."
	rm -rf optee_os optee_client optee_test
	rm -rf ti-linux-kernel trusted-firmware-a ti-u-boot
	rm -rf openssl mbedtls
	rm -rf *.tar.gz *.bin
