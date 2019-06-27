/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include "sys/alt_stdio.h"
#include <unistd.h>

#include "system.h"
#include <io.h>

#define SEG_a	0x01
#define SEG_b	0x02
#define SEG_c	0x04
#define SEG_d	0x08
#define SEG_e	0x10
#define SEG_f	0x20
#define SEG_g	0x40

void set_led7seg(int value)
{
	const char ledseg[10] = {
		SEG_a | SEG_b | SEG_c | SEG_d | SEG_e | SEG_f ,			// 0
		SEG_b | SEG_c ,											// 1
		SEG_a | SEG_b | SEG_d | SEG_e | SEG_g ,					// 2
		SEG_a | SEG_b | SEG_c | SEG_d | SEG_g ,					// 3
		SEG_b | SEG_c | SEG_f | SEG_g,							// 4
		SEG_a | SEG_c | SEG_d | SEG_f | SEG_g ,					// 5
		SEG_a | SEG_c | SEG_d | SEG_e | SEG_f | SEG_g ,			// 6
		SEG_a | SEG_b | SEG_c | SEG_f ,							// 7
		SEG_a | SEG_b | SEG_c | SEG_d | SEG_e | SEG_f | SEG_g ,	// 8
		SEG_a | SEG_b | SEG_c | SEG_d | SEG_f | SEG_g			// 9
	};

	int d = 0;

	for(int i=3 ; i ; i--) {
		d = (d << 8) | ledseg[value % 10];
		value /= 10;
	}

	IOWR(LED7SEG_BASE, 0, ~d);
}



int main()
{ 
	alt_putstr("Hello BIOTITE from Nios II!\n");

	int count = 0;

	while(1) {
		set_led7seg(count);
		count++;
		usleep(100000);
	}


	return 0;
}
