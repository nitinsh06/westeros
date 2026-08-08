#include <stdint.h>
#include "uart.h"

#define UART0_FIFO    0x3FF40000
#define UART0_STATUS  0x3FF4001C

void uart_putc(char c)
{
    volatile uint32_t *status = (volatile uint32_t *)UART0_STATUS;
    volatile uint32_t *fifo   = (volatile uint32_t *)UART0_FIFO;

    /* spin while the TX FIFO holds too many bytes */
    while (((*status >> 16) & 0xFF) >= 100) {
        /* busy-wait */
    }

    *fifo = (uint32_t)c;
}

void uart_puts(const char *s)
{
    while (*s) {
        uart_putc(*s++);
    }
}

