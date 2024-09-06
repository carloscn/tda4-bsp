HyperBus and HyperFlash
-----------------------------------
HyperBus is Low Signal Count, High Performance Double Data Rate (DDR) Bus interface between a host system master and one or more slave interfaces. Its a 8-bit data bus (DQ[7:0]) with  Read-Write Data Strobe (RWDS) signal and either Single-ended clock(3.0V parts) or Differential clock (1.8V parts). It uses ChipSelect lines to select b/w multiple slaves. At bus level, it follows a separate protocol described in HyperBus specification.

HyperFlash is a NOR flash based device storage over HyperBus.  HyperFlash follows CFI AMD/Fujitsu Extended Command Set (0x0002) similar to that of existing parallel NORs. Since Hyperbus is x8 DDR bus, its equivalent to x16 parallel NOR flash wrt bits per clk. But Hyperbus operates at very high frequencies.

HyperFlash on TI's J721E EVM is connected to HyperBus Memory Controller that supports memory mapped IO access to flash. HyperFlash is supported under MTD framework and U-Boot's standard MTD commands can be used to access HyperFlash

**Supported Devices**
- J721E EVM

To list detected HyperFlash devices:

::

 => mtd list
 List of MTD devices:
 * nor0
  - type: NOR flash
  - block size: 0x40000 bytes /* Each erase sector size is of 256KB */
  - min I/O: 0x1 bytes
  - 0x000000000000-0x000004000000 : "nor0" /* Detected 64MB devices labeled as "nor0" */

.. note::

 On J721E EVM, SW3.1 should be set to ON position to select HyperFlash.

Below Example shows how to erase and write different boot images to HyperFlash from U-Boot prompt.
Erase has to be a multiple of erase sector size.
::

 => mtd erase nor0 0 0x40000 /* Erase from offset 0 to 256KB of HyperFlash labeled nor0 */
 Erasing 0x00000000 ... 0x0003ffff (1 eraseblock(s))
 => fatload mmc 1 0x82000000 tiboot3.bin /* Load an img from SD into DDR to flash into HyperFlash */
 180932 bytes read in 10 ms (17.3 MiB/s)
 => mtd write nor0  0x82000000 0x0 $filesize /* Write the loaded image into HyperFlash labeled nor0 */
 Writing 180932 byte(s) at offset 0x00000000
 =>

Below Example shows how to read back the data

::

 => mtd read nor0 0x82000000 0x0 0x40000 /* Read from offset 0 to 0x4000 to DDR address 0x82000000 from nor0 */
 Reading 262144 byte(s) at offset 0x00000000

**Flashing Images to HyperFlash**

Below commands can be used to download tiboot3.bin, tispl.bin and
u-boot.img over tftp and then flash it to HyperFlash at respective addresses.

.. code-block:: console

  => mtd erase nor0 0 0x800000
  => tftp ${loadaddr} tiboot3.bin
  => mtd write nor0 $loadaddr 0x0 $filesize
  => tftp ${loadaddr} tispl.bin
  => mtd write nor0 $loadaddr 0x80000 $filesize
  => tftp ${loadaddr} u-boot.img
  => mtd write nor0 $loadaddr 0x280000 $filesize
  => tftp ${loadaddr} sysfw.itb
  => mtd write nor0 $loadaddr 0x6C0000 $filesize

**Flash Layout for HyperFlash**
 Below is the layout for HyperFlash in order to boot from HyperFlash:

.. code-block:: console

         0x0 +----------------------------+
             |     hbmc.tiboot3(512K)     |
             |                            |
     0x80000 +----------------------------+
             |     hbmc.tispl(2M)         |
             |                            |
    0x280000 +----------------------------+
             |     hbmc.u-boot(4M)        |
             |                            |
    0x680000 +----------------------------+
             |     hbmc.env(128K)         |
             |                            |
    0x6C0000 +----------------------------+
             |      hbmc.sysfw(1M)        |
             |                            |
    0x7C0000 +----------------------------+
             |      padding (256k)        |
    0x800000 +----------------------------+
             |     hbmc.rootfs(UBIFS)     |
             |                            |
             +----------------------------+

**Bootmode Switch Settings for J721E EVM**

After writing the images, change the bootmode switches on the EVM to the
following in order to boot from HyperFlash at 83MHz:

+------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
| Switch No. | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8   | 9   | 10  |
+------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
| SW8        | OFF | OFF | OFF | OFF | OFF | OFF | OFF | OFF | OFF | OFF |
+------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
| SW9        | OFF | OFF | OFF | OFF | OFF | OFF | OFF | OFF | OFF | OFF |
+------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
| SW3        | ON  | ON  | ON  | ON  | OFF | OFF | ON  | OFF | ON  | OFF |
+------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+

