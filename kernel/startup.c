#include "type.h"
#include "memlayout.h"
#include "defs.h"
#include "uart.h"

extern int _sdata, _edata, _sbss, _ebss, _sidata;

extern void _estack(); // Defined in link.ld

volatile uint32  _sticks = 0;

extern int main(void);

void
timerinit(void)
{
  *(SYS_CSR) |= (0x00000007); // enable CLKSOURCE, TICKINT, ENABLE
  // default systick is generated by HSI RC oscillator with 16MHz
  // at here, set RVR to 1ms. That means _systick_handler will
  // be triggered every 1ms
  *(SYS_RVR) = (16000000 / 1000) - 1;
  *(SYS_CVR) = 0;
  *(RCC_APB2ENR) |= (1U << 14); // enable SYSCFGEN
}

// Startup code
__attribute__((naked, noreturn)) void _reset(void)
{
  for(int *dst = &_sbss; dst < &_ebss; dst++) *dst = 0;

  for(int *dst = &_sdata, *src = &_sidata; dst < &_edata; dst++, src++)
    *dst = *src;
  
  timerinit();
  uartinit((struct uart *)USART1, 115200);
  main();
  for(;;);
}

void _systick_handler(void)
{
  _sticks++;
}

extern void svc_handler(void);

// 16 standard and 104 STM32-specific handlers
__attribute__((section(".vectors"))) void (*const tab[16+104])(void)={
  _estack,		// 0
  _reset,		// 1
   0, 0, 0, 0, 0, 0, 0, 0, 0,
   svc_handler,
   0, 0, 0, 
  _systick_handler	// 15
};