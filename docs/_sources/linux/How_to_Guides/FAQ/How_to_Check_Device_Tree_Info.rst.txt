How to check some device tree information from user-space of Linux?
===================================================================

You might need to check value of some dtb entry, for debugging, checking that
your dtb really got updated after you modfified, etc. Though you can't have a
.dts-file-like view of the device tree which was loaded, you can check values
using the entries in /proc/device-tree.

In the command prompt of Linux, you should see something similar to the
following in the /proc/device-tree directory:

::

    root@j721e-evm:~# ls /proc/device-tree/
    #address-cells  firmware                l3-cache0
    #size-cells     fixedregulator-evm12v0  main_r5fss_cpsw9g_virt_mac0
    __symbols__     fixedregulator-sd       memory@80000000
    aliases         fixedregulator-vsys3v3  model
    chosen          fixedregulator-vsys5v0  name
    compatible      gpio-keys               pmu
    connector       interconnect@100000     reserved-memory
    cpus            interrupt-parent        serial-number
    dma_buf_phys    ion                     sound@0
    dummy-panel     l2-cache0               timer-cl0-cpu0

Following are some typical usages you might need:

- Let's say you don't know the exact path of the device tree entry you are
  trying to check. There is a __symbol__ directory in /proc/device-tree, which
  is very helpful in such cases. It has an entry for each symbol label in the
  device tree. You can find the exact path for that symbol by running ``cat``
  command on that entry. Following is an example demonstrating the use:

  ::

        root@j721e-evm:~# cat /proc/device-tree/__symbols__/main_i2c0
        /interconnect@100000/i2c@2000000

        root@j721e-evm:~# ls /proc/device-tree/interconnect@100000/i2c@2000000/
        #address-cells   clock-names  gpio@20     name       pinctrl-names
        #size-cells      clocks       gpio@22     phandle    power-domains
        clock-frequency  compatible   interrupts  pinctrl-0  reg

- You can check the value of a device tree entry using ``cat`` command if it is a
  string. But if the value is an integer or some numeric data, you will have to
  run the ``xxd`` command instead of ``cat``, to get output in a readable format.
  Following is an example demonstrating the use:

  ::

        # Example for a string value
        root@j721e-evm:~# cat /proc/device-tree/interconnect@100000/i2c@2000000/compatible
        ti,j721e-i2cti,omap4-i2c

        # Example for an integer value
        root@j721e-evm:~# xxd -g4 /proc/device-tree/interconnect@100000/i2c@2000000/clock-frequency
        00000000: 00061a80                             ....

        # The above value is in hexadecimal. You can calculate it's value in decimal by using following command
        root@j721e-evm:~# echo $((0x00061a80))
        400000

- One common scenario of a device tree change is tweaking the memory for
  remoteproc processors like R5F. You can check if it got updated correctly, by
  running a command similar to following for the specific processor core.

  ::

        # Finding symbols for R5Fs
        root@j721e-evm:~# ls /proc/device-tree/__symbols__/main_r5fss*
        /proc/device-tree/__symbols__/main_r5fss0                          /proc/device-tree/__symbols__/main_r5fss0_core1_dma_memory_region  /proc/device-tree/__symbols__/main_r5fss1_core0_memory_region
        /proc/device-tree/__symbols__/main_r5fss0_core0                    /proc/device-tree/__symbols__/main_r5fss0_core1_memory_region      /proc/device-tree/__symbols__/main_r5fss1_core1
        /proc/device-tree/__symbols__/main_r5fss0_core0_dma_memory_region  /proc/device-tree/__symbols__/main_r5fss1                          /proc/device-tree/__symbols__/main_r5fss1_core1_dma_memory_region
        /proc/device-tree/__symbols__/main_r5fss0_core0_memory_region      /proc/device-tree/__symbols__/main_r5fss1_core0                    /proc/device-tree/__symbols__/main_r5fss1_core1_memory_region
        /proc/device-tree/__symbols__/main_r5fss0_core1                    /proc/device-tree/__symbols__/main_r5fss1_core0_dma_memory_region

        # Finding location from the symbols
        root@j721e-evm:~# cat /proc/device-tree/__symbols__/main_r5fss0_core0_memory_region
        /reserved-memory/r5f-memory@a2100000

        root@j721e-evm:~# cat /proc/device-tree/__symbols__/main_r5fss0_core0_dma_memory_region
        /reserved-memory/r5f-dma-memory@a2000000

        # Checking the values
        root@j721e-evm:~# xxd -g4 /proc/device-tree/reserved-memory/r5f-memory@a2100000/reg
        00000000: 00000000 a2100000 00000000 01f00000  ................

        root@j721e-evm:~# xxd -g4 /proc/device-tree/reserved-memory/r5f-dma-memory@a2000000/reg
        00000000: 00000000 a2000000 00000000 00100000  ................
