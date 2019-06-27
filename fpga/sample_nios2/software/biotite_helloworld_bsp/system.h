/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2_e' in SOPC Builder design 'nios2core'
 * SOPC Builder design path: ../../nios2core.sopcinfo
 *
 * Generated: Fri Jun 28 00:54:54 JST 2019
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x0fff0820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1d
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x0f800020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x1c
#define ALT_CPU_NAME "nios2_e"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x0f000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x0fff0820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x1d
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x0f800020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x1c
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x0f000000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2_GEN2
#define __ALTERA_ONCHIP_FLASH
#define __PERIDOT_QSPI_PSRAM


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "MAX 10"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x10000040
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x10000040
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x10000040
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "nios2core"


/*
 * boot_flash_csr configuration
 *
 */

#define ALT_MODULE_CLASS_boot_flash_csr altera_onchip_flash
#define BOOT_FLASH_CSR_BASE 0x1000f000
#define BOOT_FLASH_CSR_BYTES_PER_PAGE 2048
#define BOOT_FLASH_CSR_IRQ -1
#define BOOT_FLASH_CSR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BOOT_FLASH_CSR_NAME "/dev/boot_flash_csr"
#define BOOT_FLASH_CSR_READ_ONLY_MODE 0
#define BOOT_FLASH_CSR_SECTOR1_ENABLED 1
#define BOOT_FLASH_CSR_SECTOR1_END_ADDR 0x3fff
#define BOOT_FLASH_CSR_SECTOR1_START_ADDR 0
#define BOOT_FLASH_CSR_SECTOR2_ENABLED 1
#define BOOT_FLASH_CSR_SECTOR2_END_ADDR 0x7fff
#define BOOT_FLASH_CSR_SECTOR2_START_ADDR 0x4000
#define BOOT_FLASH_CSR_SECTOR3_ENABLED 1
#define BOOT_FLASH_CSR_SECTOR3_END_ADDR 0x167ff
#define BOOT_FLASH_CSR_SECTOR3_START_ADDR 0x8000
#define BOOT_FLASH_CSR_SECTOR4_ENABLED 0
#define BOOT_FLASH_CSR_SECTOR4_END_ADDR 0xffffffff
#define BOOT_FLASH_CSR_SECTOR4_START_ADDR 0xffffffff
#define BOOT_FLASH_CSR_SECTOR5_ENABLED 0
#define BOOT_FLASH_CSR_SECTOR5_END_ADDR 0xffffffff
#define BOOT_FLASH_CSR_SECTOR5_START_ADDR 0xffffffff
#define BOOT_FLASH_CSR_SPAN 8
#define BOOT_FLASH_CSR_TYPE "altera_onchip_flash"


/*
 * boot_flash_data configuration
 *
 */

#define ALT_MODULE_CLASS_boot_flash_data altera_onchip_flash
#define BOOT_FLASH_DATA_BASE 0xf000000
#define BOOT_FLASH_DATA_BYTES_PER_PAGE 2048
#define BOOT_FLASH_DATA_IRQ -1
#define BOOT_FLASH_DATA_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BOOT_FLASH_DATA_NAME "/dev/boot_flash_data"
#define BOOT_FLASH_DATA_READ_ONLY_MODE 0
#define BOOT_FLASH_DATA_SECTOR1_ENABLED 1
#define BOOT_FLASH_DATA_SECTOR1_END_ADDR 0x3fff
#define BOOT_FLASH_DATA_SECTOR1_START_ADDR 0
#define BOOT_FLASH_DATA_SECTOR2_ENABLED 1
#define BOOT_FLASH_DATA_SECTOR2_END_ADDR 0x7fff
#define BOOT_FLASH_DATA_SECTOR2_START_ADDR 0x4000
#define BOOT_FLASH_DATA_SECTOR3_ENABLED 1
#define BOOT_FLASH_DATA_SECTOR3_END_ADDR 0x167ff
#define BOOT_FLASH_DATA_SECTOR3_START_ADDR 0x8000
#define BOOT_FLASH_DATA_SECTOR4_ENABLED 0
#define BOOT_FLASH_DATA_SECTOR4_END_ADDR 0xffffffff
#define BOOT_FLASH_DATA_SECTOR4_START_ADDR 0xffffffff
#define BOOT_FLASH_DATA_SECTOR5_ENABLED 0
#define BOOT_FLASH_DATA_SECTOR5_END_ADDR 0xffffffff
#define BOOT_FLASH_DATA_SECTOR5_START_ADDR 0xffffffff
#define BOOT_FLASH_DATA_SPAN 92160
#define BOOT_FLASH_DATA_TYPE "altera_onchip_flash"


/*
 * gpio_0 configuration
 *
 */

#define ALT_MODULE_CLASS_gpio_0 altera_avalon_pio
#define GPIO_0_BASE 0x100000a0
#define GPIO_0_BIT_CLEARING_EDGE_REGISTER 0
#define GPIO_0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define GPIO_0_CAPTURE 0
#define GPIO_0_DATA_WIDTH 12
#define GPIO_0_DO_TEST_BENCH_WIRING 0
#define GPIO_0_DRIVEN_SIM_VALUE 0
#define GPIO_0_EDGE_TYPE "NONE"
#define GPIO_0_FREQ 50000000
#define GPIO_0_HAS_IN 0
#define GPIO_0_HAS_OUT 0
#define GPIO_0_HAS_TRI 1
#define GPIO_0_IRQ -1
#define GPIO_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define GPIO_0_IRQ_TYPE "NONE"
#define GPIO_0_NAME "/dev/gpio_0"
#define GPIO_0_RESET_VALUE 0
#define GPIO_0_SPAN 16
#define GPIO_0_TYPE "altera_avalon_pio"


/*
 * gpio_1 configuration
 *
 */

#define ALT_MODULE_CLASS_gpio_1 altera_avalon_pio
#define GPIO_1_BASE 0x100000b0
#define GPIO_1_BIT_CLEARING_EDGE_REGISTER 0
#define GPIO_1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define GPIO_1_CAPTURE 0
#define GPIO_1_DATA_WIDTH 12
#define GPIO_1_DO_TEST_BENCH_WIRING 0
#define GPIO_1_DRIVEN_SIM_VALUE 0
#define GPIO_1_EDGE_TYPE "NONE"
#define GPIO_1_FREQ 50000000
#define GPIO_1_HAS_IN 0
#define GPIO_1_HAS_OUT 0
#define GPIO_1_HAS_TRI 1
#define GPIO_1_IRQ -1
#define GPIO_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define GPIO_1_IRQ_TYPE "NONE"
#define GPIO_1_NAME "/dev/gpio_1"
#define GPIO_1_RESET_VALUE 0
#define GPIO_1_SPAN 16
#define GPIO_1_TYPE "altera_avalon_pio"


/*
 * gpio_2 configuration
 *
 */

#define ALT_MODULE_CLASS_gpio_2 altera_avalon_pio
#define GPIO_2_BASE 0x100000c0
#define GPIO_2_BIT_CLEARING_EDGE_REGISTER 0
#define GPIO_2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define GPIO_2_CAPTURE 0
#define GPIO_2_DATA_WIDTH 12
#define GPIO_2_DO_TEST_BENCH_WIRING 0
#define GPIO_2_DRIVEN_SIM_VALUE 0
#define GPIO_2_EDGE_TYPE "NONE"
#define GPIO_2_FREQ 50000000
#define GPIO_2_HAS_IN 0
#define GPIO_2_HAS_OUT 0
#define GPIO_2_HAS_TRI 1
#define GPIO_2_IRQ -1
#define GPIO_2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define GPIO_2_IRQ_TYPE "NONE"
#define GPIO_2_NAME "/dev/gpio_2"
#define GPIO_2_RESET_VALUE 0
#define GPIO_2_SPAN 16
#define GPIO_2_TYPE "altera_avalon_pio"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 4
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x10000040
#define JTAG_UART_IRQ 1
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * led7seg configuration
 *
 */

#define ALT_MODULE_CLASS_led7seg altera_avalon_pio
#define LED7SEG_BASE 0x10000080
#define LED7SEG_BIT_CLEARING_EDGE_REGISTER 0
#define LED7SEG_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED7SEG_CAPTURE 0
#define LED7SEG_DATA_WIDTH 24
#define LED7SEG_DO_TEST_BENCH_WIRING 0
#define LED7SEG_DRIVEN_SIM_VALUE 0
#define LED7SEG_EDGE_TYPE "NONE"
#define LED7SEG_FREQ 50000000
#define LED7SEG_HAS_IN 0
#define LED7SEG_HAS_OUT 1
#define LED7SEG_HAS_TRI 0
#define LED7SEG_IRQ -1
#define LED7SEG_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED7SEG_IRQ_TYPE "NONE"
#define LED7SEG_NAME "/dev/led7seg"
#define LED7SEG_RESET_VALUE 16777215
#define LED7SEG_SPAN 16
#define LED7SEG_TYPE "altera_avalon_pio"


/*
 * onchip_memory2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_0 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_BASE 0xf800000
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE "nios2core_onchip_memory2_0"
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 0
#define ONCHIP_MEMORY2_0_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_0_IRQ -1
#define ONCHIP_MEMORY2_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_0_NAME "/dev/onchip_memory2_0"
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 16384
#define ONCHIP_MEMORY2_0_SPAN 16384
#define ONCHIP_MEMORY2_0_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_0_WRITABLE 1


/*
 * peridot_qspi_psram_0 configuration
 *
 */

#define ALT_MODULE_CLASS_peridot_qspi_psram_0 peridot_qspi_psram
#define PERIDOT_QSPI_PSRAM_0_BASE 0x0
#define PERIDOT_QSPI_PSRAM_0_IRQ -1
#define PERIDOT_QSPI_PSRAM_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PERIDOT_QSPI_PSRAM_0_NAME "/dev/peridot_qspi_psram_0"
#define PERIDOT_QSPI_PSRAM_0_SPAN 8388608
#define PERIDOT_QSPI_PSRAM_0_TYPE "peridot_qspi_psram"


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0x10000000
#define SYSID_ID 1923678208
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1561650672
#define SYSID_TYPE "altera_avalon_sysid_qsys"


/*
 * syskey configuration
 *
 */

#define ALT_MODULE_CLASS_syskey altera_avalon_pio
#define SYSKEY_BASE 0x10000060
#define SYSKEY_BIT_CLEARING_EDGE_REGISTER 0
#define SYSKEY_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SYSKEY_CAPTURE 0
#define SYSKEY_DATA_WIDTH 3
#define SYSKEY_DO_TEST_BENCH_WIRING 0
#define SYSKEY_DRIVEN_SIM_VALUE 0
#define SYSKEY_EDGE_TYPE "NONE"
#define SYSKEY_FREQ 50000000
#define SYSKEY_HAS_IN 1
#define SYSKEY_HAS_OUT 1
#define SYSKEY_HAS_TRI 0
#define SYSKEY_IRQ -1
#define SYSKEY_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSKEY_IRQ_TYPE "NONE"
#define SYSKEY_NAME "/dev/syskey"
#define SYSKEY_RESET_VALUE 0
#define SYSKEY_SPAN 16
#define SYSKEY_TYPE "altera_avalon_pio"


/*
 * systimer configuration
 *
 */

#define ALT_MODULE_CLASS_systimer altera_avalon_timer
#define SYSTIMER_ALWAYS_RUN 0
#define SYSTIMER_BASE 0x10000020
#define SYSTIMER_COUNTER_SIZE 32
#define SYSTIMER_FIXED_PERIOD 0
#define SYSTIMER_FREQ 50000000
#define SYSTIMER_IRQ 0
#define SYSTIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYSTIMER_LOAD_VALUE 49999
#define SYSTIMER_MULT 0.001
#define SYSTIMER_NAME "/dev/systimer"
#define SYSTIMER_PERIOD 1
#define SYSTIMER_PERIOD_UNITS "ms"
#define SYSTIMER_RESET_OUTPUT 0
#define SYSTIMER_SNAPSHOT 1
#define SYSTIMER_SPAN 32
#define SYSTIMER_TICKS_PER_SEC 1000
#define SYSTIMER_TIMEOUT_PULSE_OUTPUT 0
#define SYSTIMER_TYPE "altera_avalon_timer"

#endif /* __SYSTEM_H_ */
