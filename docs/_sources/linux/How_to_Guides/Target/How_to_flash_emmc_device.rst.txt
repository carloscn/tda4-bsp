How to flash eMMC device
========================

Following steps will partition, format and populate the eMMC device with
a copy of the SD card rootfs filesystem.

- Copy the mksdboot.sh from host machine <PATH_TO_INSTALLER>/bin/mksdboot.sh
  into the target filesystem.
- Make sure the script has execute permissions.

.. code-block:: bash

    chmod +x mksdboot.sh

- Make sure the board boots with uenv.txt.base so that both SD and eMMC devices
  are available to kernel.
- example output when both SD(mmcblk1) and eMMC(mmcblk0) are available

.. code-block:: console

    root@j721e-evm:~# ls -l /dev/mmcblk*
    brw-rw----    1 root     disk      179,   0 Jul 18 22:49 /dev/mmcblk0
    brw-rw----    1 root     disk      179,  32 Jul 17 22:37 /dev/mmcblk0boot0
    brw-rw----    1 root     disk      179,  64 Jul 17 22:37 /dev/mmcblk0boot1
    crw-------    1 root     root      242,   0 Jul 17 22:37 /dev/mmcblk0rpmb
    brw-rw----    1 root     disk      179,  96 Jul 17 22:37 /dev/mmcblk1
    brw-rw----    1 root     disk      179,  97 Jul 17 22:37 /dev/mmcblk1p1
    brw-rw----    1 root     disk      179,  98 Jul 17 22:37 /dev/mmcblk1p2

- Unmount the eMMC partitions from root kernel

.. code-block:: bash

    umount /dev/mmcblk0*

- Stop the udev daemon to avoid auto mounting the partitions while we are
  formatting the eMMC

.. code-block:: bash

    udevadm control -s

- Partition the eMMC device using mksdboot.sh script as follows:

.. code-block:: console

    root@j721e-evm:~# ./mksdboot.sh --device /dev/mmcblk0
    ./mksdboot.sh: line 83: [: too many arguments
    -- Main device is: /dev/mmcblk1p2
    ************************************************************
    *         THIS WILL DELETE ALL THE DATA ON /dev/mmcblk0        *
    *                                                          *
    *         WARNING! Make sure your computer does not go     *
    *                  in to idle mode while this script is    *
    *                  running. The script will complete,      *
    *                  but your SD card may be corrupted.      *
    *                                                          *
    *         Press <ENTER> to confirm....                     *
    ************************************************************

    ls: /dev/mmcblk0?: No such file or directory
    1024+0 records in
    1024+0 records out

    Welcome to fdisk (util-linux 2.32.1).
    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Device does not contain a recognized partition table.
    Created a new DOS disklabel with disk identifier 0x02f86286.

    Command (m for help): Partition type
       p   primary (0 primary, 0 extended, 4 free)
       e   extended (container for logical partitions)
    Select (default p): Partition number (1-4, default 1): First sector (2048-31080447, default 2048): Last sector, +secto[87597.744275]  mmcblk0: p1 p2
    rs or +size{K,M,G,T,P} (2048-31080447, default 31080447):
    Crea[87597.750177]  mmcblk0: p1 p2
    ted a new partition 1 of type 'Linux' and of size 62 MiB.
    Partition #1 contains a vfat signature.

    Command (m for help): Partition type
       p   primary (1 primary, 0 extended, 3 free)
       e   extended (container for logical partitions)
    Select (default p): Partition number (2-4, default 2): First sector (129024-31080447, default 129024): Last sector, +sectors or +size{K,M,G,T,P} (129024-31080447, default 31080447):
    Created a new partition 2 of type 'Linux' and of size 14.8 GiB.

    Command (m for help): Partition number (1,2, default 2): Hex code (type L to list all codes):
    Changed type of partition 'Linux' to 'W95 FAT32 (LBA)'.

    Command (m for help): Partition number (1,2, default 2):
    The bootable flag on partition 1 is enabled now.

    Command (m for help): The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.

    Formating /dev/mmcblk01 ...
    mkfs.fat 4.1 (2017-01-24)
    mkfs.fat: warning - lowercase labels might not work properly with DOS or Windows
    mke2fs 1.44.3 (10-July-2018)
    64-bit filesystem support is not enabled.  The larger fields afforded by this feature enable full-strength checksumming.  Pass -O 64bit to rectify.
    Discarding device blocks: done
    Creating filesystem with 3868928 4k blocks and 967232 inodes
    Filesystem UUID: a5586362-272d-4fb2-a0cc-56458dfc4b64
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (16384 blocks): done
    Writing superblocks and filesystem accounting information: done

    Partitioning and formatting completed!
    root@j721e-evm:~# [87602.674595] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)

- Now copy the contents of SD card rootfs partition into eMMC device rootfs partition.
  Run the Following commands on the target, one by one.

.. code-block:: bash

    umount /run/media/*
    mkdir /mnt/sd-rootfs
    mount /dev/mmcblk1p2 /mnt/sd-rootfs
    mkdir /mnt/emmc-rootfs
    mount /dev/mmcblk0p2 /mnt/emmc-rootfs
    cp -r /mnt/sd-rootfs/* /mnt/emmc-rootfs
    sync
    umount /mnt/*

- After rebooting the board, The Infotainment Virtual machine can use the rootfs from eMMC
