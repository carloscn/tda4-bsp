old-cmd-./test_performance_ta.o := /opt/cross-compile/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gcc -std=gnu11 -fdiagnostics-show-option -Wall -Wcast-align -Werror-implicit-function-declaration -Wextra -Wfloat-equal -Wformat-nonliteral -Wformat-security -Wformat=2 -Winit-self -Wmissing-declarations -Wmissing-format-attribute -Wmissing-include-dirs -Wmissing-noreturn -Wmissing-prototypes -Wnested-externs -Wpointer-arith -Wshadow -Wstrict-prototypes -Wswitch-default -Wwrite-strings -Wno-missing-field-initializers -Wno-format-zero-length -Wno-c2x-extensions -Wpacked-not-aligned -Waddress-of-packed-member -Wredundant-decls -Wold-style-definition -Wstrict-aliasing=2 -Wundef -Os -g3 -fpic -mstrict-align -mno-outline-atomics -fstack-protector-strong -MD -MF ./.test_performance_ta.o.d -MT test_performance_ta.o -nostdinc -isystem /opt/cross-compile/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu/bin/../lib/gcc/aarch64-none-linux-gnu/11.3.1/include -I./include -I./. -DARM64=1 -D__LP64__=1 -DMBEDTLS_SELF_TEST -D__OPTEE_CORE_API_COMPAT_1_1=1 -DTRACE_LEVEL=4 -I. -I/home/build/bsp/optee_os/out/arm-plat-k3/export-ta_arm64/include -DCFG_TA_MBEDTLS_SELF_TEST=1 -DCFG_TA_MBEDTLS=1 -DCFG_UNWIND=1 -DCFG_TA_MBEDTLS_MPI=1 -DCFG_TA_OPTEE_CORE_API_COMPAT_1_1=1 -DCFG_ARM64_ta_arm64=1 -DCFG_TEE_TA_LOG_LEVEL='4' -DCFG_SYSTEM_PTA=1 -DCFG_TA_FLOAT_SUPPORT=1 -D__FILE_ID__=test_performance_ta_c -c test_performance_ta.c -o test_performance_ta.o
