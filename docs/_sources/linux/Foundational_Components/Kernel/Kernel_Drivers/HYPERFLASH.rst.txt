HyperBus and HyperFlash
-----------------------------------

Introduction
^^^^^^^^^^^^

HyperBus is Low Signal Count, High Performance Double Data Rate (DDR) Bus interface between a host system master and one or more slave interfaces. Its a 8-bit data bus (DQ[7:0]) with  Read-Write Data Strobe (RWDS) signal and either Single-ended clock(3.0V parts) or Differential clock (1.8V parts). It uses ChipSelect lines to select b/w multiple slaves. At bus level, it follows a separate protocol described in HyperBus specification.

HyperFlash is a NOR flash based device storage over HyperBus.  HyperFlash follows CFI AMD/Fujitsu Extended Command Set (0x0002) similar to that of existing parallel NORs. Since Hyperbus is x8 DDR bus, its equivalent to x16 parallel NOR flash wrt bits per clk. But Hyperbus operates at much higher frequencies.

HyperFlash on TI's J7 EVM is connected to HyperBus Memory Controller that supports memory mapped IO access to flash. HyperFlash is supported under kernel's MTD framework.

**Supported Devices**

- J7200 EVM

.. ifconfig:: CONFIG_part_family in ('J7_family')

    .. note::
        On J7200 EVM, switch SW3.1 should be in ON position at the time
	of powering on the board to access HyperFlash.

Driver Architecture
^^^^^^^^^^^^^^^^^^^

Following diagram shows the HyperBus and HyperFlash driver stack:

.. figure:: /images/hbmc-linux-arch.png


**Source Location**

The source file for the HyperBus controller driver can be found at: drivers/mtd/hyperbus/hbmc-am654.c under Linux Kernel source tree.

HyperFlash command set is implementation is at: drivers/mtd/chips/cfi_cmdset0002.c

Kernel Configuration Options
""""""""""""""""""""""""""""

The driver can be built into the kernel or can be compiled as module and
loaded into the kernel dynamically.

**Enabling HyperBus driver**

Following configs are to be enabled for HyperBus and HyperFlash.

.. note::
    HyperBus driver and their dependencies are enabled by default in
    the SDK images. So this section can be skipped in that case.

Start the Linux Kernel Configuration tool:

::

        $ make menuconfig  ARCH=arm64

::

              Device Drivers  --->
                <*> Memory Technology Device (MTD) support  --->
                  <*>  HyperBus support  --->
                     <*>   HyperBus controller driver for AM65x SoC

Enabling UBIFS filesystem support:

::

              File systems  --->
                [*] Miscellaneous filesystems  --->
                  <*>   UBIFS file system support

DT Configuration
""""""""""""""""

Refer to Documentation/devicetree/bindings/mtd/ti,am654-hbmc.txt
kernel source tree for HyperBus and HyperFlash documentation driver's DT bindings and
their usage. Example DT entry:

::

	fss: system-controller@47000000 {
		compatible = "syscon", "simple-mfd";
		reg = <0x0 0x47000000 0x0 0x100>;
		#address-cells = <2>;
		#size-cells = <2>;
		ranges;

		hbmc_mux: hbmc-mux {
			compatible = "mmio-mux";
			#mux-control-cells = <1>;
			mux-reg-masks = <0x4 0x2>; /* HBMC select */
		};

		hbmc: hyperbus@47034000 {
			compatible = "ti,am654-hbmc";
			reg = <0x0 0x47034000 0x0 0x100>,
				<0x5 0x00000000 0x1 0x0000000>;
			power-domains = <&k3_pds 102 TI_SCI_PD_EXCLUSIVE>;
			clocks = <&k3_clks 102 0>;
			assigned-clocks = <&k3_clks 102 5>;
			assigned-clock-rates = <333333333>;
			#address-cells = <2>;
			#size-cells = <1>;
			mux-controls = <&hbmc_mux 0>;
		};
	};

	&hbmc {
	        pinctrl-names = "default";
		pinctrl-0 = <&mcu_fss0_hpb0_pins_default>;
		ranges = <0x0 0x0 0x5 0x00000000 0x4000000>, /* 64MB Flash on CS0 */
			 <0x1 0x0 0x5 0x04000000 0x800000>; /* 8MB RAM on CS1 */

		flash@0,0 {
			compatible = "cypress,hyperflash", "cfi-flash";
			reg = <0x0 0x0 0x4000000>;
		};
	};

Driver Usage
""""""""""""

HyperFlash is exposed to userspace as MTD character devices and
/dev/mtdX (X = 0, 1, 2) entries are created for every partition defined
in DT or via command line arguments. MTD abstracts all types of flashes
and, To see all MTD partitions in the system run:

::

       $cat /proc/mtd

Here is example for `DT partitioning
<https://www.kernel.org/doc/Documentation/devicetree/bindings/mtd/partition.txt>`__.
Example for passing `cmdline partition from U-Boot
<https://www.denx.de/wiki/view/DULG/BootTimeConfigurationOfMTDPartitions>`__.

Testing
"""""""

Since, HyperFlash is supported under MTD framework, usage is same as
SPI NOR flashes such as OSPI/QSPI. HyperFlash also supports UBIFS as
filesystem format. Note that, it is necessary to define at least one
cmdline or DT partition to use UBIFS.

Refer to :ref:`QSPI section for more testing <testing-kernel-qspi-label>`.

.. note::
  Currently, Linux has no support for HyperRAM.
