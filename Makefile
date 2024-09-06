include build.cfg
export $(shell sed 's/=.*//' build.cfg)

.PHONY: clean distclean

prepare:
	sudo apt install libgnutls28-dev

linux:
	bash build_linux.sh

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

uboot:
	bash build_uboot.sh

atf: uboot-imx/u-boot.bin
	bash build_atf.sh

optee-os:
	bash build_optee_os.sh

optee-client:
	bash build_optee_client.sh

optee-test:
	bash build_optee_test.sh

optee-example:
	bash build_optee_example.sh

uuc:
	bash build_uuc.sh

firmware:
	bash build_firmware.sh

image:
	bash build_mkimage.sh

ramdisk:
	wget https://www.nxp.com/lgfiles/sdk/lsdk2012/rootfs_lsdk2012_yocto_tiny_arm64.cpio.gz
	mv rootfs_lsdk2012_yocto_tiny_arm64.cpio.gz imx8_yocto_tiny_arm64.cpio.gz

burn:
	sudo dd if=./imx-mkimage/iMX8QM/flash.bin of=${DEV} bs=1k seek=32 conv=fsync && sync

clean:
	rm -rf firmware-imx-8.1.bin firmware-imx-8.1

distclean:
	rm -rf firmware-imx-8.1 imx-atf imx-mkimage
	rm -rf imx-optee-client imx-optee-os imx-uuc
	rm -rf imx-optee-test optee_examples linux-imx scfw uboot-imx
	rm -rf *.tar.gz *.bin
