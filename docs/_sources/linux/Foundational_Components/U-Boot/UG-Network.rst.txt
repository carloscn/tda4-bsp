Network (Wired or USB Client)
-----------------------------------

This section documents how to configure the network and use it to load
files and then boot the Linux Kernel using a root filesystem mounted
over NFS. At this time, no special builds of U-Boot are required to
perform these operations on the supported hardware.

Booting U-Boot from the network
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In some cases we support loading SPL and U-Boot over the network because
of ROM support. In some cases, a special build of U-Boot may be
required. In addition, the DHCP server is needed to reply to the target
with the file to fetch via tftp. In order to facilitate this, the
**vendor-class-identifier** DHCP field is filled out by the ROM and the
values are listed in the table below. Finally, you will need to use the
**spl/u-boot-spl.bin** and **u-boot.img** files to boot.

.. note::
    Booting U-Boot/SPL from network is supported only on the following platforms.

+-----------------------------------+---------------+--------------------------------------+------------------------------------------------------+-------------------------------------+
| Board                             | make target   | Supported interfaces                 | ROM vendor-class-identifier value                    | SPL vendor-class-identifier value   |
+===================================+===============+======================================+======================================================+=====================================+
| AM335x GP EVM                     | am335x\_evm   | CPSW ethernet                        | DM814x ROM (PG1.0) or AM335x ROM (PG2.0 and later)   | AM335x U-Boot SPL                   |
+-----------------------------------+---------------+--------------------------------------+------------------------------------------------------+-------------------------------------+
| AM335x GP EVM (PG2.0 and later)   | am335x\_evm   | SPL and U-Boot via USB RNDIS         | AM335x ROM                                           | AM335x U-Boot SPL                   |
+-----------------------------------+---------------+--------------------------------------+------------------------------------------------------+-------------------------------------+
| AM335x GP EVM (PG1.0)             | am335x\_evm   | SPL via UART, U-Boot via USB RNDIS   | N/A                                                  | AM335x U-Boot SPL                   |
+-----------------------------------+---------------+--------------------------------------+------------------------------------------------------+-------------------------------------+
| AM43xx EVM                        | am43xx\_evm   | CPSW ethernet                        | AM43xx ROM                                           | AM43xx U-Boot SPL                   |
+-----------------------------------+---------------+--------------------------------------+------------------------------------------------------+-------------------------------------+
| AM43xx EVM (PG1.2 and later)      | am43xx\_evm   | SPL and U-Boot via USB RNDIS         | AM43xx ROM                                           | AM43xx U-Boot SPL                   |
+-----------------------------------+---------------+--------------------------------------+------------------------------------------------------+-------------------------------------+

If using ISC dhcpd an example host entry would look like this:

::

    host am335x_evm {
      hardware ethernet de:ad:be:ee:ee:ef;
      # Check for PG1.0, typically CPSW
      if substring (option vendor-class-identifier, 0, 10) = "DM814x ROM" {
        filename "u-boot-spl.bin";
      # Check for PG2.0, CPSW or USB RNDIS
      } elsif substring (option vendor-class-identifier, 0, 10) = "AM335x ROM" {
        filename "u-boot-spl.bin";
      } elsif substring (option vendor-class-identifier, 0, 17) = "AM335x U-Boot SPL" {
        filename "u-boot.img";
      } else {
        filename "zImage-am335x-evm.bin";
      }
    }

Note that in a factory type setting, the substring tests can be done
inside of the subnet declaration to set the default filename value for
the subnet, and overriden (if needed) in a host entry.

If you have removed NetworkManager from your system (which is not the
default in most distributions) you need to configure your
/etc/network/interfaces file thusly:

::

    allow-hotplug usb0
    iface usb0 inet static
            address 192.168.1.1
            netmask 255.255.255.0
            post-up service isc-dhcp-server reload

If you are using NetworkManager you need to create two files. First, as
root create /etc/NetworkManager/system-connections/AM335x USB RNDIS (and
use \\ to escape the space) with the following content:

::


    [802-3-ethernet]
    duplex=full
    mac-address=AA:BB:CC:11:22:33

    [connection]
    id=AM335X USB RNDIS
    uuid=INSERT THE CONTENTS OF 'uuidgen' HERE
    type=802-3-ethernet

    [ipv6]
    method=ignore

    [ipv4]
    method=manual
    addresses1=192.168.1.1;16;

Seccond as root, and ensuring execute permissions, create
/etc/NetworkManager/dispatcher.d/99am335x-dhcp-server

::

    #!/bin/sh

    IF=$1
    STATUS=$2

    if [ "$IF" = "usb0" ] && [ "$STATUS" = "up" ]; then
        service isc-dhcp-server reload
    fi

A walk through of these steps can be seen at `Ubuntu 12.04 Set Up to
Network Boot an AM335x Based
Platform <http://processors.wiki.ti.com/index.php/Ubuntu_12.04_Set_Up_to_Network_Boot_an_AM335x_Based_Platform>`__.

|

Multiple Interfaces
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On some boards, for example when we have both a wired interface and USB
RNDIS gadget ethernet, it can be desirable to change from the default
U-Boot behavior of cycling over each interface it knows to telling
U-Boot to use a single interface. For example, on start you may see
lines like:

::

    Net:   cpsw, usb_ether

So to ensure that we use **usb\_ether** first issue the following
command:

::

    U-Boot # setenv ethact usb_ether

Network configuration via DHCP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To configure the network via DHCP, use the following commands:

::

    U-Boot # setenv autoload no
    U-Boot # dhcp

And ensure that a DHCP server is configured to serve addresses for the
network you are connected to.

Manual network configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To configure the network manually, the **ipaddr**, **serverip**,
**gatewayip** and **netmask**:

::

    U-Boot # setenv ipaddr 192.168.1.2
    U-Boot # setenv serverip 192.168.1.1
    U-Boot # setenv gatewayip 192.168.1.1
    U-Boot # setenv netmask 255.255.255.0

Disabling Gigabit Phy Advertising
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
On some boards like DRA72x Rev B or earlier, there is an issue like
ethernet doesn't connect to 1Gbps switch. This issue is due to the use
of an old ti phy with history of bad behaviour, due to this several J6
EVMs have been marked 100M only. So here is the U-Boot command to
disable phy's 1Gbps support and connect as 100Mbps max capable.

::

    => mii modify 0x3 0x9 0x0 0x300      /* Disable Gigabit advertising */
    => mii modify 0x3 0x0 0x0 0x1000     /* Disable Auto Negotiation */
    => mii modify 0x3 0x0 0x1000 0x1000  /* Enable Auto Negotiation */

Booting Linux from the network
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Within the default environment for each board that supports networking
there is a boot command called **netboot** in AM EVMs and **boot=net**
in KS2 EVMs that will automatically load the kernel and boot. For the
exact details of each use **printenv** on the **netboot** variable and
then in turn **printenv** other sub-sections of the command. The most
important variables in AM57x/DRA7x are **rootpath** and **nfsopts**,
and **tftp\_root** and **nfs\_root** in K2H/K/E/L/G.

On AM65x GP and IDK boards, Linux kernel can be booted over PRU-ICSSG
Ethernet port as well. In the release u-boot image, only first port
(MII port 0)	of ICSSG0, ICSSG1 and ICSSG2 are enabled. To use
second port (MII port 1), user needs to edit the DTS file to enable
second port instead of first port and rebuild u-boot images using the
updated DTS file.  First port is marked as Eth0 on base board (ICSSG2),
Eth0 (ICSSG0) and Eth2 (ICSSG1) on IDK Application board. User needs
to load and run pru/rtu firmware on ICSSG using env script as shown
below before doing network operations such as dhcp, tftp over ICSSG
ports. The firmware is loaded from the rootfs/lib/firmware/ti-pruss/
folder for this purpose. For more information on using rproc/RemoteProc
in Uboot, see section `here <Foundational_Components_U-Boot.html#remoteproc>`__.
A sample U-Boot env script for AM65x EVM/IDK is shown below for ICSSG0,
ICSSG1 and ICSSG2. User needs to customize the serverip and bootdir
env variable to that of the tftp server used in the setup.

.. note:: Currently only 100Mbps and 1Gbps Full Duplex (FD) links are supported for ICSSG ports. Linux Kernel boot with NFS rootfs over PRUETH Ethernet interface has not been validated.

Sample Script for AM65 SR1
^^^^^^^^^^^^^^^^^^^^^^^^^^

ICSSG0 port 0

::

 setenv start_icssg0 'rproc start 2; rproc start 3'
 setenv stop_icssg0 'rproc stop 2; rproc stop 3'
 setenv firmware_dir '/lib/firmware/ti-pruss'
 setenv get_fdt_net 'run start_icssg0; tftp ${fdtaddr} ${serverip}:${bootdir}/${name_fdt}; run stop_icssg0'
 setenv get_kern_net 'run start_icssg0; tftp ${loadaddr} ${serverip}:${bootdir}/${name_kern}; run stop_icssg0'
 setenv get_overlay_net 'fdt address ${fdtaddr};fdt resize 0x0fffff;for overlay in $overlay_files;do; run start_icssg0; \
	 tftp ${overlayaddr} ${bootdir}/${overlay};fdt apply ${overlayaddr}; run stop_icssg0; done;'
 setenv get_firmware_mmc 'load mmc ${bootpart} ${loadaddr} ${firmware_dir}/${firmware_file}'
 setenv serverip 158.218.113.14
 setenv bootdir 06.02.00.58-am6
 setenv name_fdt k3-am654-base-board.dtb
 setenv name_kern Image-am65xx-evm.bin
 setenv overlay_files 'k3-am654-idk.dtbo k3-am654-pcie-usb2.dtbo'
 setenv init_icssg0 'setenv ethact pruss0_eth; setenv autoload no; rproc init; setenv loadaddr 0x80000000; \
	 setenv firmware_file 'am65x-pru0-prueth-fw.elf'; run get_firmware_mmc;  rproc load 2 0x80000000 13040; rproc start 2; \
	 setenv loadaddr 0x89000000; setenv firmware_file am65x-rtu0-prueth-fw.elf; run get_firmware_mmc; rproc load 3 0x89000000 5676; \
	 rproc start 3; dhcp; run stop_icssg0;'
 setenv bootcmd 'run init_mmc; run init_icssg0; run get_kern_net; run get_fdt_net ; run get_overlay_net ; run run_kern'
 saveenv
 boot

ICSSG1 port 0

::

 setenv start_icssg1 'rproc start 6; rproc start 7'
 setenv stop_icssg1 'rproc stop 6; rproc stop 7'
 setenv firmware_dir '/lib/firmware/ti-pruss'
 setenv get_fdt_net 'run start_icssg1; tftp ${fdtaddr} ${serverip}:${bootdir}/${name_fdt}; run stop_icssg1'
 setenv get_kern_net 'run start_icssg1; tftp ${loadaddr} ${serverip}:${bootdir}/${name_kern}; run stop_icssg1'
 setenv get_overlay_net 'fdt address ${fdtaddr};fdt resize 0x0fffff;for overlay in $overlay_files;do; run start_icssg1; \
       tftp ${overlayaddr} ${bootdir}/${overlay};fdt apply ${overlayaddr}; run stop_icssg1; done;'
 setenv get_firmware_mmc 'load mmc ${bootpart} ${loadaddr} ${firmware_dir}/${firmware_file}'
 setenv serverip 158.218.113.14
 setenv bootdir 06.02.00.58-am6
 setenv name_fdt k3-am654-base-board.dtb
 setenv name_kern Image-am65xx-evm.bin
 setenv overlay_files 'k3-am654-idk.dtbo k3-am654-pcie-usb2.dtbo'
 setenv init_icssg1 'setenv ethact pruss1_eth; setenv autoload no; rproc init; setenv loadaddr 0x80000000; \
       setenv firmware_file 'am65x-pru0-prueth-fw.elf'; run get_firmware_mmc;  rproc load 6 0x80000000 13040; rproc start 6; \
       setenv loadaddr 0x89000000; setenv firmware_file am65x-rtu0-prueth-fw.elf; run get_firmware_mmc; rproc load 7 0x89000000 5676; \
       rproc start 7; dhcp; run stop_icssg1;'
 setenv bootcmd 'run init_mmc; run init_icssg1; run get_kern_net; run get_fdt_net ; run get_overlay_net ; run run_kern'
 saveenv
 boot

ICSSG2 port 0

::

 setenv start_icssg2 'rproc start 10; rproc start 11'
 setenv stop_icssg2 'rproc stop 10; rproc stop 11'
 setenv firmware_dir '/lib/firmware/ti-pruss'
 setenv get_fdt_net 'run start_icssg2; tftp ${fdtaddr} ${serverip}:${bootdir}/${name_fdt}; run stop_icssg2'
 setenv get_kern_net 'run start_icssg2; tftp ${loadaddr} ${serverip}:${bootdir}/${name_kern}; run stop_icssg2'
 setenv get_overlay_net 'fdt address ${fdtaddr};fdt resize 0x0fffff;for overlay in $overlay_files;do; run start_icssg2; \
      tftp ${overlayaddr} ${bootdir}/${overlay};fdt apply ${overlayaddr}; run stop_icssg2; done;'
 setenv get_firmware_mmc 'load mmc ${bootpart} ${loadaddr} ${firmware_dir}/${firmware_file}'
 setenv serverip 158.218.113.14
 setenv bootdir 06.02.00.58-am6
 setenv name_fdt k3-am654-base-board.dtb
 setenv name_kern Image-am65xx-evm.bin
 setenv overlay_files 'k3-am654-idk.dtbo k3-am654-pcie-usb2.dtbo'
 setenv init_icssg2 'setenv ethact pruss2_eth; setenv autoload no; rproc init; setenv loadaddr 0x80000000; \
      setenv firmware_file 'am65x-pru0-prueth-fw.elf'; run get_firmware_mmc;  rproc load 10 0x80000000 13040; rproc start 10; \
      setenv loadaddr 0x89000000; setenv firmware_file am65x-rtu0-prueth-fw.elf; run get_firmware_mmc; rproc load 11 0x89000000 5676; \
      rproc start 11; dhcp; run stop_icssg2;'
 setenv bootcmd 'run init_mmc; run init_icssg2; run get_kern_net; run get_fdt_net ; run get_overlay_net ; run run_kern'
 saveenv
 boot

Sample Script for AM65 SR2
^^^^^^^^^^^^^^^^^^^^^^^^^^

ICSSG0 port 0

::

 setenv start_icssg0 'rproc start 2; rproc start 3; rproc start 4; rproc start 5; rproc start 6; rproc start 7'
 setenv stop_icssg0 'rproc stop 2; rproc stop 3; rproc stop 4; rproc stop 5; rproc stop 6; rproc stop 7'
 setenv firmware_dir '/lib/firmware/ti-pruss'
 setenv get_fdt_net 'run start_icssg0; tftp ${fdtaddr} ${serverip}:${bootdir}/${name_fdt}; run stop_icssg0'
 setenv get_kern_net 'run start_icssg0; tftp ${loadaddr} ${serverip}:${bootdir}/${name_kern}; run stop_icssg0'
 setenv get_overlay_net 'fdt address ${fdtaddr};fdt resize 0x0fffff;for overlay in $overlay_files;do; run start_icssg0; \
         tftp ${overlayaddr} ${bootdir}/${overlay};fdt apply ${overlayaddr}; run stop_icssg0; done;'
 setenv get_firmware_mmc 'load mmc ${bootpart} ${loadaddr} ${firmware_dir}/${firmware_file}'
 setenv serverip 158.218.113.14
 setenv bootdir 06.02.00.58-am6
 setenv name_fdt k3-am654-base-board.dtb
 setenv name_kern Image-am65xx-evm.bin
 setenv overlay_files 'k3-am654-idk.dtbo k3-am654-pcie-usb2.dtbo'
 setenv init_icssg0 'setenv ethact icssg0-eth; setenv autoload no; rproc init; setenv loadaddr 0x80000000; \
     setenv firmware_file 'am65x-sr2-pru0-prueth-fw.elf'; run get_firmware_mmc;  rproc load 2 0x80000000 ${filesize}; \
     setenv loadaddr 0x89000000; setenv firmware_file am65x-sr2-rtu0-prueth-fw.elf; run get_firmware_mmc; rproc load 3 0x89000000 ${filesize}; \
     setenv loadaddr 0x90000000; setenv firmware_file am65x-sr2-txpru0-prueth-fw.elf; run get_firmware_mmc; rproc load 4 0x90000000 ${filesize}; \
     setenv loadaddr 0x80000000; setenv firmware_file am65x-sr2-pru1-prueth-fw.elf; run get_firmware_mmc; rproc load 5 0x80000000 ${filesize}; \
     setenv loadaddr 0x89000000; setenv firmware_file am65x-sr2-rtu1-prueth-fw.elf; run get_firmware_mmc; rproc load 6 0x89000000 ${filesize}; \
     setenv loadaddr 0x90000000; setenv firmware_file am65x-sr2-txpru1-prueth-fw.elf; run get_firmware_mmc; rproc load 7 0x90000000 ${filesize}; \
     run start_icssg0; dhcp; run stop_icssg0;'
 setenv bootcmd 'run init_mmc; run init_icssg0; run get_kern_net; run get_fdt_net ; run get_overlay_net ; run run_kern'
 saveenv
 boot

ICSSG1 port 0

::

 setenv start_icssg1 'rproc start 8; rproc start 9; rproc start 10; rproc start 11; rproc start 12; rproc start 13'
 setenv stop_icssg1 'rproc stop 8; rproc stop 9; rproc stop 10; rproc stop 11; rproc stop 12; rproc stop 13'
 setenv firmware_dir '/lib/firmware/ti-pruss'
 setenv get_fdt_net 'run start_icssg1; tftp ${fdtaddr} ${serverip}:${bootdir}/${name_fdt}; run stop_icssg1'
 setenv get_kern_net 'run start_icssg1; tftp ${loadaddr} ${serverip}:${bootdir}/${name_kern}; run stop_icssg1'
 setenv get_overlay_net 'fdt address ${fdtaddr};fdt resize 0x0fffff;for overlay in $overlay_files;do; run start_icssg1; \
         tftp ${overlayaddr} ${bootdir}/${overlay};fdt apply ${overlayaddr}; run stop_icssg1; done;'
 setenv get_firmware_mmc 'load mmc ${bootpart} ${loadaddr} ${firmware_dir}/${firmware_file}'
 setenv serverip 158.218.113.14
 setenv bootdir 06.02.00.58-am6
 setenv name_fdt k3-am654-base-board.dtb
 setenv name_kern Image-am65xx-evm.bin
 setenv overlay_files 'k3-am654-idk.dtbo k3-am654-pcie-usb2.dtbo'
 setenv init_icssg1 'setenv ethact icssg1-eth; setenv autoload no; rproc init; setenv loadaddr 0x80000000; \
     setenv firmware_file 'am65x-sr2-pru0-prueth-fw.elf'; run get_firmware_mmc;  rproc load 8 0x80000000 ${filesize}; \
     setenv loadaddr 0x89000000; setenv firmware_file am65x-sr2-rtu0-prueth-fw.elf; run get_firmware_mmc; rproc load 9 0x89000000 ${filesize}; \
     setenv loadaddr 0x90000000; setenv firmware_file am65x-sr2-txpru0-prueth-fw.elf; run get_firmware_mmc; rproc load 10 0x90000000 ${filesize}; \
     setenv loadaddr 0x80000000; setenv firmware_file am65x-sr2-pru1-prueth-fw.elf; run get_firmware_mmc; rproc load 11 0x80000000 ${filesize}; \
     setenv loadaddr 0x89000000; setenv firmware_file am65x-sr2-rtu1-prueth-fw.elf; run get_firmware_mmc; rproc load 12 0x89000000 ${filesize}; \
     setenv loadaddr 0x90000000; setenv firmware_file am65x-sr2-txpru1-prueth-fw.elf; run get_firmware_mmc; rproc load 13 0x90000000 ${filesize}; \
     run start_icssg1; dhcp; run stop_icssg1;'
 setenv bootcmd 'run init_mmc; run init_icssg1; run get_kern_net; run get_fdt_net ; run get_overlay_net ; run run_kern'
 saveenv
 boot

ICSSG2 port 0

::

 setenv start_icssg2 'rproc start 14; rproc start 15; rproc start 16; rproc start 17; rproc start 18; rproc start 19'
 setenv stop_icssg2 'rproc stop 14; rproc stop 15; rproc stop 16; rproc stop 17; rproc stop 18; rproc stop 19'
 setenv firmware_dir '/lib/firmware/ti-pruss'
 setenv get_fdt_net 'run start_icssg2; tftp ${fdtaddr} ${serverip}:${bootdir}/${name_fdt}; run stop_icssg2'
 setenv get_kern_net 'run start_icssg2; tftp ${loadaddr} ${serverip}:${bootdir}/${name_kern}; run stop_icssg2'
 setenv get_overlay_net 'fdt address ${fdtaddr};fdt resize 0x0fffff;for overlay in $overlay_files;do; run start_icssg2; \
         tftp ${overlayaddr} ${bootdir}/${overlay};fdt apply ${overlayaddr}; run stop_icssg2; done;'
 setenv get_firmware_mmc 'load mmc ${bootpart} ${loadaddr} ${firmware_dir}/${firmware_file}'
 setenv serverip 158.218.113.14
 setenv bootdir 06.02.00.58-am6
 setenv name_fdt k3-am654-base-board.dtb
 setenv name_kern Image-am65xx-evm.bin
 setenv overlay_files 'k3-am654-idk.dtbo k3-am654-pcie-usb2.dtbo'
 setenv init_icssg2 'setenv ethact icssg2-eth; setenv autoload no; rproc init; setenv loadaddr 0x80000000; \
     setenv firmware_file 'am65x-sr2-pru0-prueth-fw.elf'; run get_firmware_mmc;  rproc load 14 0x80000000 ${filesize}; \
     setenv loadaddr 0x89000000; setenv firmware_file am65x-sr2-rtu0-prueth-fw.elf; run get_firmware_mmc; rproc load 15 0x89000000 ${filesize}; \
     setenv loadaddr 0x90000000; setenv firmware_file am65x-sr2-txpru0-prueth-fw.elf; run get_firmware_mmc; rproc load 16 0x90000000 ${filesize}; \
     setenv loadaddr 0x80000000; setenv firmware_file am65x-sr2-pru1-prueth-fw.elf; run get_firmware_mmc; rproc load 17 0x80000000 ${filesize}; \
     setenv loadaddr 0x89000000; setenv firmware_file am65x-sr2-rtu1-prueth-fw.elf; run get_firmware_mmc; rproc load 18 0x89000000 ${filesize}; \
     setenv loadaddr 0x90000000; setenv firmware_file am65x-sr2-txpru1-prueth-fw.elf; run get_firmware_mmc; rproc load 19 0x90000000 ${filesize}; \
     run start_icssg2; dhcp; run stop_icssg2;'
 setenv bootcmd 'run init_mmc; run init_icssg2; run get_kern_net; run get_fdt_net ; run get_overlay_net ; run run_kern'
 saveenv
 boot

.. note:: To boot over second port (MII port 1) of ICSSG2, user needs to edit arch/arm/dts/k3-am654-base-board-u-boot.dtsi in the U-Boot source tree. See DTS file for instruction. For example, user needs to comment pruss2_emac0 DT node and uncomment pruss2_emac1 node. Similarly to enable second port for ICSSG0 and ICSSG1, user needs to edit arch/arm/dts/k3-am654-idk.dtso and enable pruss0_emac1 and pruss1_emac1 nodes respectives. After this rebuild u-boot images and use it. Port 1 is marked as by Eth1 on on base board (ICSSG2), Eth1 (ICSSG0) and Eth3 (ICSSG1) on IDK Application board.


