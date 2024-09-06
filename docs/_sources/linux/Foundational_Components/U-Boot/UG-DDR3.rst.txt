DDR3 ECC
-------------

.. note::
    DDR3 ECC feature described below is enabled for Keystone-II devices.

DDR3 ECC in Keystone-II
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Some of the TI SoC devices have DDR ECC enabled. Keystone-II devices (K2H/K2E/K2G) enable the
DDR3 error detection and correction feature. The DDR3 controller supports ECC on the data
written or read from the SDRAM and is enabled by programming the ECC Control register.
8-bit ECC is calculated over 64-bit data quanta for K2H and K2E, but 4-bit ECC over 32-bit data for K2G.
The ECC is calculated for all accesses that are within the address ranges protected by ECC.
1-bit error is correctable by ECC and 2-bit error is not correctable and will be treated as
unrecoverable error by software and trigger the reset of the device.

DDR3 ECC Handling
"""""""""""""""""""

Keystone-II U-boot checks if the DDR3 controller supports ECC RMW or not.
If ECC RMW is not supported (in K2H PG1.x devices), U-boot will disable the ECC by default,
otherwise it always enables ECC (in K2H PG2.0, K2E, and K2G devices)

During the ECC initialization, U-boot fills the entire memory (up to 8GB) to zeros
using an EDMA channel after ECC is enabled. For K2H device, U-boot configures
the chip level interrupt controller to route the DDR3 ECC error interrupt to
ARM interrupt controller. For K2E and K2G devices, since DDR3 ECC error interrupt is directly
routed to ARM interrupt controller, there is no need to configure the chip level interrupt controller.

A DDR3 command is added to simulate the ECC error by generating bit errors in DDR data at certain address. The command format is:

::

   ddr ecc_err <addr in hex> <bit_err in hex>

The command will read a 32-bit data from <addr>, and write (data ^ bit_err) back to <addr>

::

   E.g.:
   ddr ecc_err 0x90000000 0x1 (this will genereate a 1-bit error on bit 0 of the data in ddr address 0x9000_0000)
   ddr ecc_err 0xa0000000 0x1001 (this will genereate 2-bit error on bit 0 & 3 of the data in ddr address 0xa000_0000)

A new environment variable "ecc_test" is also introduced to test ECC. By default, ecc_test = 0, and any detection of 2-bit error will reset the device. If ecc_test = 1, U-boot will bypass the error and continues to boot Linux kernel so that Linux kernel can handle the error in interrupt service.

.. note::
  **DDR3 ECC Handling in Keystone-II Linux kernel**

  Linux kernel requests an IRQ handler for DDR3 ECC error interrupt, the handler checks the DDR3 controller interrupt
  status register, if the error is 2-bit error, Linux kernel will reboot the device. User can also use a user mode
  command to read the DDR3 ECC registers (e.g. 1-bit error count register, etc.), the DDR3 controller register and
  interrupt mapping are defined in the sysctrl node of device tree binding:

::

  E.g. K2H SOC device tree:
  sysctrl {
        reg = <0x21010000 0x0200>; /* DDR3 controller reg */
        interrupts = <0 24 0xf01    /* L1L2 ECC error interrupt */
                      0 448 0xf01>; /* DDR3 ECC error interrupt */
  };
