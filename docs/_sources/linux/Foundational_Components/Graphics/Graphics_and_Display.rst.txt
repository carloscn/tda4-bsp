..
    The top level heading in this rst file would be level 2 header with `====`

.. include:: /_replacevars.rst

Introduction
============

.. ifconfig:: CONFIG_gpu_ip in ('SGX')

    TI SOCs like AM335x, AM437x, AM57xx and AM65xx are enabled with 3D cores,
    capable of accelerating 3D operations with dedicated hardware. The
    dedicated hardware is based on SGX series of devices from Imagination
    Technologies. The graphics cores only accelerate graphics operations,
    and do not perform video decode operations. For video acceleration,
    refer to respective Technical Reference Manuals for the SOCs.

    Below table lists the various TI families supported by this SDK, and the
    SGX core information

    .. list-table:: TI System on Chips, and SGX cores
       :header-rows: 1

       * - TI SOC Name
         - SGX Core
         - SGX Core Revision
         - Max SGX Core Frequency (MHz)
       * - AM335x
         - SGX530
         - 1.2.5
         - 200
       * - AM437x
         - SGX530
         - 1.2.5
         - 200
       * - AM57xx
         - SGX544
         - 1.1.6
         - 532
       * - AM65xx
         - SGX544
         - 1.1.7
         - 450

    The SGX cores in AM family support OpenGL\ |reg| ES 1.1 and OpenGL\ |reg| ES
    2.0 APIs.

.. ifconfig:: CONFIG_gpu_ip in ('Rogue_8XE')

    |__PART_FAMILY_DEVICE_NAMES__| device is enabled with 3D graphics
    accelerator based on the Rogue 8XE series from Imagination Technologies Inc.
    It enables the support of 3D graphics rendering using OpenGL\ |reg| ES
    API's. The OpenGL\ |reg| ES API's up to and including version 3.2 with
    render surfaces upto 4k and input textures upto 8k sizes are supported by
    the hardware. It also supports Vulkan |reg| up to API version 1.2.

    The following extensions are supported:

    .. list-table:: EGL client extensions

       * - EGL_EXT_client_extensions
       * - EGL_EXT_platform_base
       * - EGL_KHR_client_get_all_proc_addresses
       * - EGL_KHR_debug
       * - EGL_EXT_platform_wayland
       * - EGL_MESA_platform_gbm

    .. list-table:: EGL extensions

       * - EGL_ANDROID_native_fence_sync
       * - EGL_EXT_buffer_age
       * - EGL_EXT_create_context_robustness
       * - EGL_EXT_image_dma_buf_import
       * - EGL_EXT_image_dma_buf_import_modifiers
       * - EGL_IMG_context_priority
       * - EGL_KHR_config_attribs
       * - EGL_KHR_create_context
       * - EGL_KHR_fence_sync
       * - EGL_KHR_get_all_proc_addresses
       * - EGL_KHR_gl_renderbuffer_image
       * - EGL_KHR_gl_texture_2D_image
       * - EGL_KHR_gl_texture_cubmap_image
       * - EGL_KHR_image
       * - EGL_KHR_image_base
       * - EGL_KHR_image_pixmap
       * - EGL_KHR_no_config_context
       * - EGL_KHR_reusable_sync
       * - EGL_KHR_surfaceless_context
       * - EGL_KHR_wait_sync
       * - EGL_MESA_configless_context
       * - EGL_MESA_drm_image
       * - EGL_MESA_image_dma_buf_export
       * - EGL_WL_bind_wayland_display
       * - EGL_IMG_cl_image

    .. list-table:: GL extensions

       * - GL_ANDROID_extension_pack_es31a
       * - GL_EXT_blend_minmax
       * - GL_EXT_buffer_storage
       * - GL_EXT_clip_control
       * - GL_EXT_color_buffer_float
       * - GL_EXT_conservative_depth
       * - GL_EXT_copy_image
       * - GL_EXT_discard_framebuffer
       * - GL_EXT_draw_buffers
       * - GL_EXT_draw_buffers_indexed
       * - GL_EXT_draw_elements_base_vertex
       * - GL_EXT_EGL_image_array
       * - GL_EXT_float_blend
       * - GL_EXT_geometry_point_size
       * - GL_EXT_geometry_shader
       * - GL_EXT_gpu_shader5
       * - GL_EXT_memory_object
       * - GL_EXT_multisampled_render_to_texture
       * - GL_EXT_multisampled_render_to_texture2
       * - GL_EXT_occlusion_query_boolean
       * - GL_EXT_polygon_offset_clamp
       * - GL_EXT_primitive_bounding_box
       * - GL_EXT_pvrtc_sRGB
       * - GL_EXT_read_format_bgra
       * - GL_EXT_robustness
       * - GL_EXT_separate_shader_objects
       * - GL_EXT_shader_framebuffer_fetch
       * - GL_EXT_shader_group_vote
       * - GL_EXT_shader_implicit_conversions
       * - GL_EXT_shader_io_blocks
       * - GL_EXT_shader_non_constant_global_initializers
       * - GL_EXT_shader_pixel_local_storage
       * - GL_EXT_shader_pixel_local_storage2
       * - GL_EXT_shader_texture_lod
       * - GL_EXT_shadow_samplers
       * - GL_EXT_sparse_texture
       * - GL_EXT_sRGB_write_control
       * - GL_EXT_tessellation_point_size
       * - GL_EXT_tessellation_shader
       * - GL_EXT_texture_border_clamp
       * - GL_EXT_texture_buffer
       * - GL_EXT_texture_cube_map_array
       * - GL_EXT_texture_filter_anisotropic
       * - GL_EXT_texture_format_BGRA8888
       * - GL_EXT_texture_rg
       * - GL_EXT_texture_sRGB_decode
       * - GL_EXT_texture_sRGB_R8
       * - GL_EXT_texture_sRGB_RG8
       * - GL_EXT_YUV_target
       * - GL_IMG_bindless_texture
       * - GL_IMG_framebuffer_downsample
       * - GL_IMG_multisampled_render_to_texture
       * - GL_IMG_program_binary
       * - GL_IMG_texture_compression_pvrtc
       * - GL_IMG_texture_compression_pvrtc2
       * - GL_IMG_texture_filter_cubic
       * - GL_IMG_texture_format_BGRA8888
       * - GL_IMG_texture_npot
       * - GL_KHR_blend_equation_advanced
       * - GL_KHR_blend_equation_advanced_coherent
       * - GL_KHR_debug
       * - GL_KHR_robustness
       * - GL_KHR_texture_compression_astc_ldr
       * - GL_KHR_compressed_ETC1_RGB8_texutre
       * - GL_OES_depth24
       * - GL_OES_depth_texture
       * - GL_OES_draw_buffers_indexed
       * - GL_OES_draw_elements_base_vertex
       * - GL_OES_EGL_image_external_essl3
       * - GL_OES_EGL_sync
       * - GL_OES_element_index_uint
       * - GL_OES_fragment_precision_high
       * - GL_OES_geometry_point_size
       * - GL_OES_geometry_shader
       * - GL_OES_get_program_binary
       * - GL_OES_gpu_shader5
       * - GL_OES_mapbuffer
       * - GL_OES_packed_depth_stencil
       * - GL_OES_required_internalformat
       * - GL_OES_rgb8_rgba8
       * - GL_OES_sample_shading
       * - GL_OES_sample_variables
       * - GL_OES_shader_image_atomic
       * - GL_OES_shader_io_blocks
       * - GL_OES_shader_multisample_interpolation
       * - GL_OES_standard_derivatives
       * - GL_OES_surfaceless_context
       * - GL_OES_tessellation_point_size
       * - GL_OES_tessellation_shader
       * - GL_OES_texture_border_clamp
       * - GL_OES_texture_buffer
       * - GL_OES_texture_cube_map_array
       * - GL_OES_texture_float
       * - GL_OES_texture_half_float
       * - GL_OES_texture_npot
       * - GL_OES_texture_stencil8
       * - GL_OES_texture_storage_multisample_2d_array
       * - GL_OES_vertex_array_object
       * - GL_OES_vertex_half_float

    .. list-table:: Vulkan instance extensions

       * - VK_KHR_device_group_creation
         - v1
       * - VK_KHR_external_fence_capabilities
         - v1
       * - VK_KHR_external_memory_capabilities
         - v1
       * - VK_KHR_external_semaphore_capabilities
         - v1
       * - VK_KHR_get_physical_device_properties2
         - v2
       * - VK_KHR_get_surface_capabilities2
         - v1
       * - VK_KHR_surface
         - v25
       * - VK_KHR_wayland_surface
         - v6
       * - VK_KHR_xcb_surface
         - v6
       * - VK_KHR_xlib_surface
         - v6
       * - VK_EXT_debug_report
         - v10
       * - VK_EXT_debug_utils
         - v2

.. ifconfig:: CONFIG_gpu_ip in ('Rogue_AXE')

    |__PART_FAMILY_DEVICE_NAMES__| device is enabled with 3D graphics
    accelerator based on the A-Series AXE-1-16M from Imagination Technologies Inc.
    It enables the support of 3D graphics rendering using OpenGL\ |reg| ES
    API's. The OpenGL\ |reg| ES API's up to and including version 3.1 with
    render surfaces upto 4k and input textures upto 8k sizes are supported by
    the hardware. It also supports Vulkan |reg| up to API version 1.2.

    The following extensions are supported:

    .. list-table:: EGL client extensions

       * - EGL_EXT_client_extensions
       * - EGL_EXT_device_base
       * - EGL_EXT_device_enumeration
       * - EGL_EXT_device_query
       * - EGL_EXT_platform_base
       * - EGL_KHR_client_get_all_proc_addresses
       * - EGL_KHR_debug EGL_EXT_platform_device
       * - EGL_EXT_platform_wayland
       * - EGL_KHR_platform_wayland
       * - EGL_MESA_platform_gbm
       * - EGL_KHR_platform_gbm
       * - EGL_MESA_platform_surfaceless

    .. list-table:: EGL extensions

       * - EGL_ANDROID_native_fence_sync
       * - EGL_EXT_buffer_age
       * - EGL_EXT_create_context_robustness
       * - EGL_EXT_image_dma_buf_import
       * - EGL_EXT_image_dma_buf_import_modifiers
       * - EGL_EXT_image_gl_colorspace
       * - EGL_EXT_swap_buffers_with_damage
       * - EGL_EXT_yuv_surface
       * - EGL_IMG_context_priority
       * - EGL_KHR_cl_event2
       * - EGL_KHR_config_attribs
       * - EGL_KHR_create_context
       * - EGL_KHR_fence_sync
       * - EGL_KHR_get_all_proc_addresses
       * - EGL_KHR_gl_colorspace
       * - EGL_KHR_gl_renderbuffer_image
       * - EGL_KHR_gl_texture_2D_image
       * - EGL_KHR_gl_texture_3D_image
       * - EGL_KHR_gl_texture_cubemap_image
       * - EGL_KHR_image_base
       * - EGL_KHR_no_config_context
       * - EGL_KHR_partial_update
       * - EGL_KHR_reusable_sync
       * - EGL_KHR_surfaceless_context
       * - EGL_KHR_swap_buffers_with_damage
       * - EGL_EXT_pixel_format_float
       * - EGL_KHR_wait_sync
       * - EGL_MESA_configless_context
       * - EGL_MESA_drm_image
       * - EGL_MESA_image_dma_buf_export
       * - EGL_WL_bind_wayland_display
       * - EGL_WL_create_wayland_buffer_from_image
       * - EGL_IMG_cl_image

    .. list-table:: GL extensions

       * - GL_APPLE_texture_format_BGRA8888
       * - GL_EXT_blend_minmax
       * - GL_EXT_buffer_storage
       * - GL_EXT_clip_control
       * - GL_EXT_color_buffer_float
       * - GL_EXT_color_buffer_half_float
       * - GL_EXT_compressed_ETC1_RGB8_sub_texture
       * - GL_EXT_conservative_depth
       * - GL_EXT_copy_image
       * - GL_EXT_discard_framebuffer
       * - GL_EXT_draw_buffers
       * - GL_EXT_draw_buffers_indexed
       * - GL_EXT_draw_elements_base_vertex
       * - GL_EXT_EGL_image_array
       * - GL_EXT_float_blend
       * - GL_EXT_gpu_shader5
       * - GL_EXT_memory_object
       * - GL_EXT_memory_object_fd
       * - GL_EXT_multi_draw_arrays
       * - GL_EXT_multisampled_render_to_texture
       * - GL_EXT_multisampled_render_to_texture2
       * - GL_EXT_occlusion_query_boolean
       * - GL_EXT_polygon_offset_clamp
       * - GL_EXT_read_format_bgra
       * - GL_EXT_robustness
       * - GL_EXT_separate_shader_objects
       * - GL_EXT_shader_framebuffer_fetch
       * - GL_EXT_shader_group_vote
       * - GL_EXT_shader_implicit_conversions
       * - GL_EXT_shader_io_blocks
       * - GL_EXT_shader_non_constant_global_initializers
       * - GL_EXT_shader_pixel_local_storage
       * - GL_EXT_shader_pixel_local_storage2
       * - GL_EXT_shader_texture_lod
       * - GL_EXT_shadow_samplers
       * - GL_EXT_sparse_texture
       * - GL_EXT_sRGB_write_control
       * - GL_EXT_texture_border_clamp
       * - GL_EXT_texture_buffer
       * - GL_EXT_texture_cube_map_array
       * - GL_EXT_texture_format_BGRA8888
       * - GL_EXT_texture_format_sRGB_override
       * - GL_EXT_texture_rg
       * - GL_EXT_texture_shadow_lod
       * - GL_EXT_texture_sRGB_decode
       * - GL_EXT_texture_sRGB_R8
       * - GL_EXT_texture_sRGB_RG8
       * - GL_EXT_YUV_target
       * - GL_IMG_framebuffer_downsample
       * - GL_IMG_multisampled_render_to_texture
       * - GL_IMG_program_binary
       * - GL_IMG_read_format
       * - GL_IMG_shader_binary
       * - GL_IMG_texture_format_BGRA8888
       * - GL_IMG_texture_npot
       * - GL_KHR_blend_equation_advanced
       * - GL_KHR_blend_equation_advanced_coherent
       * - GL_KHR_debug
       * - GL_KHR_robustness
       * - GL_OES_compressed_ETC1_RGB8_texture
       * - GL_OES_depth24
       * - GL_OES_depth_texture
       * - GL_OES_draw_buffers_indexed
       * - GL_OES_draw_elements_base_vertex
       * - GL_OES_EGL_image
       * - GL_OES_EGL_image_external
       * - GL_OES_EGL_image_external_essl3
       * - GL_OES_EGL_sync
       * - GL_OES_element_index_uint
       * - GL_OES_fragment_precision_high
       * - GL_OES_get_program_binary
       * - GL_OES_gpu_shader5
       * - GL_OES_mapbuffer
       * - GL_OES_packed_depth_stencil
       * - GL_OES_required_internalformat
       * - GL_OES_rgb8_rgba8
       * - GL_OES_sample_shading
       * - GL_OES_sample_variables
       * - GL_OES_shader_image_atomic
       * - GL_OES_shader_io_blocks
       * - GL_OES_shader_multisample_interpolation
       * - GL_OES_standard_derivatives
       * - GL_OES_surfaceless_context
       * - GL_OES_texture_border_clamp
       * - GL_OES_texture_buffer
       * - GL_OES_texture_cube_map_array
       * - GL_OES_texture_float
       * - GL_OES_texture_half_float
       * - GL_OES_texture_npot
       * - GL_OES_texture_stencil8
       * - GL_OES_texture_storage_multisample_2d_array
       * - GL_OES_vertex_array_object
       * - GL_OES_vertex_half_float

    .. list-table:: Vulkan instance extensions

       * - VK_KHR_device_group_creation
         - v1
       * - VK_KHR_external_fence_capabilities
         - v1
       * - VK_KHR_external_memory_capabilities
         - v1
       * - VK_KHR_external_semaphore_capabilities
         - v1
       * - VK_KHR_get_physical_device_properties2
         - v2
       * - VK_KHR_get_surface_capabilities2
         - v1
       * - VK_KHR_surface
         - v25
       * - VK_KHR_wayland_surface
         - v6
       * - VK_KHR_xcb_surface
         - v6
       * - VK_KHR_xlib_surface
         - v6
       * - VK_EXT_debug_report
         - v10
       * - VK_EXT_debug_utils
         - v2

.. ifconfig:: CONFIG_gpu_ip in ('Rogue_BXS')

    |__PART_FAMILY_DEVICE_NAMES__| device is enabled with 3D graphics
    accelerator based on the B-Series BXS-4-64 from Imagination Technologies
    Inc. It enables the support of 3D graphics rendering using OpenGL\ |reg| ES
    API's. The OpenGL\ |reg| ES API's up to and including version 3.2 with
    render surfaces upto 4k and input textures upto 8k sizes are supported by
    the hardware. It also supports Vulkan |reg| up to API version 1.2.

    The following extensions are supported:

    .. list-table:: EGL client extensions

       * - EGL_EXT_client_extensions
       * - EGL_EXT_device_base
       * - EGL_EXT_device_enumeration
       * - EGL_EXT_device_query
       * - EGL_EXT_platform_base
       * - EGL_KHR_client_get_all_proc_addresses
       * - EGL_KHR_debug
       * - EGL_EXT_platform_device
       * - EGL_EXT_platform_wayland
       * - EGL_KHR_platform_wayland
       * - EGL_MESA_platform_gbm
       * - EGL_KHR_platform_gbm
       * - EGL_MESA_platform_surfaceless

    .. list-table:: EGL extensions

       * - EGL_ANDROID_native_fence_sync
       * - EGL_EXT_buffer_age
       * - EGL_EXT_create_context_robustness
       * - EGL_EXT_image_dma_buf_import
       * - EGL_EXT_image_dma_buf_import_modifiers
       * - EGL_EXT_image_gl_colorspace
       * - EGL_EXT_yuv_surface
       * - EGL_IMG_context_priority
       * - EGL_KHR_cl_event2
       * - EGL_KHR_config_attribs
       * - EGL_KHR_create_context
       * - EGL_KHR_fence_sync
       * - EGL_KHR_get_all_proc_addresses
       * - EGL_KHR_gl_colorspace
       * - EGL_KHR_gl_renderbuffer_image
       * - EGL_KHR_gl_texture_2D_image
       * - EGL_KHR_gl_texture_3D_image
       * - EGL_KHR_gl_texture_cubemap_image
       * - EGL_KHR_image
       * - EGL_KHR_image_base
       * - EGL_KHR_image_pixmap
       * - EGL_KHR_no_config_context
       * - EGL_KHR_partial_update
       * - EGL_KHR_reusable_sync
       * - EGL_KHR_surfaceless_context
       * - EGL_EXT_pixel_format_float
       * - EGL_KHR_wait_sync
       * - EGL_MESA_configless_context
       * - EGL_MESA_drm_image
       * - EGL_MESA_image_dma_buf_export
       * - EGL_WL_bind_wayland_display
       * - EGL_IMG_cl_image

    .. list-table:: GL extensions

       * - GL_ANDROID_extension_pack_es31a
       * - GL_APPLE_texture_format_BGRA8888
       * - GL_EXT_EGL_image_array
       * - GL_EXT_YUV_target
       * - GL_EXT_blend_minmax
       * - GL_EXT_buffer_storage
       * - GL_EXT_clip_control
       * - GL_EXT_color_buffer_float
       * - GL_EXT_color_buffer_half_float
       * - GL_EXT_compressed_ETC1_RGB8_sub_texture
       * - GL_EXT_conservative_depth
       * - GL_EXT_copy_image
       * - GL_EXT_discard_framebuffer
       * - GL_EXT_draw_buffers
       * - GL_EXT_draw_buffers_indexed
       * - GL_EXT_draw_elements_base_vertex
       * - GL_EXT_float_blend
       * - GL_EXT_geometry_point_size
       * - GL_EXT_geometry_shader
       * - GL_EXT_gpu_shader5
       * - GL_EXT_memory_object
       * - GL_EXT_memory_object_fd
       * - GL_EXT_multi_draw_arrays
       * - GL_EXT_multisampled_render_to_texture
       * - GL_EXT_multisampled_render_to_texture2
       * - GL_EXT_occlusion_query_boolean
       * - GL_EXT_polygon_offset_clamp
       * - GL_EXT_primitive_bounding_box
       * - GL_EXT_read_format_bgra
       * - GL_EXT_robustness
       * - GL_EXT_sRGB_write_control
       * - GL_EXT_separate_shader_objects
       * - GL_EXT_shader_framebuffer_fetch
       * - GL_EXT_shader_group_vote
       * - GL_EXT_shader_implicit_conversions
       * - GL_EXT_shader_io_blocks
       * - GL_EXT_shader_non_constant_global_initializers
       * - GL_EXT_shader_pixel_local_storage
       * - GL_EXT_shader_pixel_local_storage2
       * - GL_EXT_shader_texture_lod
       * - GL_EXT_shadow_samplers
       * - GL_EXT_sparse_texture
       * - GL_EXT_tessellation_point_size
       * - GL_EXT_tessellation_shader
       * - GL_EXT_texture_border_clamp
       * - GL_EXT_texture_buffer
       * - GL_EXT_texture_cube_map_array
       * - GL_EXT_texture_format_BGRA8888
       * - GL_EXT_texture_format_sRGB_override
       * - GL_EXT_texture_rg
       * - GL_EXT_texture_sRGB_R8
       * - GL_EXT_texture_sRGB_RG8
       * - GL_EXT_texture_sRGB_decode
       * - GL_EXT_texture_shadow_lod
       * - GL_IMG_framebuffer_downsample
       * - GL_IMG_multisampled_render_to_texture
       * - GL_IMG_program_binary
       * - GL_IMG_read_format
       * - GL_IMG_shader_binary
       * - GL_IMG_texture_format_BGRA8888
       * - GL_IMG_texture_npot
       * - GL_KHR_blend_equation_advanced
       * - GL_KHR_blend_equation_advanced_coherent
       * - GL_KHR_debug
       * - GL_KHR_robustness
       * - GL_KHR_texture_compression_astc_ldr
       * - GL_OES_EGL_image
       * - GL_OES_EGL_image_external
       * - GL_OES_EGL_image_external_essl3
       * - GL_OES_EGL_sync
       * - GL_OES_compressed_ETC1_RGB8_texture
       * - GL_OES_depth24
       * - GL_OES_depth_texture
       * - GL_OES_draw_buffers_indexed
       * - GL_OES_draw_elements_base_vertex
       * - GL_OES_element_index_uint
       * - GL_OES_fragment_precision_high
       * - GL_OES_geometry_point_size
       * - GL_OES_geometry_shader
       * - GL_OES_get_program_binary
       * - GL_OES_gpu_shader5
       * - GL_OES_mapbuffer
       * - GL_OES_packed_depth_stencil
       * - GL_OES_required_internalformat
       * - GL_OES_rgb8_rgba8
       * - GL_OES_sample_shading
       * - GL_OES_sample_variables
       * - GL_OES_shader_image_atomic
       * - GL_OES_shader_io_blocks
       * - GL_OES_shader_multisample_interpolation
       * - GL_OES_standard_derivatives
       * - GL_OES_surfaceless_context
       * - GL_OES_tessellation_point_size
       * - GL_OES_tessellation_shader
       * - GL_OES_texture_border_clamp
       * - GL_OES_texture_buffer
       * - GL_OES_texture_cube_map_array
       * - GL_OES_texture_float
       * - GL_OES_texture_half_float
       * - GL_OES_texture_npot
       * - GL_OES_texture_stencil8
       * - GL_OES_texture_storage_multisample_2d_array
       * - GL_OES_vertex_array_object
       * - GL_OES_vertex_half_float
       * - GL_OVR_multiview
       * - GL_OVR_multiview2
       * - GL_OVR_multiview_multisampled_render_to_texture

    .. list-table:: Vulkan instance extensions

       * - VK_KHR_device_group_creation
         - v1
       * - VK_KHR_external_fence_capabilities
         - v1
       * - VK_KHR_external_memory_capabilities
         - v1
       * - VK_KHR_external_semaphore_capabilities
         - v1
       * - VK_KHR_get_physical_device_properties2
         - v2
       * - VK_KHR_get_surface_capabilities2
         - v1
       * - VK_KHR_surface
         - v25
       * - VK_KHR_wayland_surface
         - v6
       * - VK_KHR_xcb_surface
         - v6
       * - VK_KHR_xlib_surface
         - v6
       * - VK_EXT_debug_report
         - v10
       * - VK_EXT_debug_utils
         - v2

For more information about the supported OpenGL\ |reg| ES and EGL\ |reg|
extensions see:

- https://docs.imgtec.com/reference-manuals/open-gl-es-extensions/html/topics/overview.html
- https://registry.khronos.org/OpenGL/

.. ifconfig:: CONFIG_gpu_ip in ('Rogue_BXS', 'Rogue_AXE')

    .. note:: OpenCL\ |reg| libraries are currently provided without support at
              https://git.ti.com

The OpenGL\ |reg| ES and EGL\ |reg| libraries are packaged with the
|__SDK_FULL_NAME__| and are used by graphics stacks such as Wayland/Weston. The
drivers run on an ARM core and programs the firmware running inside a GPU core
with rendering commands submitted by the user applications.

.. ifconfig:: CONFIG_part_family in ('J7_family', 'AM62X_family')

   Other features of the Rogue series of GPUs include bilinear and trilinear filtering.

   Support for the following pixel formats:

   .. list-table:: Supported surface pixel formats

      * - ARGB8888
      * - BGRA8888
      * - RGB565

   .. list-table:: Supported texture pixel formats

      * - ARGB4444
      * - ARGB8888
      * - BGRA8888
      * - RGB565
      * - RGBA5551
      * - YUV420
      * - YUYV
      * - NV12

   Support for Ericsson Texture Compression (ETC1 and ETC2) on input textures.
   For an example toolkit to interact with these texture compression mechanisms,
   see the Khronos `KTX-Software
   <https://github.com/KhronosGroup/KTX-Software>`_ project.

.. ifconfig:: CONFIG_gpu_ip in ('Rogue_AXE')

   Support for up to 2Kx2K render surfaces.

   Support for OS controlled Active Power Management, enabled by default.

   Support for OS suspend and resume functions. See
   :doc:`/linux/How_to_Guides/Target/How_to_suspend_to_ram_on_AM62x` for more
   info.

.. ifconfig:: CONFIG_gpu_ip in ('Rogue_BXS', 'Rogue_8XE')

   Support for up to 4Kx4K render surfaces.

The rest of this page will cover the following topics:

.. ifconfig:: CONFIG_gpu_ip in ('SGX')

    - Software architecture of Graphics
    - Instructions on how to run graphics demos
    - Instructions on how to run DSS application
    - Instructions on how launch Weston
    - Instructions on how to run PVR tools
    - SoC Performance Monitoring Tools
    - QT and GTK+ graphics frameworks
    - Migration Guide
    - AM3 Beagle Bone Black Board Configuration
    - SGX Debugging Tips

.. ifconfig:: CONFIG_gpu_ip in ('Rogue_8XE', 'Rogue_AXE', 'Rogue_BXS')

    - Software architecture of Graphics
    - Instructions on how to run graphics demos
    - Instructions on how to run DSS application
    - Instructions on how launch Weston
    - Instructions on how to run PVR tools


Software Architecture
=====================

The picture below shows the software architecture of Graphics in
|__SDK_FULL_NAME__|.

.. ifconfig:: CONFIG_part_family in ('General_family', 'AM335X_family', 'AM437X_family')

    .. figure:: ../../../images/Graphic_software_stacks_DRM.png
        :align: center

        Graphics Software Stack

.. ifconfig:: CONFIG_part_family in ('J7_family', 'AM62X_family')

    .. figure:: ../../../images/rogue-graphics-software-stack.png
        :align: center

        PSDK Linux Rogue Graphics Software Stack

.. ifconfig:: CONFIG_part_family in ('J7_family', 'AM62X_family')

   Please note that RGX-KM in this context refers to the pvrsrvkm kernel module, which is currently provided at:
   https://git.ti.com/cgit/graphics/ti-img-rogue-driver

   This is included by default in the SDK. The kernel module is located at:

   .. code-block:: console

       # /lib/modules/$(uname -r)/extra/pvrsrvkm.ko


Graphics Demos
==============

Along with the graphics driver and userspace libraries, the SDK also includes
example applications. Some of the demos are based on the IMG
Native_SDK examples.

.. ifconfig:: CONFIG_gpu_ip in ('SGX')

    The following 3D Graphics demos are available via Matrix. The table
    below provides a list of these demos, with a brief description.

    .. list-table:: Demos via Matrix
       :widths: 25 75
       :header-rows: 1

       * - Demo Name
         - Details
       * - ChameleonMan
         - This demo shows a matrix skinned character in combination with bump
           mapping.
       * - CoverFlow
         - This is a demonstration of a coverflow style effect
       * - ExampleUI
         - This demo shows how to efficiently render sprites and interface
           elements.
       * - Navigation
         - This is a demonstration of how to implement rendering algorithms for
           Navigation software.
       * - Kmscube
         - This demo shows how to render and display multi-colored spinning cube

    .. rubric:: Running demos in Null Window system mode
       :name: gfx-demos-in-nullws

    The graphics demos can also be run in null-window system mode outside of Wayland
    windowing system as full screen applications. In order to do so, exit Weston by
    pressing Ctrl-Alt-Backspace from the keyboard which connects to the EVM. Then,
    if the LCD screen stays in "Please wait...", press Ctrl-Alt-F1 to go to the
    command line on LCD console. After that, the command line can be used from
    serial console, SSH console, or LCD console.

    Please make sure the board is connected to at least one display before
    running these demos.

    .. code-block:: console

        # /usr/bin/SGX/demos/DRM/OGLES2Coverflow
        # /usr/bin/SGX/demos/DRM/OGLES2ChameleonMan
        # /usr/bin/SGX/demos/DRM/OGLES2ExampleUI
        # /usr/bin/SGX/demos/DRM/OGLES2Navigation

    After you see the output on the display interface, hit *q* to terminate
    the application.

    Some of the demos under null windowing system require the user to pass in
    the drm connector id. For information on how to get connector id please
    refer to the Display_ section.

.. ifconfig:: CONFIG_gpu_ip in ('Rogue_8XE', 'Rogue_AXE', 'Rogue_BXS')

    The following demos are available to run under the Wayland windowing system.

    .. code-block:: console

        # /usr/bin/SGX/demos/Wayland/OpenGLESDeferredShading
        # /usr/bin/SGX/demos/Wayland/OpenGLESGaussianBlur
        # /usr/bin/SGX/demos/Wayland/OpenGLESImageBasedLighting
        # /usr/bin/SGX/demos/Wayland/OpenGLESIntroducingPVRCamera
        # /usr/bin/SGX/demos/Wayland/OpenGLESIntroducingPVRUtils
        # /usr/bin/SGX/demos/Wayland/OpenGLESIntroducingUIRenderer
        # /usr/bin/SGX/demos/Wayland/OpenGLESNavigation2D
        # /usr/bin/SGX/demos/Wayland/OpenGLESNavigation3D
        # /usr/bin/SGX/demos/Wayland/OpenGLESParticleSystem

    Additionally demos using the Null Window System / KMS / DRM / EGLFS are
    provided with Qt. By default EGLFS will use the eglfs\_kms backend.

    .. code-block:: console

        # /usr/share/qt5/examples/opengl/hellogles3/hellogles3 -platform eglfs
        # /usr/share/qt5/examples/opengl/2dpainting/2dpainting -platform eglfs
        # /usr/share/qt5/examples/opengl/paintedwindow/paintedwindow -platform eglfs

    The default eglfs\_kms configuration file for Qt5 is located at:

    .. code-block:: console

        # /etc/qt5/eglfs_kms_cfg.json

    For more information about Qt's EGLFS and using Qt5 in embedded
    applications see:

    - https://doc.qt.io/qt-5/embedded-linux.html


Display
=======

TI SoC's are equipped with Display SubSystem (DSS) hardware to provide hardware
acceleration for alpha blending of overlays and color conversion. The DSS
hardware is exposed to the software drm API available through ``libdrm`` module.
Through this drm interface, a user space program can perform *mode setting* of
the display.

The drm module models the display hardware as a series of abstract hardware
blocks and manages them through the API. The blocks are:

  - CRTC\ [#f1]_\: represents a scanout engine that generates video timing signal from
    the data pointed to by the scanout buffer
  - Connector: represents where the video timing signal is sent across to the
    display
  - Encoder: transforms the video timing signal from CRTC to a format that is
    suitable for sending across the connector
  - Plane: represents the overlay buffer that a CRTC can be fed with

A utility application ``modetest`` can be used to get the list of available drm
blocks. All the information available for the device can be displayed by using
it.

Finding Connector ID
--------------------

Run the below ``modetest`` command:

.. ifconfig:: CONFIG_part_family in ('General_family', 'AM335X_family', 'AM437X_family')

    .. code-block:: console

        # modetest -c

.. ifconfig:: CONFIG_part_family in ('J7_family')

    .. code-block:: console

        # modetest -M tidss -c

Look for the display device for which the connector ID is required -
such as HDMI, LCD etc.

.. code-block:: text

    Connectors:
    id      encoder status          type    size (mm)       modes   encoders
    4       3       connected       HDMI-A  480x270         20      3
      modes:
            name refresh (Hz) hdisp hss hse htot vdisp vss vse vtot)
      1920x1080 60 1920 2008 2052 2200 1080 1084 1089 1125 flags: phsync, pvsync; type: preferred, driver
    ...
    16      15      connected       unknown 0x0             1       15
      modes:
            name refresh (Hz) hdisp hss hse htot vdisp vss vse vtot)
      800x480 60 800 1010 1040 1056 480 502 515 525 flags: nhsync, nvsync; type: preferred, driver

The modes displayed are the various resolutions supported by the connected
display.

Finding Plane ID
----------------

To find the Plane ID, run the ``modetest`` command:

.. ifconfig:: CONFIG_part_family in ('General_family', 'AM335X_family', 'AM437X_family')

    .. code-block:: console

        # modetest -p

.. ifconfig:: CONFIG_part_family in ('J7_family')

    .. code-block:: console

        # modetest -M tidss -p

which should show something like below:

.. code-block:: text

    Planes:
    id      crtc    fb      CRTC x,y        x,y     gamma size
    19      0       0       0,0             0,0     0
     formats: RG16 RX12 XR12 RA12 AR12 XR15 AR15 RG24 RX24 XR24 RA24 AR24 NV12 YUYV UYVY
     props:
     ...
    20      0       0       0,0             0,0     0
     formats: RG16 RX12 XR12 RA12 AR12 XR15 AR15 RG24 RX24 XR24 RA24 AR24 NV12 YUYV UYVY
     props:
     ...

.. ifconfig:: CONFIG_part_family in ('General_family', 'AM335X_family', 'AM437X_family')

    .. rubric:: kmscube
       :name: kmscube

    Run kmscube on the default display:

    .. code-block:: console

          # kmscube

    Run kmscube on the secondary display:

    .. code-block:: console

          # kmscube -c <connector-id>

    For example, if the connector id for the secondary display is 16:

    .. code-block:: console

          # kmscube -c 16

    Run kmscube on all connected displays (LCD & HDMI):

    .. code-block:: console

          # kmscube -a

.. ifconfig:: CONFIG_part_family in ('General_family', 'AM335X_family', 'AM437X_family')

    .. rubric:: Running DSS Applications
       :name: running-dss-applications

    DSS applications are omapdrm based. These will demonstrate the clone
    mode, extended mode, overlay window, z-order and alpha blending
    features. To demonstrate clone and extended mode, HDMI display must be
    connected to board. Application requires the supported mode information
    of connected displays and plane ids. One can get these information by
    running the *modetest* application in the filesystem.

    .. code-block:: console

          #  modetest

    **Running drmclone application**

    This displays same test pattern on both LCD and HDMI (clone). Overlay
    window also displayed on LCD. To test clone mode, execute the following
    command:

    .. code-block:: console

          # drmclone -l <lcd_w>x<lcd_h> -p <plane_w>x<plane_h>:<x>+<y> -h <hdmi_w>x<hdmi_h>

    For example:

    .. code-block:: console

          # drmclone -l 1280x800 -p 320x240:0+0 -h 640x480

    We can change position of overlay window by changing x+y values. eg.
    240+120 will show @ center

    **Running drmextended application**

    This displays different test pattern on LCD and HDMI. Overlay window
    also displayed on LCD. To test extended mode, execute the following
    command:

    .. code-block:: console

          # drmextended -l <lcd_w>x<lcd_h> -p <plane_w>x<plane_h>:<x>+<y> -h <hdmi_w>x<hdmi_h>

    For example:

    .. code-block:: console

          # drmextended -l 1280x800 -p 320x240:0+0 -h 640x480

    **Running drmzalpha application**

    **Z-order**:

    It determines, which overlay window appears on top of the other.

    |   Range: 0 to 3
    |         lowest value for bottom
    |         highest value for top
    |

    **Alpha Blend**:

    It determines transparency level of image as a result of both global
    alpha & pre multiplied alpha value.

    |   Global alpha range: 0 to 255
    |       0 - fully transparent
    |       127 - semi transparent
    |       255 - fully opaque
    |

    Pre multipled alpha value: 0 or 1
        |  0 - source is not premultiply with alpha
        |  1 - source is premultiply with alpha


    To test drmzalpha, execute the following command:

    .. code-block:: console

          # drmzalpha -s <crtc_w>x<crtc_h> -w <plane1_id>:<z_val>:<glo_alpha>:<pre_mul_alpha> -w <plane2_id>:<z_val>:<glo_alpha>:<pre_mul_alpha>

    For example:

    .. code-block:: console

          # drmzalpha -s 1280x800 -w 19:1:255:1 -w 20:2:255:1

Wayland/Weston
==============

The supported Wayland/Weston version brings in the multiple display support in
extended desktop mode and the ability to drag-and-drop windows from one display
to the other.

.. ifconfig:: CONFIG_part_variant in ('AM62PX', 'J722S')

   The |__PART_FAMILY_NAME__| group of devices actually utilizes two separate
   DSS modules enumerated under two different ``/dev/dri/card*`` devices.

   Unfortunately utilizing multiple card devices is not supported by Weston
   versions lower than ``11.0.91``. Starting multiple Weston instances can get
   around this behavior with the caveat that you will need to switch the
   ``WAYLAND_DISPLAY`` environment variable to point at the instance you want to
   interact with.

   To start multiple instances of Weston, you will need to manually specify the
   ``drm-device`` and the ``seat`` like the below command:

   .. code-block:: console

      # weston --seat=seat1 --drm-device=card2

   The first instance of Weston will always use ``seat0`` by default. Peripheral
   devices will be automatically registered under ``seat0`` unless told
   otherwise. For more info about multi-seat configuration see:

   https://www.freedesktop.org/wiki/Software/systemd/multiseat/

Starting Weston with Systemd
----------------------------

Starting with Weston 10, the preferred way to start Weston is with the
``weston`` user using the systemd service. If you need to interact with this
instance using any other user then make sure that user is in the ``wayland`` or
``root`` group and direct them to interact with that instance using the global
socket at ``/run/wayland-0``.

This global socket is special in that it will automatically launch Weston when
a GUI application attempts to connect to it. A profile script in
``/etc/profile.d`` will automatically set the ``WAYLAND_DISPLAY`` environment
variable if the user has sufficient permission to interact with the socket.

To start the systemd service manually, do the following:

.. code-block:: console

      # systemctl start weston

To inspect the systemd service and socket status, do the following:

.. code-block:: console

      # systemctl status weston.service weston.socket


Starting Weston Manually
------------------------

To launch Weston manually, do the following:

On the target console:

.. code-block:: console

      # unset WAYLAND_DISPLAY

On the default display:

.. code-block:: console

      # weston --tty=1 --display=<default connector-id>

On the secondary display:

.. code-block:: console

      # weston --tty=1 --display=<secondary connector-id>

On all connected displays (LCD and HDMI):

.. code-block:: console

      # weston --tty=1

By default, the screensaver timeout is configured to 300 seconds. The user can
change the screensaver timeout using a command line option:

::

     --idle-time=<number of seconds>

For example, to set timeout of 10 minutes and Weston configured to
display on all connectors, use the below command:

.. code-block:: console

     weston --tty=1 --idle-time=600

To disable the screen timeout and to configure Weston to display on all
connectors, use the below command:

.. code-block:: console

     weston --tty=1 --idle-time=0

If you face any issues with the above procedure, please refer to `the upstream
weston documentation`_ for troubleshooting tips.

.. _the upstream weston documentation:
   https://wayland.pages.freedesktop.org/weston/toc/running-weston.html

The filesystem comes with a preconfigured **weston.ini** file which will
be located in

**/etc/xdg/weston/weston.ini**

Running Weston clients
----------------------

| Weston client examples can run from the command line on a serial port
  console or an SSH console. After launching Weston, the user should be
  able to use the keyboard and the mouse for various controls.

.. code-block:: console

           # /usr/bin/weston-flower
           # /usr/bin/weston-clickdot
           # /usr/bin/weston-cliptest
           # /usr/bin/weston-dnd
           # /usr/bin/weston-editor
           # /usr/bin/weston-eventdemo
           # /usr/bin/weston-image /usr/share/weston/terminal.png
           # /usr/bin/weston-resizor
           # /usr/bin/weston-simple-egl
           # /usr/bin/weston-simple-shm
           # /usr/bin/weston-simple-touch
           # /usr/bin/weston-smoke
           # /usr/bin/weston-info
           # /usr/bin/weston-terminal

Running multimedia with Wayland sink
------------------------------------

The GStreamer video sink for Wayland is the waylandsink. To use this
video-sink for video playback:

.. code-block:: console

      # gst-launch-1.0 playbin uri=file://<path-to-file-name> video-sink=waylandsink

Exiting Weston
--------------

Terminate all Weston clients before exiting Weston. If you have invoked
Weston from the serial console, exit Weston by pressing Ctrl-C.

If Weston was started automatically by the init system then it can be stopped
with:

.. code-block:: console

     # systemctl stop weston

It is also possible to invoke Weston from the native console, exit
Weston by pressing Ctrl-Alt-Backspace.

Using IVI shell feature
-----------------------

The SDK also has support for configuring Weston ivi-shell. The default shell
that is configured in the SDK is the desktop-shell.

To change the shell to ivi-shell, the user will have to add the following lines
into the /etc/xdg/weston/weston.ini.

To switch back to the desktop-shell can be done by commenting these lines in the
/etc/xdg/weston/weston.ini (comments begin with a '#' at the start of line).

::

    [core]
    shell=ivi-shell.so

After the above configuration is completed, we can restart Weston by
running the following command

.. code-block:: console

    # systemctl restart weston

.. note:: When Weston starts with ivi-shell, the default background is
          black, this is different from the desktop-shell that brings up a window
          with background.

With ivi-shell configured for Weston, Wayland client applications use
ivi-application protocol to be managed by a central HMI window management.

Applications must support the ivi_application Wayland protocol to be managed by
the HMI central controller with an unique numeric ID.

Some important references to Weston IVI-shell can be found at the following
link:

-   https://wayland.pages.freedesktop.org/weston/toc/ivi-shell.html

Running QT applications with IVI shell
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To run the QT application with ivi-shell, set the
``QT_WAYLAND_SHELL_INTEGRATION`` environment variable to ivi-shell.

.. code-block:: console

    # export QT_WAYLAND_SHELL_INTEGRATION=ivi-shell

Using the PowerVR Tools
=======================

The suite of PowerVR Tools is designed to enable rapid graphics application
development. It targets a range of areas including asset exporting and
optimization, PC emulation, prototyping environments, on-line and off-line
performance analysis tools and many more. Please refer to PowerVR-SDK_ for
additional details on the tools and detailed documentation.

There are a number of useful tools available in the Imagination PowerVR SDK that
are compatible with our devices. Two of the most useful tools available are
PVRTune and PVRCarbon, which can be used for to profiling and tracing GFX
activities.

Previously these were included in the target's rootfs, but these were removed
due to tight version dependencies between the target and host tools. Imagination
has moved to packaging the target binaries with their host installer, so we
recommend using those binaries directly for guaranteed compatibility.

PVRTune
-------

The PVRTune utility is a real-time GPU performance analysis tool. It captures
hardware timing data and counters which facilitate the identification of
performance bottlenecks. PVRPerfServer should be used along with the PVRTune
running on the PC to gather data on the SGX loading and activity threads. The
target binaries can be found in the host's PVRTune installation directory under
PVRPerfServer.

For more information please refer to Imagination's upstream documentation on
PVRTune and PVRPerfServer.

https://docs.imgtec.com/tools-manuals/pvrtune-manual/html/pvrtune-manual/topics/introduction.html

PVRCarbon
---------

The PVRCarbon is an OpenGL\ |reg| ES and Vulkan |reg| API recording and analysis
utility. PVRCarbon GUI provides off-line tools to inspect captured data,
identify redundant calls, highlight costly shaders and many more. This tool can
capture traces on target and then play them back on multiple different devices
by introducing shim libraries in place of the standard offering for that API.

This requires a little bit of setup on the target though. Please refer to
Imagination's upstream target setup guide for the most recent instructions.

https://docs.imgtec.com/tools-manuals/pvrcarbon-manual/html/topics/pvrcarbon-recorder/opengl-es.html

.. |reg|    unicode:: U+000AE .. REGISTERED SIGN
.. _PowerVR-SDK: https://www.imgtec.com/developers/powervr-sdk-tools/installers/

.. [#f1] CRTC stands for cathode-ray tube controller, a throw back to the old
         `cathode-ray tubes TV's <https://en.wikipedia.org/wiki/Cathode-ray_tube>`_
         which had a controller that generated video timings based on the data
         it is being fed by a buffer.
