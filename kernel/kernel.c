#include "uart.h"
#include <stdint.h>

#define WDT_WKEY  0x50D83AA1
static void reg_write(uint32_t addr, uint32_t val)
{
    *(volatile uint32_t *)addr = val;
}

void kernel_main(void)
{
    /* RTC watchdog */
    reg_write(0x3FF480A4, 0x50D83AA1);   /* unlock */
    reg_write(0x3FF4808C, 0);            /* disable */

    /* Timer Group 0 watchdog */
    reg_write(0x3FF5F064, WDT_WKEY);     /* unlock */
    reg_write(0x3FF5F048, 0);            /* disable */

    /* Timer Group 1 watchdog */
    reg_write(0x3FF60064, WDT_WKEY);     /* unlock */
    reg_write(0x3FF60048, 0);            /* disable */

    uart_puts("== Boot Success ==\r\n");
    uart_puts("WesterOS alive!!!\r\n");
    uart_puts("=====================\r\n");
    while (1) { }
}