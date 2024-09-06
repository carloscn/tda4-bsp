.. http://processors.wiki.ti.com/index.php/Moving_Files_to_the_Target_System

Moving Files to the Target System
==========================================

.. rubric:: Introduction
   :name: introduction-linux-moving-files-to-fs

This guide discusses how applications or other files can be moved to the
target file system of the EVM.

.. rubric:: File System on SD card
   :name: file-systemon-sd-card

The SD card which comes with the TI SDK has a Linux ext3 or ext4 partition
that is used as the target file system.  This partition is readable from a
Linux host.  In Ubuntu 10.04 this partition will be mounted on
**/media/rootfs** when the card is used with an SD card reader inserted
into a USB port on the Ubuntu host. 

When the SD card is mounted with a card reader in the Linux host it is
possible to perform "cp" commands from the host into sub-directories
under /media/rootfs or just use a browser window to drag and drop the
files from the host to the SD card.

Switching the SD card back and forth from the EVM to the SD card reader
is time consuming during development.  Using a NFS during development is
the preferred method and makes moving files between the host and target
trivial.

.. rubric:: File System on Network File System (NFS)
   :name: file-system-on-network-file-system-nfs

When the target file system is served from the Linux development host
machine it is trivial to move files between the host and target.  The
NFS directory is set up on the host machine by the SDK installer.  The
default location in the SDK environment is
**<path to SDK>/targetNFS**.  This could vary
depending on the version of the SDK and how it was installed.  An "ls
-l" of this directory in the host system will show what will be the root
directory of the target when it boots up.

::

    user@U1004GT:~/ti-sdk-AM3715-evm-4.0.0.0/filesystem$ pwd
    /home/user/ti-sdk-AM3715-evm-4.0.0.0/filesystem
    user@U1004GT:~/ti-sdk-AM3715-evm-4.0.0.0/filesystem$ ls -l
    total 60
    drwxr-xr-x  2 root root 4096 2010-05-07 07:51 bin
    drwxr-xr-x  2 root root 4096 2010-05-07 00:30 boot
    drwxr-xr-x  2 root root 4096 2010-05-05 16:28 dev
    drwxr-xr-x 24 root root 4096 2010-05-14 10:46 etc
    drwxr-xr-x  3 root root 4096 2010-05-07 00:29 home
    drwxr-xr-x  4 root root 4096 2010-05-07 00:30 lib
    lrwxrwxrwx  1 root root   12 2010-05-13 09:35 linuxrc -> /bin/busybox
    drwxr-xr-x 13 root root 4096 2010-05-14 11:01 media
    drwxr-xr-x  2 root root 4096 2010-05-07 00:29 mnt
    drwxr-xr-x  2 root root 4096 2010-05-05 16:28 proc
    drwxr-xr-x  2 root root 4096 2010-05-07 07:51 sbin
    drwxr-xr-x  2 root root 4096 2010-05-07 07:51 Settings
    drwxr-xr-x  3 root root 4096 2010-05-07 00:29 srv
    drwxr-xr-x  2 root root 4096 2010-05-05 16:28 sys
    lrwxrwxrwx  1 root root    8 2010-05-13 09:35 tmp -> /var/tmp
    drwxr-xr-x 10 root root 4096 2010-05-07 08:43 usr
    drwxr-xr-x  7 root root 4096 2010-05-04 21:54 var
    user@U1004GT:~/ti-sdk-AM3715-evm-4.0.0.0/filesystem$

So from the perspective of the host, the target filesystem is just a
sub-directory of the host.  If the file is in ./targetNFS on the host,
then the same file will show up in the root directory of the target
after the target boots into the NFS.  And if the file is in a
subdirectory of ./targetNFS (example ./targetNFS/sub-dir) then it will
show up in the /sub-dir directory of the target after the target boots
into the NFS.

The top level makefile of the TI SDK supports an install target that
will copy applications into the NFS of the SDK.  See the README file at
the top level of the SDK for information about the install target.

