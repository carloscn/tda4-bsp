.. http://processors.wiki.ti.com/index.php/Linux_Core_I2C_User%27s_Guide

I2C
---

TI SoCs have High-Speed (HS) Inter-Integrated Circuit (I2C)
controllers, which provide an interface between a CPU and any
I2C-bus-compatible slave devices that connects through the I2C serial
bus.
For more info, refer to the I2C controller chapter in the respective SoC
TRM.

I2C controller driver supports master mode only. It can work at
different frequencies such as 100 KHz, 400 KHz and 3.4 MHz.
Driver is enabled by default in SDK images.

.. rubric:: Testing
   :name: testing-linux-i2c

The i2c-tools package contains a heterogeneous set of I2C tools to
interact with I2C slave devices from userspace. SDK images have
i2c-tools packaged by default.

To list all I2C busses in the system use i2cdetect:

.. code-block:: text

	$ i2cdetect -l
	i2c-3   i2c             OMAP I2C adapter                        I2C adapter
	i2c-1   i2c             OMAP I2C adapter                        I2C adapter
	i2c-8   i2c             OMAP I2C adapter                        I2C adapter
	i2c-6   i2c             OMAP I2C adapter                        I2C adapter
	i2c-4   i2c             OMAP I2C adapter                        I2C adapter
	i2c-2   i2c             OMAP I2C adapter                        I2C adapter
	i2c-0   i2c             OMAP I2C adapter                        I2C adapter
	i2c-9   i2c             OMAP I2C adapter                        I2C adapter
	i2c-7   i2c             OMAP I2C adapter                        I2C adapter
	i2c-5   i2c             OMAP I2C adapter                        I2C adapter

Alternatively look at the dmesg log to get list of I2C busses:

.. code-block:: text

	$ dmesg | grep i2c
	[    0.691360] i2c /dev entries driver
	[    0.824513] omap_i2c 40b00000.i2c: bus 0 rev0.12 at 100 kHz
	[    0.830432] omap_i2c 40b10000.i2c: bus 1 rev0.12 at 100 kHz
	[    0.930545] omap_i2c 42120000.i2c: bus 2 rev0.12 at 400 kHz
	[    0.998918] omap_i2c 2000000.i2c: bus 3 rev0.12 at 400 kHz
	[    1.004902] omap_i2c 2010000.i2c: bus 4 rev0.12 at 400 kHz
	[    1.010764] omap_i2c 2020000.i2c: bus 5 rev0.12 at 100 kHz
	[    1.057367] omap_i2c 2030000.i2c: bus 6 rev0.12 at 400 kHz
	[    1.063224] omap_i2c 2040000.i2c: bus 7 rev0.12 at 100 kHz
	[    1.069069] omap_i2c 2050000.i2c: bus 8 rev0.12 at 100 kHz
	[    1.111240] omap_i2c 2060000.i2c: bus 9 rev0.12 at 400 kHz


User can interact with I2C slave devices using i2cdump, i2cset and
i2cget commands:

.. code-block:: text

       i2cdump -f -y bus slaveaddr b
          This will dump the register content of the slave at respective bus.
       i2cset -f -y bus slaveaddr register value b
          This will write a 'value' to the 'register' of the device with address 'slaveaddr'.
       i2cget -f -y bus slaveaddr register b
          This will read from the 'register' of the device with address 'slaveaddr'.

For more details, refer to man page of respective tools:
`i2cdump <https://linux.die.net/man/8/i2cdump>`_,
`i2cset <https://linux.die.net/man/8/i2cset>`_,
`i2cget <https://linux.die.net/man/8/i2cget>`_,
`i2cdetect <https://linux.die.net/man/8/i2cdetect>`_.

