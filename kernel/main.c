#include "type.h"
#include "memlayout.h"
#include "gpio.h"
#include "defs.h"
#include "arm.h"
#include "proc.h"

extern uint32 _sticks;

static int
wait(uint32 period)
{
  uint32 t = 0;
  if(t == 0) t = period + _sticks;
  while(_sticks < t);
  
  return 1;
}

//static uint32
//stexpired(uint32 period)
//{
//  static uint32 t = 0;
//  if(t == 0) t = period + _sticks;
//  if(_sticks < t) return 0;
//  t = (_sticks - t) > period ? (_sticks + period) : (period + t);
//  return 1;
//}

void
task_init(void)
{
	uint32 empty[32];
	task_init_env(empty+32);
}

void userproc1()
{
  gpio_set_mode('B', 14, GPIO_MODE_OUTPUT); // PB14 is red LED

  uartwrite((struct uart *)USART3, "Now switching to process 1\r\n");
  int on = 1;
  for(;;){
    if(wait(1000)){
      gpio_write('B', 14, on);
      on = !on;
      uartwrite((struct uart *)USART3, "process 1 continually running\r\n");
      yield();
    }
  }
}

void userproc2()
{
  gpio_set_mode('B', 7, GPIO_MODE_OUTPUT); // PB7 is blue LED
  uartwrite((struct uart *)USART3, "Now switching to process 2\r\n");

  int on = 1;
  for(;;){
    if(wait(1000)){
      gpio_write('B', 7, on);
      on = !on;
      uartwrite((struct uart *)USART3, "process 2 continually running\r\n");
      yield();
    }
  }
}

int main()
{
  int idx = 0;
  //uint32 *usersp[MAX_PROC_NUM];
  uint32 userstack[MAX_PROC_NUM][USTACK_SIZE];

  // say hello to console
  uartwrite((struct uart *)USART3, "os starting...\r\n");

  task_init();
  uartwrite((struct uart *)USART3, "successfully load into kernel\r\n");

  if(allocproc(userstack[idx], userproc1) == 0)
    uartwrite((struct uart *)USART3, "proc1 alloc failed\r\n");
  idx++;

  if(allocproc(userstack[idx], userproc2) == 0)
    uartwrite((struct uart *)USART3, "proc2 alloc failed\r\n");

  while(1){
    sched();
    uartwrite((struct uart *)USART3, "switch back to kernel to prepare scheduling\r\n");
  }

  return 0;
}

