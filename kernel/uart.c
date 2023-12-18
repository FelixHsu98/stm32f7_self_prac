#include "type.h"
#include "memlayout.h"
#include "gpio.h"
#include "uart.h"

void
uartinit(struct uart *up, uint32 baud)
{
  char port;
  int tx, rx, af;

  switch((uint32)up)
  {
    default:
    case USART1:
      *(RCC_APB2ENR) |= (1U << 4);
      port = 'A', tx = 9, rx = 10, af = 7;
      break;
    case USART2:
      *(RCC_APB1ENR) |= (1U << 17);
      port = 'A', tx = 2, rx = 3, af = 7;
      break;
    case USART3:
      *(RCC_APB1ENR) |= (1U << 18);
      port = 'B', tx = 10, rx = 11, af = 7;
      break;
    case UART4:
      *(RCC_APB1ENR) |= (1U << 19);
      port = 'A', tx = 0, rx = 1, af = 8;
      break;
    case UART5:
      *(RCC_APB1ENR) |= (1U << 20);
      port = 'C', tx = 12, rx = 2, af = 8;
      break;
    case USART6:
      *(RCC_APB2ENR) |= (1U << 5);
      port = 'G', tx = 14, rx = 9, af = 8;
      break;
    case UART7:
      *(RCC_APB1ENR) |= (1U << 30);
      port = 'E', tx = 8, rx = 7, af = 8;
      break;
    case UART8:
      *(RCC_APB1ENR) |= (1U << 31);
      port = 'E', tx = 1, rx = 0, af = 8;
      break;
  }

  gpio_set_mode(port, tx, GPIO_MODE_AF);
  gpio_set_af(port, tx, af);

  if((uint32)up == UART5) port = 'D';

  gpio_set_mode(port, rx, GPIO_MODE_AF);
  gpio_set_af(port, rx, af);

  up->CR1 &= ~(0xD); //clear
  up->BRR = (FREQ / baud);
  up->CR1 |= (0xD); // enable TE RE UE (1101 == 0xD)
}

static void
uartputc(struct uart *up, uint8 c)
{
  up->TDR = c;
  while( !(up->ISR & (1U << 7)) ); // spin when TXE == 0
}

void
uartwrite(struct uart *up, char *buf, uint32 len)
{
  char *c = buf;
  uint32 i = 0;

  while(i++ < len){
    uartputc(up, *c);
    c++;
  }
}

static int
uartgetc(struct uart *up)
{
  if( !(up->ISR & (1U << 5)) )
    return up->RDR;
  else
    return -1;
}

void
uartread(struct uart *up, char *buf, uint32 len)
{
  int c;
  uint32 i = 0;

  while(i < len && (c = uartgetc(up)) != -1){
    *(buf + i) = c;
    i++;
  }
}
