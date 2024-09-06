******
CSI2RX
******

Introduction
============

The CSI2RX subsystem is present on some TI SoCs which facilitates the capture of
camera frames over a MIPI CSI-2 bus. The driver is based on the Video for Linux
2 (V4L2) API. It implements V4L2's Media Controller (MC) API.

Hardware Architecture
=====================

The CSI2RX subsystem is composed of 3 IPs: Cadence DPHY, Cadence CSI2RX bridge,
TI CSI2RX DMA wrapper (aka the SHIM layer).

.. Image:: /images/csi2rx-single-camera.png

The CSI2RX subsystem supports the following features:

- Compliant to MIPI CSI v1.3
- Supports up to 16 virtual channels per input (partial MIPI CSI v2.0 feature).
- Data rate up to 2.5 Gbps per lane (wire rate).
- Supports 1, 2, 3, or 4 data lane connection to DPHY_RX.
- Programmable formats including YUV420, YUV422, RGB, Raw, etc.

See the the technical reference manual (TRM) for the SoC in question for more
detailed information.

Driver Architecture
===================

The driver is based on the Video 4 Linux 2 (V4L2) API. It is implemented
according to the V4L2 standard for capture devices. The driver is only
responsible for programming the SoC components for capture like the DPHY, CSI
bridge, DMA. For external devices like camera sensors separate V4L2 subdevice
drivers are needed.

The Media Controller API
------------------------

The driver is implemented using V4L2's Media Controller (MC) API. In the MC API,
each element in the media pipeline is configured individually by the user-space
application. In comparison, in the legacy or non-MC API drivers, only the
/dev/videoX node needs to be configured, and it propagates the configuration up
the chain. With this model, the MC API allows for more flexible pipeline
configurations which can all be controlled from user-space without having to
change the driver or the device tree.

For example, with the legacy API the format is set on /dev/videoX and that will
set it for the entire pipeline (sensor, bridge, DMA engine, etc). With the MC
API, the format needs to be set on each individual element in the pipeline. So
with a single camera setup, for capturing 1920x1080 @ 60fps UYVY, the camera
(/dev/v4l-subdevX) should first be configured to use that format via the V4L2
subdev ioctls. Then the /dev/videoX node (which represents the DMA context)
should be configured to use matching configuration. The Media Controller
framework checks for mismatches and reports errors if something is not right.

In similar fashion, the DMA context does not care about frame rate. It can
capture at any rate, so the driver does not implement the G_PARM or S_PARM
ioctls. Instead, the frame rate should be set on the sensor using
VIDIOC_SUBDEV_S_FRAME_INTERVAL.

Quick links for relevant Linux Kernel documentation:

- `Video for Linux API <https://www.kernel.org/doc/html/latest/userspace-api/media/v4l/v4l2.html>`__
- `Media Controller API
  <https://www.kernel.org/doc/html/latest/userspace-api/media/mediactl/media-controller.html>`__


Utilities to interact with the driver
-------------------------------------

Standard V4L2 utilities can be used to set these formats and frame rates. One
such tool is media-ctl.

To see the media pipeline to understand how all the components are connected in
software, the pipeline can be printed to the console using "media-ctl -p". This
would list all the elements in the pipeline, what they are connected to, and
their names. This information can then be used to set formats and frame rates on
various elements for the pipeline. For example, below command can be used to set
1920x1080 @ 30fps UYVY format on the sensor node:

::

    media-ctl --set-v4l2 '"sensor-name 9-0012":0 [fmt:UYVY8_2X8/1920x1080@1/30]'

This just sets the formats on the sensor and bridge. The format on the DMA
context (/dev/videoX) needs to be set separately. This can be done while
starting the capture with yavta for example. The below command can be run next
to start capturing the video stream to a file called "capture":

::

    yavta -c -Fcapture -s 1920x1080 -f UYVY /dev/video0

This command first sets the 1920x1080 UYVY format on the DMA context (which must
match the format on the sensor), and then starts capturing frames to a file
called "capture".

It is often useful to see the pipeline visually. media-ctl can print the
pipeline as a dot graph which can then be converted to an image for viewing. The
below set of commands can achieve this:

::

    media-ctl --print-dot | dot -Tpng > graph.png

Building the driver
-------------------

First, enable the DPHY using CONFIG_PHY_CADENCE_DPHY. Then enable the CSI2RX
bridge using CONFIG_VIDEO_CADENCE and CONFIG_VIDEO_CADENCE_CSI2RX. Finally,
enable CONFIG_VIDEO_TI_J721E_CSI2RX. The config for the sensor should also
be enabled.

The driver can be built-in or it can be a loadable module. If the driver is
built as a module, the module will be called j721e-csi2rx. Along with that, the
Cadence bridge and DPHY modules must also be loaded, which are called
cdns-csi2rx and cdns-dphy respectively.

Creating device tree nodes for sensor
=====================================

Since the sensor is a separate module and any sensor can be plugged in to the
board, the sensor device tree nodes are not included in the base dtb. Instead,
it should be added in as an overlay.

Below overlay is an example for adding the overlay nodes:

::

    // SPDX-License-Identifier: GPL-2.0
    /*
     * Copyright (C) 2021 Texas Instruments Incorporated - http://www.ti.com/
     */

    /dts-v1/;
    /plugin/;

    #include <dt-bindings/gpio/gpio.h>

    &main_i2c6 {
    	#address-cells = <1>;
    	#size-cells = <0>;

    	camera_sensor: camera@12 {
    		compatible = "manufacturer,sensor-compatible";
    		reg = <0x12>;

			/* Other sensor properties go here... */

    		port {
    			csi2_cam0: endpoint {
    				remote-endpoint = <&csi2rx0_in_sensor>;
    				clock-lanes = <0>;
    				/*
    				 * This example sensor uses 2 lanes. Other sensors might use
    				 * 1, 2, 3, or 4 lanes. Populate this property accordingly.
    				 * See Documentation/devicetree/bindings/media/video-interfaces.yaml
    				 * for more info.
    				 */
    				data-lanes = <1 2>;
    			};
    		};
    	};
    };

    &csi0_port0 {
    	status = "okay";

    	csi2rx0_in_sensor: endpoint {
    		remote-endpoint = <&csi2_cam0>;
    		bus-type = <4>; /* CSI2 DPHY. */
    		clock-lanes = <0>;
    		data-lanes = <1 2>;
    	};
    };

Enabling camera sensors
=========================

.. ifconfig:: CONFIG_part_variant in ('AM62X','AM62PX')

    SK-AM62 supports the following 15-pin FFC compatible camera modules with
    **OV5640** sensor:

        1. TEVI-OV5640-\*-RPI
        2. Digilent PCam5C
        3. ALINX AN5641

    They can be tested with the following steps:

    Applying sensor overlays
    ------------------------

    During bootup stop at u-boot prompt by pressing any key and enable camera devicetree overlay:
    ::

        # For Digilent PCam5C or ALINX AN5641
        setenv name_overlays k3-am62x-sk-csi2-ov5640.dtbo
        boot

        # For Technexion TEVI-OV5640
        setenv name_overlays k3-am62x-sk-csi2-tevi-ov5640.dtbo
        boot

    Once the overlay is applied, you can confirm that the sensor is being
    probed by checking the output of lsmod or the media graph:

    ::

        $ lsmod | grep ov5640
        ov5640                 36864  1
        v4l2_fwnode            20480  2 ov5640,cdns_csi2rx

        $ media-ctl -p
        Media controller API version 6.1.33
        Media device information
        ------------------------
        driver          j721e-csi2rx
        model           TI-CSI2RX
        serial
        bus info        platform:30102000.ticsi2rx
        hw revision     0x1
        driver version  6.1.33

        Device topology
        ....
        - entity 13: ov5640 4-003c (1 pad, 1 link, 0 route)
                     type V4L2 subdev subtype Sensor flags 0
                     device node name /dev/v4l-subdev2
                pad0: Source
                        [stream:0 fmt:UYVY8_1X16/640x480@1/30 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range
                         crop.bounds:(0,0)/2624x1964
                         crop:(16,14)/2592x1944]
                        -> "cdns_csi2rx.30101000.csi-bridge":0 [ENABLED,IMMUTABLE]
        ....


    Capturing raw frames
    --------------------

    Once the media pipeline is configured, you should be able to capture raw
    frames from the sensor using any tool compliant with v4l2 apis. For example
    you can use libcamera to capture 20 frames @ 480p:

    ::

        $ cam -c1 --stream width=640,height=480,pixelformat=UYVY -C20

    You can also capture at other sensor-supported resolutions:

    ::

        # List supported resolutions
        $ cam -c1 -I
        # Capture 20 frames @ 1024x768
        $ cam -c1 --stream width=1024,height=768,pixelformat=UYVY -C20

    To save the raw YUV frames to SD card for viewing later use the -F option:

    ::

        $ cam -c1 --stream width=640,height=480,pixelformat=UYVY -C20 -F#.uyvy
        $ ls *.uyvy
        -rw-r--r-- 1 root root 614400 Jan  1 19:19 cam0-stream0-000000.uyvy
        -rw-r--r-- 1 root root 614400 Jan  1 19:19 cam0-stream0-000001.uyvy
        -rw-r--r-- 1 root root 614400 Jan  1 19:19 cam0-stream0-000002.uyvy
        -rw-r--r-- 1 root root 614400 Jan  1 19:19 cam0-stream0-000003.uyvy
        -rw-r--r-- 1 root root 614400 Jan  1 19:19 cam0-stream0-000004.uyvy

    Alternatively you can use tools like yavta or v4l2-ctl, but please note
    they require manual configuration using media-ctl if you want to stream at
    a different resolution and formats than the default (640x480 UYVY):

    ::

        $ yavta -s 640x480 -f UYVY /dev/video0 -c20
        ....
        $ v4l2-ctl -d0 --stream-mmap -v width=640,height=480,pixelformat=UYVY


    .. note::

        Sometimes the sensor may not stream on the first attempt after sensor
        wakes up from runtime suspend state. To make it work reliably on every
        attempt, you can **disable runtime PM** for the sensor:

        ::

            $ echo "on" > /sys/devices/platform/bus@f0000/20020000.i2c/i2c-2/i2c-4/4-003c/power/control

    Capture to display
    ------------------

    If a display (HDMI or LVDS) is connected then use the following steps to view the camera frames:

    ::

        # As a window within weston desktop
        $ gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw, width=640, height=480, format=UYVY ! autovideosink

        # Direct KMS Sink
        $ systemctl stop weston
        $ gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw, width=640, height=480, format=UYVY ! queue ! kmssink driver-name=tidss plane-properties=s,zpos=1

    You can also replace v4l2src with libcamerasrc above if you want to test
    different sensor-supported resolutions like 480p, 720p etc.

    ::

        $ gst-launch-1.0 libcamerasrc ! video/x-raw, width=1024, height=768, format=UYVY ! autovideosink

    Suspend to RAM
    --------------

    The camera pipeline supports system supend to RAM on SK-AM62. You can refer
    to `Power Management
    <../Power_Management/pm_low_power_modes.html#suspend-to-ram-deep-sleep>`__ guide for
    more details.

    For example, you can start streaming from camera using any of the above
    methods and then suspend to RAM for 5 seconds using the following command:

    ::

        $ rtcwake -s 5 -m mem

    The system will automatically wake-up after 5 seconds, and camera streaming
    should resume from where it left (as long as the sensor supports it).

    The Technexion TEVI-OV5640 module supports this, but it may fail to set the
    sensor registers in time when built as a module. You can fix this by making
    it a part of the kernel image:

    .. code-block:: diff

        diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
        index 1f402994efed..0f081e5f96c1 100644
        --- a/arch/arm64/configs/defconfig
        +++ b/arch/arm64/configs/defconfig
        @@ -739,14 +739,14 @@ CONFIG_RC_DECODERS=y
         CONFIG_RC_DEVICES=y
         CONFIG_IR_MESON=m
         CONFIG_IR_SUNXI=m
        -CONFIG_MEDIA_SUPPORT=m
        +CONFIG_MEDIA_SUPPORT=y
         # CONFIG_DVB_NET is not set
         CONFIG_MEDIA_USB_SUPPORT=y
         CONFIG_USB_VIDEO_CLASS=m
         CONFIG_V4L_PLATFORM_DRIVERS=y
         CONFIG_SDR_PLATFORM_DRIVERS=y
         CONFIG_V4L_MEM2MEM_DRIVERS=y
        -CONFIG_VIDEO_CADENCE_CSI2RX=m
        +CONFIG_VIDEO_CADENCE_CSI2RX=y
         CONFIG_VIDEO_WAVE_VPU=m
         CONFIG_VIDEO_IMG_VXD_DEC=m
         CONFIG_VIDEO_IMG_VXE_ENC=m
        @@ -764,12 +764,12 @@ CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC=m
         CONFIG_VIDEO_SAMSUNG_S5P_JPEG=m
         CONFIG_VIDEO_SAMSUNG_S5P_MFC=m
         CONFIG_VIDEO_SUN6I_CSI=m
        -CONFIG_VIDEO_TI_J721E_CSI2RX=m
        +CONFIG_VIDEO_TI_J721E_CSI2RX=y
         CONFIG_VIDEO_HANTRO=m
         CONFIG_VIDEO_IMX219=m
         CONFIG_VIDEO_IMX390=m
         CONFIG_VIDEO_OV2312=m
        -CONFIG_VIDEO_OV5640=m
        +CONFIG_VIDEO_OV5640=y
         CONFIG_VIDEO_OV5645=m
         CONFIG_VIDEO_DS90UB953=m
         CONFIG_VIDEO_DS90UB960=m
        @@ -1309,8 +1309,8 @@ CONFIG_PHY_XGENE=y
         CONFIG_PHY_CAN_TRANSCEIVER=m
         CONFIG_PHY_SUN4I_USB=y
         CONFIG_PHY_CADENCE_TORRENT=y
        -CONFIG_PHY_CADENCE_DPHY=m
        -CONFIG_PHY_CADENCE_DPHY_RX=m
        +CONFIG_PHY_CADENCE_DPHY=y
        +CONFIG_PHY_CADENCE_DPHY_RX=y
         CONFIG_PHY_CADENCE_SIERRA=y
         CONFIG_PHY_MIXEL_MIPI_DPHY=m
         CONFIG_PHY_FSL_IMX8M_PCIE=y

    To re-build the kernel with above changes you can refer to the `Users Guide
    <../../../../Foundational_Components_Kernel_Users_Guide.html#configuring-the-kernel>`__.

.. ifconfig:: CONFIG_part_variant in ('AM62AX')

    SK-AM62A supports the following FPDLink cameras using fusion board: **IMX390,
    OV2312**; and the following 22-pin FFC compatible cameras: **IMX219**.

    For sensors directly connected to the SK using the FFC connector, the media
    graph is fairly simple. For example IMX219 is connected to the CSI-RX
    bridge directly, which ultimately ends up at a /dev/videoX node:

    .. Image:: /images/imx219-pipeline.png

    For sensors connected using FPDLink fusion board, the pipeline is a bit
    more complicated. For example OV2312 is a multi-stream sensor, which is
    first connected to a CSI-to-FPD serializer, and then to FPD-to-CSI
    deserializer, finally routing the two virtual channels (streams) to
    separate /dev/videoX nodes:

    .. Image:: /images/ov2312-pipeline.png

    Applying sensor overlays
    ------------------------

    To enable FPDLink cameras you will need to apply the device tree overlays
    for both the fusion board and the sensor at U-boot prompt:

    ::

        # For OV2312 connected on Fusion board RX Port 0:
        setenv name_overlays k3-am62a7-sk-fusion.dtbo k3-fpdlink-ov2312-0-0.dtbo
        boot

        # For RCM IMX390 connected on Fusion board RX Port 0:
        setenv name_overlays k3-am62a7-sk-fusion.dtbo k3-fpdlink-imx390-rcm-0-0.dtbo
        boot

    To enable camera connected to the 22-pin FFC connector, enable the sensor
    overlay at U-boot prompt:

    ::

        # For IMX219 connected to 22-pin FFC connector
        setenv name_overlays k3-am62x-sk-csi2-imx219.dtbo
        boot

    For more details on building or applying overlays permanently, refer to the
    `How to enable DT overlays in linux
    <../../../../How_to_Guides/Target/How_to_enable_DT_overlays_in_linux.html>`__
    guide.

    Configuring media pipeline
    --------------------------

    Once the overlay is applied, you can confirm that the sensor is being
    probed by checking the output of lsmod or the media graph:

    ::

        $ lsmod | grep imx219
        imx219                 24576  1
        v4l2_fwnode            24576  2 imx219,cdns_csi2rx

        $ media-ctl -p
        Media controller API version 6.1.33
        Media device information
        ------------------------
        driver          j721e-csi2rx
        model           TI-CSI2RX
        serial
        bus info        platform:30102000.ticsi2rx
        hw revision     0x1
        driver version  6.1.33

        Device topology
        ....
        - entity 15: imx219 4-0010 (1 pad, 1 link, 0 route)
                     type V4L2 subdev subtype Sensor flags 0
                     device node name /dev/v4l-subdev2
                pad0: Source
                        [stream:0 fmt:SRGGB10_1X10/1640x1232 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range
                         crop.bounds:(8,8)/3280x2464
                         crop:(8,8)/3280x2464]
                        -> "cdns_csi2rx.30101000.csi-bridge":0 [ENABLED,IMMUTABLE]
        ....

    The sensor and other subdevs (for example FPDLink ser/deser) should
    automatically get configured by the initialization script on the SD card:

    ::

        CSI Camera 0 detected
            device = /dev/video-rpi-cam0
            name = imx219
            format = [fmt:SRGGB10_1X10/1640x1232]
            subdev_id = /dev/v4l-rpi-subdev0
            isp_required = yes

    For manual configuration, like switching to a different resolution or
    bitdepth, you can use media-ctl as `explained above
    <#utilities-to-interact-with-the-driver>`__. For example you can switch to
    10-bit 1080p capture on IMX219 using:

    ::

        $ media-ctl --set-v4l2 '"imx219 4-0010":0[fmt:SRGGB10_1X10/1920x1080]'

    Capturing raw frames
    --------------------

    Once the media pipeline is configured, you should be able to capture raw
    frames from the sensor using any tool compliant with v4l2 apis. For example
    you can use yavta to capture 100 frames from IMX219 @ 1232p:

    ::

        $ yavta -s 1640x1232 -f SRGGB10 /dev/video-rpi-cam0 -c100
        Device /dev/video-rpi-cam0 opened.
        Device `j721e-csi2rx' on `platform:30102000.ticsi2rx' is a video output (without mplanes) device.
        Video format set: SRGGB10 (30314752) 1640x1232 (stride 3280) field none buffer size 4040960
        Video format: SRGGB10 (30314752) 1640x1232 (stride 3280) field none buffer size 4040960
        8 buffers requested.
        ....
        0 (0) [-] any 0 4040960 B 5147.594160 5147.594200 17.080 fps ts mono/EoF
        1 (1) [-] any 1 4040960 B 5147.627500 5147.627570 29.994 fps ts mono/EoF
        ....
        98 (2) [-] any 98 4040960 B 5150.860153 5150.860171 30.007 fps ts mono/EoF
        99 (3) [-] any 99 4040960 B 5150.893480 5150.893499 30.006 fps ts mono/EoF
        Captured 100 frames in 3.357886 seconds (29.780638 fps, 120342366.671406 B/s).
        8 buffers released.


    By default the frames are copied over to DDR and discarded later. You can
    optionally save a few frames to the SD card for debugging purposes:

    ::

        $ yavta -s 1640x1232 -f SRGGB10 /dev/video-rpi-cam0 -c5 -Fframe-#.bin
        ....
        $ ls -l frame-*.bin
        -rw-r--r-- 1 root root 2073600 Feb 22 05:24 frame-000000.bin
        -rw-r--r-- 1 root root 2073600 Feb 22 05:24 frame-000001.bin
        -rw-r--r-- 1 root root 2073600 Feb 22 05:24 frame-000002.bin
        -rw-r--r-- 1 root root 2073600 Feb 22 05:24 frame-000003.bin
        -rw-r--r-- 1 root root 2073600 Feb 22 05:24 frame-000004.bin

    The raw bayer frames can be viewed directly on the host machine using
    utilities like `7yuv <http://datahammer.de/7yuv_manual/index.htm>`__ or `PixelViewer
    <https://carinastudio.azurewebsites.net/PixelViewer/>`__, or converted
    using OpenCV.

    Capture to Display using ISP
    ----------------------------

    To use the full capture to display pipeline, you can use gstreamer to call
    the required ISP components to convert the raw frames, apply
    auto-exposure/auto-white-balance algorithms and other pre-processing
    blocks.

    You may have to stop the display server (weston) before running the below
    pipelines:

    ::

        $ systemctl stop weston.service

    Use the following pipeline for IMX219 1232p RAW10 mode:

    ::

        $ gst-launch-1.0 v4l2src device=/dev/video-rpi-cam0 io-mode=5 ! video/x-bayer,width=1640,height=1232,format=rggb10 ! \
        tiovxisp sensor-name=SENSOR_SONY_IMX219_RPI dcc-isp-file=/opt/imaging/imx219/linear/dcc_viss_10b_1640x1232.bin \
        sink_0::dcc-2a-file=/opt/imaging/imx219/linear/dcc_2a_10b_1640x1232.bin sink_0::device=/dev/v4l-rpi-subdev0 format-msb=9 ! \
        video/x-raw,format=NV12 ! queue ! kmssink driver-name=tidss plane-properties=s,zpos=1

    If the sensor is configured to capture at some other resolution or format
    (e.g. 1080p RAW8 mode) you can edit the above pipeline with the new width,
    height, format and dcc-\*-file parameters:

    ::

        $ gst-launch-1.0 v4l2src device=/dev/video-rpi-cam0 io-mode=5 ! video/x-bayer,width=1920,height=1080,format=bggr ! \
        tiovxisp sensor-name=SENSOR_SONY_IMX219_RPI dcc-isp-file=/opt/imaging/imx219/linear/dcc_viss_1920x1080.bin \
        sink_0::dcc-2a-file=/opt/imaging/imx219/linear/dcc_2a_1920x1080.bin sink_0::device=/dev/v4l-rpi-subdev0 ! \
        video/x-raw,format=NV12 ! queue ! kmssink driver-name=tidss plane-properties=s,zpos=1

    For OV2312 use mosaic to display both streams together:

    ::

        # Mosaic of RGB and IR streams
        $ gst-launch-1.0 \
        v4l2src device=/dev/video-ov2312-rgb-cam0 io-mode=5 ! video/x-bayer, width=1600, height=1300, format=bggi10 ! queue leaky=2 ! \
        tiovxisp sensor-name=SENSOR_OV2312_UB953_LI \
        dcc-isp-file=/opt/imaging/ov2312/linear/dcc_viss.bin \
        sink_0::dcc-2a-file=/opt/imaging/ov2312/linear/dcc_2a.bin sink_0::device=/dev/v4l-ov2312-subdev0 format-msb=9 \
        sink_0::pool-size=8 src::pool-size=8 ! \
        video/x-raw, format=NV12, width=1600, height=1300 ! queue ! mosaic.sink_0 \
        v4l2src device=/dev/video-ov2312-ir-cam0 io-mode=5 ! video/x-bayer, width=1600, height=1300, format=bggi10 ! queue leaky=2 ! \
        tiovxisp sensor-name=SENSOR_OV2312_UB953_LI \
        dcc-isp-file=/opt/imaging/ov2312/linear/dcc_viss.bin \
        sink_0::dcc-2a-file=/opt/imaging/ov2312/linear/dcc_2a.bin format-msb=9 sink_0::pool-size=8 src_0::pool-size=8 ! \
        video/x-raw, format=GRAY8, width=1600, height=1300 ! videoconvert ! \
        video/x-raw, format=NV12 ! queue ! mosaic.sink_1 \
        tiovxmosaic name=mosaic \
        sink_0::startx="<0>" sink_0::starty="<0>" sink_0::widths="<640>" sink_0::heights="<480>" \
        sink_1::startx="<640>" sink_1::starty="<480>" sink_1::widths="<640>" sink_1::heights="<480>" ! \
        queue ! kmssink driver-name=tidss plane-properties=s,zpos=1

.. ifconfig:: CONFIG_part_variant in ('J721E')

    J721E has two instances of CSI2RX capture subsystem and can support upto
    eight **IMX390** cameras using FPDLink fusion EVM. J721E EVM and SK also
    supports **OV5640** module connected to MIPI connector. J721E SK has two
    instances of 15-pin FFC camera connector to which **IMX219** based RPi camera
    modules can be interfaced.

    Applying sensor overlays
    ------------------------

    To enable FPDLink cameras you will need to apply the device tree overlays
    for both the fusion board and the sensor at U-boot prompt:

    ::

        # For single RCM IMX390 connected to RX port 0 on Fusion board EVM on J721E CPB:
        # FPDLink IMX390 camera overlays are named according to the port connected in the following
        # format : k3-j721e-fpdlink-imx390-rcm-<csi_port>-<fusion_rx_port>.dtbo
        => setenv name_overlays k3-j721e-fpdlink-cpb-fusion.dtbo k3-j721e-fpdlink-imx390-rcm-0-0.dtbo
        => boot

        # For single RCM IMX390 connected to RX port 0 on Fusion board EVM on J721E SK:
        => setenv name_overlays k3-j721e-fpdlink-sk-fusion.dtbo k3-j721e-fpdlink-imx390-rcm-0-0.dtbo
        => boot

    To enable IMX219 camera connected to the 22-pin FFC connectoron J721E SK,
    enable the sensor overlay at U-boot prompt:

    ::

        # For IMX219 connected to 15-pin FFC connector
        => setenv name_overlays k3-j721e-sk-rpi-cam-imx219.dtbo
        => boot

    For more details on building or applying overlays permanently, refer to the
    `How to enable DT overlays in linux
    <../../../../How_to_Guides/Target/How_to_enable_DT_overlays_in_linux.html>`__
    guide.

.. ifconfig:: CONFIG_part_variant in ('J721S2')

    J721S2 has two instances of CSI2RX capture subsystem and can support upto
    eight **IMX390** cameras using FPDLink fusion EVM, J721S2 EVM and AM68A SK also
    supports **OV5640** module connected to MIPI connector. AM68A SK has two
    instances of 22-pin FFC camera connector to which **IMX219** based RPi camera
    modules can be interfaced.

    Applying sensor overlays
    ------------------------

    To enable FPDLink cameras you will need to apply the device tree overlays
    for both the fusion board and the sensor at U-boot prompt:

    ::

        # For single RCM IMX390 connected to RX port 0 on Fusion board EVM on J721S2 CPB:
        # FPDLink IMX390 camera overlays are named according to the port connected in the following
        # format : k3-j721e-fpdlink-imx390-rcm-<csi_port>-<fusion_rx_port>.dtbo
        => setenv name_overlays k3-j721s2-fpdlink-cpb-fusion.dtbo k3-j721e-fpdlink-imx390-rcm-0-0.dtbo
        => boot

        # For single RCM IMX390 connected to RX port 0 on Fusion board EVM on AM68A SK:
        => setenv name_overlays k3-am68-sk-fpdlink-fusion.dtbo k3-j721e-fpdlink-imx390-rcm-0-0.dtbo
        => boot

    To enable IMX219 camera connected to the 22-pin FFC connectoron AM68A SK,
    enable the sensor overlay at U-boot prompt:

    ::

        # For IMX219 connected to 22-pin FFC connector
        => setenv name_overlays k3-am68-sk-bb-rpi-cam-imx219.dtbo
        => boot

    For more details on building or applying overlays permanently, refer to the
    `How to enable DT overlays in linux
    <../../../../How_to_Guides/Target/How_to_enable_DT_overlays_in_linux.html>`__
    guide.

.. ifconfig:: CONFIG_part_variant in ('J784S4')

    J784S4 has three instances of CSI2RX capture subsystem and can support upto
    twelve **IMX390** cameras using FPDLink fusion EVM, J784S4 EVM and AM69A SK also
    supports **OV5640** module connected to MIPI connector. AM69A SK has two
    instances of 22-pin FFC camera connector to which **IMX219** based RPi camera
    modules can be interfaced.

    Applying sensor overlays
    ------------------------

    To enable FPDLink cameras you will need to apply the device tree overlays
    for both the fusion board and the sensor at U-boot prompt:

    ::

        # For single RCM IMX390 connected to RX port 0 on Fusion board EVM on J721S2 CPB:
        # FPDLink IMX390 camera overlays are named according to the port connected in the following
        # format : k3-j721e-fpdlink-imx390-rcm-<csi_port>-<fusion_rx_port>.dtbo
        => setenv name_overlays k3-j784s4-fpdlink-fusion.dtbo k3-j721e-fpdlink-imx390-rcm-0-0.dtbo
        => boot

        # For single RCM IMX390 connected to RX port 0 on Fusion board EVM on AM69A SK:
        => setenv name_overlays k3-am69-sk-fpdlink-fusion.dtbo k3-j721e-fpdlink-imx390-rcm-0-0.dtbo
        => boot

    To enable IMX219 camera connected to the 22-pin FFC connectoron AM69A SK,
    enable the sensor overlay at U-boot prompt:

    ::

        # For IMX219 connected to 22-pin FFC connector
        => setenv name_overlays k3-am69-sk-rpi-cam-imx219.dtbo
        => boot

    For more details on building or applying overlays permanently, refer to the
    `How to enable DT overlays in linux
    <../../../../How_to_Guides/Target/How_to_enable_DT_overlays_in_linux.html>`__
    guide.
