#include "type.h"
#include "memlayout.h"
#include "gpio.h"
#include "defs.h"

extern uint32 _sticks;

static uint32
stexpired(uint32 period)
{
  static uint32 t = 0;
  if(t == 0) t = period + _sticks;
  if(_sticks < t) return 0;
  t = (_sticks - t) > period ? (_sticks + period) : (period + t);
  return 1;
}


void userproc1()
{
  //gpio_set_mode('B', 7, GPIO_MODE_OUTPUT); // PB7 is blue LED
  gpio_set_mode('B', 14, GPIO_MODE_OUTPUT); // PB14 is red LED

  int on = 1;
  for(;;){
    if(stexpired(1000)){
      gpio_write('B', 14, on);
      on = !on;
      syscall();
    }
  }
}

int main()
{
  uint32 userstack[256];
  uint32 *usstart = userstack + 256 - 16;
  usstart[8] = (uint32)userproc1;

  swtch((uint32)usstart);

  gpio_set_mode('B', 7, GPIO_MODE_OUTPUT); // PB7 is blue LED
  gpio_write('B', 7, 1);
  while(1);

//  uartwrite((struct uart *)USART1, "hello world\n", 13);
  return 0;
}

