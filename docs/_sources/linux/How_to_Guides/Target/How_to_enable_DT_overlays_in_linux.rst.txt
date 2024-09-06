.. include:: /_replacevars.rst

.. _howto_dt_overlays:

How to enable DT overlays in linux
==================================

The Processor SDK (PSDK) Linux supports various features in the form of device-tree overlays appended on top of the board device-tree source files. These features can only be used after enabling their respective overlay blobs (\*.dtbo files). Below are the steps to compile the DT overlay sources, install them on the sd card, and enable them at the u-boot stage. The "default" SDK wic image comes with the overlay blobs pre-loaded on the sd card, and steps 3 through 5 can be skipped, if there are no custom changes required on the DT overlay sources.

**Note:** These steps are only applicable for GP and HS-FS devices. For HS-SE devices, follow steps 1 through 4, and post that, kindly refer to: :ref:`fitImage-for-HS`, to package the requrired DTBOs in the fitImage.

**Steps to enable DT overlays:**

#. Flash the SD card with the standard wic image.
#. If the SD card got auto-ejected after flashing, re-plug it.
#. On the host machine, build dtbs in the PSDK linux source tree, without any changes.

    ::

        $ make CROSS_COMPILE=aarch64-none-linux-gnu- ARCH=arm64 clean
        $ make CROSS_COMPILE=aarch64-none-linux-gnu- ARCH=arm64 dtbs

#. If the build is successful, the required DT overlay files shall be found as below:

    ::

        $ ls arch/arm64/boot/dts/ti/k3-<required-soc>-*.dtbo

#. Copy this DT overlay file to the ``boot/dtb/ti`` directory of the root partition of the SD card.

    ::

        $ sudo cp arch/arm64/boot/dts/ti/k3-<overlay>.dtbo <path-to-sd>/root/boot/dtb/ti/

#. Update the ``uEnv.txt`` file to let u-boot recognize the overlay. Depending on the use-case, multiple DT overlays can also be added, using "space" as the delimiter.

    ::

        name_overlays=k3-<overlay-1>.dtbo k3-<overlay-2>.dtbo k3-<overlay-3>.dtbo

#. Unmount and eject the SD card. Plug it back in the |__PART_FAMILY_DEVICE_NAMES__| board and turn the board on.
