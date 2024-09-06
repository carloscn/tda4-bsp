U-Boot Debug Tips
=================

1. After U-boot upgrade, Kernel stops booting

Check if one of the cases below applies:

- Not resetting U-boot environment variables after upgrading/downgrading u-boot version

  From release to release, some of the u-boot environment variables may be changed.
  To guarantee the environment variables are correctly matching the version used,
  it is required to reset the u-boot environment variables When upgrading/downgrading u-boot version.
  When booting up a different version of u-boot, the u-boot boot process can be
  interruptted by hitting any key to get the u-boot prompt. Then, the following command needs
  to issue to reset the u-boot environment variables.

    |   # env default -f -a
    |   # saveenv

- Mix-matching U-boot and Linux kernel version

  There are times that users mix-match u-boot and kernel version from different SDK releases.
  It probably is fine in most cases, but TI recommends the u-boot and kernel are from the same SDK release.
  From release to release, the u-boot environemt variables may change, including load addresses,
  kernel image format, etc. Any of the incompatibility of these changes between u-boot and kernel
  will cause boot issues. Therefore, when u-boot is upgraded or downgreaded,
  a reset of the u-boot environment variables is requried.
  Please see how to reset u-boot environment variables in previous bullet.

2. Not able to boot U-boot with different boot mode

- Check if the instruction for supported u-boot boot modes is followed.

| Please follow instructions in `U-boot User's Guide
    <Users-Guide.html>`__
|

| Different boot modes ues diferent image formats. They are:

  - u-boot-spi.gph
  - rootfs-image.ubi
  - u-boot.bin
  - MLO

.. ifconfig:: CONFIG_sdk in ('PLSDK')

    For Keystone-2 platforms, U-boot can also be brought up using CCS. The step-by-step instruction on booting up u-boot
    with one of the boot modes or using CCS are documented in <Processor_SDK_install_dir>/board-support/u-boot-<ver>/board/ti/ks2_evm/README file.
