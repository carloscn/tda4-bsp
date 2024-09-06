# !/bin/bash

source build.cfg

if [ ! -d "imx-mkimage" ]; then
	echo "[INFO] imx-mkimage does not exist, Downloading imx-mkimage..."
    git clone https://github.com/nxp-imx/imx-mkimage.git -b ${MKIMAGE_BRANCH} --depth=1
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull imx-mkimage done!"
else
    echo "[ERR] Pull imx-mkimage failed."
    exit -1
fi

pushd imx-mkimage
mkdir -p iMX8QM
cp -rfv ../uboot-imx/tools/mkimage                                                        ./iMX8QM/mkimage_uboot && \
cp -rfv ../uboot-imx/spl/u-boot-spl.bin                                                   ./iMX8QM/              && \
cp -rfv ../uboot-imx/u-boot-nodtb.bin                                                     ./iMX8QM/              && \
cp -rfv ../uboot-imx/u-boot.bin                                                           ./iMX8QM/              && \
cp -rfv ../uboot-imx/arch/arm/dts/imx8mp-evk.dtb                                          ./iMX8QM/              && \
cp -rfv ../atf-imx/build/imx8qm/release/bl31.bin                                          ./iMX8QM/              && \
cp -rfv ../firmware-imx-8.1/firmware/ddr/synopsys/lpddr4_pmu_train_1d_dmem.bin            ./iMX8QM/              && \
cp -rfv ../firmware-imx-8.1/firmware/ddr/synopsys/lpddr4_pmu_train_1d_dmem.bin            ./iMX8QM/              && \
cp -rfv ../firmware-imx-8.1/firmware/ddr/synopsys/lpddr4_pmu_train_2d_dmem.bin            ./iMX8QM/              && \
cp -rfv ../firmware-imx-8.1/firmware/ddr/synopsys/lpddr4_pmu_train_2d_imem.bin            ./iMX8QM/              && \
cp -rfv ../firmware-imx-8.1/firmware/hdmi/cadence/signed_hdmi_imx8m.bin                   ./iMX8QM/              && \
cp -rfv ../firmware-imx-8.1/firmware/seco/mx8qm-ahab-container.img                        ./iMX8QM/mx8qmb0-ahab-container.img && \
cp -rfv ../imx-scfw-porting-kit-1.7.4/src/scfw_export_mx8qm_b0/build_mx8qm_b0/scfw_tcm.bin ./iMX8QM/
if [ $? -ne 0 ]; then
    echo "[ERR] Copy binary failed."
    exit -1
fi
make clean
make SOC=iMX8QM flash
if [ $? -ne 0 ]; then
    echo "[ERR] make failed."
    exit -1
fi
popd

cp -rfv imx-mkimage/iMX8QM/flash.bin ./
./uuu -b sd flash.bin

echo "[INFO] Build imx-mkimage done!"