
firmware.elf:     file format elf32-littlearm


Disassembly of section .text:

080001e0 <timerinit>:

extern int main(void);

void
timerinit(void)
{
 80001e0:	b480      	push	{r7}
 80001e2:	af00      	add	r7, sp, #0
  *(SYS_CSR) |= (0x00000007); // enable CLKSOURCE, TICKINT, ENABLE
 80001e4:	4b0b      	ldr	r3, [pc, #44]	; (8000214 <timerinit+0x34>)
 80001e6:	681b      	ldr	r3, [r3, #0]
 80001e8:	4a0a      	ldr	r2, [pc, #40]	; (8000214 <timerinit+0x34>)
 80001ea:	f043 0307 	orr.w	r3, r3, #7
 80001ee:	6013      	str	r3, [r2, #0]
  // default systick is generated by HSI RC oscillator with 16MHz
  // at here, set RVR to 1ms. That means _systick_handler will
  // be triggered every 1ms
  *(SYS_RVR) = (16000000 / 1000) - 1;
 80001f0:	4b09      	ldr	r3, [pc, #36]	; (8000218 <timerinit+0x38>)
 80001f2:	f643 627f 	movw	r2, #15999	; 0x3e7f
 80001f6:	601a      	str	r2, [r3, #0]
  *(SYS_CVR) = 0;
 80001f8:	4b08      	ldr	r3, [pc, #32]	; (800021c <timerinit+0x3c>)
 80001fa:	2200      	movs	r2, #0
 80001fc:	601a      	str	r2, [r3, #0]
  *(RCC_APB2ENR) |= (1U << 14); // enable SYSCFGEN
 80001fe:	4b08      	ldr	r3, [pc, #32]	; (8000220 <timerinit+0x40>)
 8000200:	681b      	ldr	r3, [r3, #0]
 8000202:	4a07      	ldr	r2, [pc, #28]	; (8000220 <timerinit+0x40>)
 8000204:	f443 4380 	orr.w	r3, r3, #16384	; 0x4000
 8000208:	6013      	str	r3, [r2, #0]
}
 800020a:	bf00      	nop
 800020c:	46bd      	mov	sp, r7
 800020e:	f85d 7b04 	ldr.w	r7, [sp], #4
 8000212:	4770      	bx	lr
 8000214:	e000e010 	.word	0xe000e010
 8000218:	e000e014 	.word	0xe000e014
 800021c:	e000e018 	.word	0xe000e018
 8000220:	40023844 	.word	0x40023844

08000224 <_reset>:

// Startup code
__attribute__((naked, noreturn)) void _reset(void)
{
  for(int *dst = &_sbss; dst < &_ebss; dst++) *dst = 0;
 8000224:	4c0d      	ldr	r4, [pc, #52]	; (800025c <_reset+0x38>)
 8000226:	e002      	b.n	800022e <_reset+0xa>
 8000228:	2300      	movs	r3, #0
 800022a:	6023      	str	r3, [r4, #0]
 800022c:	3404      	adds	r4, #4
 800022e:	4b0c      	ldr	r3, [pc, #48]	; (8000260 <_reset+0x3c>)
 8000230:	429c      	cmp	r4, r3
 8000232:	d3f9      	bcc.n	8000228 <_reset+0x4>

  for(int *dst = &_sdata, *src = &_sidata; dst < &_edata; dst++, src++)
 8000234:	4c0b      	ldr	r4, [pc, #44]	; (8000264 <_reset+0x40>)
 8000236:	4d0c      	ldr	r5, [pc, #48]	; (8000268 <_reset+0x44>)
 8000238:	e003      	b.n	8000242 <_reset+0x1e>
    *dst = *src;
 800023a:	682b      	ldr	r3, [r5, #0]
 800023c:	6023      	str	r3, [r4, #0]
  for(int *dst = &_sdata, *src = &_sidata; dst < &_edata; dst++, src++)
 800023e:	3404      	adds	r4, #4
 8000240:	3504      	adds	r5, #4
 8000242:	4b0a      	ldr	r3, [pc, #40]	; (800026c <_reset+0x48>)
 8000244:	429c      	cmp	r4, r3
 8000246:	d3f8      	bcc.n	800023a <_reset+0x16>
  
  timerinit();
 8000248:	f7ff ffca 	bl	80001e0 <timerinit>
  uartinit((struct uart *)USART1, 115200);
 800024c:	f44f 31e1 	mov.w	r1, #115200	; 0x1c200
 8000250:	4807      	ldr	r0, [pc, #28]	; (8000270 <_reset+0x4c>)
 8000252:	f000 f975 	bl	8000540 <uartinit>
  main();
 8000256:	f000 f8cf 	bl	80003f8 <main>
  for(;;);
 800025a:	e7fe      	b.n	800025a <_reset+0x36>
 800025c:	20010000 	.word	0x20010000
 8000260:	20010008 	.word	0x20010008
 8000264:	20010000 	.word	0x20010000
 8000268:	0800082a 	.word	0x0800082a
 800026c:	20010000 	.word	0x20010000
 8000270:	40011000 	.word	0x40011000

08000274 <_systick_handler>:
}

void _systick_handler(void)
{
 8000274:	b480      	push	{r7}
 8000276:	af00      	add	r7, sp, #0
  _sticks++;
 8000278:	4b04      	ldr	r3, [pc, #16]	; (800028c <_systick_handler+0x18>)
 800027a:	681b      	ldr	r3, [r3, #0]
 800027c:	3301      	adds	r3, #1
 800027e:	4a03      	ldr	r2, [pc, #12]	; (800028c <_systick_handler+0x18>)
 8000280:	6013      	str	r3, [r2, #0]
}
 8000282:	bf00      	nop
 8000284:	46bd      	mov	sp, r7
 8000286:	f85d 7b04 	ldr.w	r7, [sp], #4
 800028a:	4770      	bx	lr
 800028c:	20010000 	.word	0x20010000

08000290 <gpio_set_mode>:
  GPIO_MODE_ANALOG
} gmode_t;

static inline void
gpio_set_mode(char port, int pin, gmode_t gpio_mode)
{
 8000290:	b480      	push	{r7}
 8000292:	b085      	sub	sp, #20
 8000294:	af00      	add	r7, sp, #0
 8000296:	4603      	mov	r3, r0
 8000298:	6039      	str	r1, [r7, #0]
 800029a:	71fb      	strb	r3, [r7, #7]
 800029c:	4613      	mov	r3, r2
 800029e:	71bb      	strb	r3, [r7, #6]
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
 80002a0:	79fb      	ldrb	r3, [r7, #7]
 80002a2:	3b41      	subs	r3, #65	; 0x41
 80002a4:	029b      	lsls	r3, r3, #10
 80002a6:	461a      	mov	r2, r3
 80002a8:	4b16      	ldr	r3, [pc, #88]	; (8000304 <gpio_set_mode+0x74>)
 80002aa:	4413      	add	r3, r2
 80002ac:	60fb      	str	r3, [r7, #12]
  pin &= 0xF;
 80002ae:	683b      	ldr	r3, [r7, #0]
 80002b0:	f003 030f 	and.w	r3, r3, #15
 80002b4:	603b      	str	r3, [r7, #0]

  *(RCC_AHB1ENR) |= (1U << (port - 'A'));
 80002b6:	4b14      	ldr	r3, [pc, #80]	; (8000308 <gpio_set_mode+0x78>)
 80002b8:	681a      	ldr	r2, [r3, #0]
 80002ba:	79fb      	ldrb	r3, [r7, #7]
 80002bc:	3b41      	subs	r3, #65	; 0x41
 80002be:	2101      	movs	r1, #1
 80002c0:	fa01 f303 	lsl.w	r3, r1, r3
 80002c4:	4910      	ldr	r1, [pc, #64]	; (8000308 <gpio_set_mode+0x78>)
 80002c6:	4313      	orrs	r3, r2
 80002c8:	600b      	str	r3, [r1, #0]
  gp->moder &= ~(0x3 << (pin * 2)); // clear previos
 80002ca:	68fb      	ldr	r3, [r7, #12]
 80002cc:	681b      	ldr	r3, [r3, #0]
 80002ce:	683a      	ldr	r2, [r7, #0]
 80002d0:	0052      	lsls	r2, r2, #1
 80002d2:	2103      	movs	r1, #3
 80002d4:	fa01 f202 	lsl.w	r2, r1, r2
 80002d8:	43d2      	mvns	r2, r2
 80002da:	401a      	ands	r2, r3
 80002dc:	68fb      	ldr	r3, [r7, #12]
 80002de:	601a      	str	r2, [r3, #0]
  gp->moder |= ((gpio_mode & 0x3) << (pin * 2)); // set mode 
 80002e0:	68fb      	ldr	r3, [r7, #12]
 80002e2:	681b      	ldr	r3, [r3, #0]
 80002e4:	79ba      	ldrb	r2, [r7, #6]
 80002e6:	f002 0103 	and.w	r1, r2, #3
 80002ea:	683a      	ldr	r2, [r7, #0]
 80002ec:	0052      	lsls	r2, r2, #1
 80002ee:	fa01 f202 	lsl.w	r2, r1, r2
 80002f2:	431a      	orrs	r2, r3
 80002f4:	68fb      	ldr	r3, [r7, #12]
 80002f6:	601a      	str	r2, [r3, #0]
}
 80002f8:	bf00      	nop
 80002fa:	3714      	adds	r7, #20
 80002fc:	46bd      	mov	sp, r7
 80002fe:	f85d 7b04 	ldr.w	r7, [sp], #4
 8000302:	4770      	bx	lr
 8000304:	40020000 	.word	0x40020000
 8000308:	40023830 	.word	0x40023830

0800030c <gpio_write>:
  gp->afr[pin >> 3] |= (af << ((pin & 0x7) * 4));   // set
}

static inline void
gpio_write(char port, int pin, int val)
{
 800030c:	b480      	push	{r7}
 800030e:	b087      	sub	sp, #28
 8000310:	af00      	add	r7, sp, #0
 8000312:	4603      	mov	r3, r0
 8000314:	60b9      	str	r1, [r7, #8]
 8000316:	607a      	str	r2, [r7, #4]
 8000318:	73fb      	strb	r3, [r7, #15]
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
 800031a:	7bfb      	ldrb	r3, [r7, #15]
 800031c:	3b41      	subs	r3, #65	; 0x41
 800031e:	029b      	lsls	r3, r3, #10
 8000320:	461a      	mov	r2, r3
 8000322:	4b0a      	ldr	r3, [pc, #40]	; (800034c <gpio_write+0x40>)
 8000324:	4413      	add	r3, r2
 8000326:	617b      	str	r3, [r7, #20]
  gp->bsrr = (1U << pin) << (val ? 0 : 16);
 8000328:	2201      	movs	r2, #1
 800032a:	68bb      	ldr	r3, [r7, #8]
 800032c:	409a      	lsls	r2, r3
 800032e:	687b      	ldr	r3, [r7, #4]
 8000330:	2b00      	cmp	r3, #0
 8000332:	d001      	beq.n	8000338 <gpio_write+0x2c>
 8000334:	2300      	movs	r3, #0
 8000336:	e000      	b.n	800033a <gpio_write+0x2e>
 8000338:	2310      	movs	r3, #16
 800033a:	409a      	lsls	r2, r3
 800033c:	697b      	ldr	r3, [r7, #20]
 800033e:	619a      	str	r2, [r3, #24]
}
 8000340:	bf00      	nop
 8000342:	371c      	adds	r7, #28
 8000344:	46bd      	mov	sp, r7
 8000346:	f85d 7b04 	ldr.w	r7, [sp], #4
 800034a:	4770      	bx	lr
 800034c:	40020000 	.word	0x40020000

08000350 <stexpired>:

extern uint32 _sticks;

static uint32
stexpired(uint32 period)
{
 8000350:	b480      	push	{r7}
 8000352:	b083      	sub	sp, #12
 8000354:	af00      	add	r7, sp, #0
 8000356:	6078      	str	r0, [r7, #4]
  static uint32 t = 0;
  if(t == 0) t = period + _sticks;
 8000358:	4b15      	ldr	r3, [pc, #84]	; (80003b0 <stexpired+0x60>)
 800035a:	681b      	ldr	r3, [r3, #0]
 800035c:	2b00      	cmp	r3, #0
 800035e:	d105      	bne.n	800036c <stexpired+0x1c>
 8000360:	4b14      	ldr	r3, [pc, #80]	; (80003b4 <stexpired+0x64>)
 8000362:	681a      	ldr	r2, [r3, #0]
 8000364:	687b      	ldr	r3, [r7, #4]
 8000366:	4413      	add	r3, r2
 8000368:	4a11      	ldr	r2, [pc, #68]	; (80003b0 <stexpired+0x60>)
 800036a:	6013      	str	r3, [r2, #0]
  if(_sticks < t) return 0;
 800036c:	4b11      	ldr	r3, [pc, #68]	; (80003b4 <stexpired+0x64>)
 800036e:	681a      	ldr	r2, [r3, #0]
 8000370:	4b0f      	ldr	r3, [pc, #60]	; (80003b0 <stexpired+0x60>)
 8000372:	681b      	ldr	r3, [r3, #0]
 8000374:	429a      	cmp	r2, r3
 8000376:	d201      	bcs.n	800037c <stexpired+0x2c>
 8000378:	2300      	movs	r3, #0
 800037a:	e013      	b.n	80003a4 <stexpired+0x54>
  t = (_sticks - t) > period ? (_sticks + period) : (period + t);
 800037c:	4b0d      	ldr	r3, [pc, #52]	; (80003b4 <stexpired+0x64>)
 800037e:	681a      	ldr	r2, [r3, #0]
 8000380:	4b0b      	ldr	r3, [pc, #44]	; (80003b0 <stexpired+0x60>)
 8000382:	681b      	ldr	r3, [r3, #0]
 8000384:	1ad3      	subs	r3, r2, r3
 8000386:	687a      	ldr	r2, [r7, #4]
 8000388:	429a      	cmp	r2, r3
 800038a:	d204      	bcs.n	8000396 <stexpired+0x46>
 800038c:	4b09      	ldr	r3, [pc, #36]	; (80003b4 <stexpired+0x64>)
 800038e:	681a      	ldr	r2, [r3, #0]
 8000390:	687b      	ldr	r3, [r7, #4]
 8000392:	4413      	add	r3, r2
 8000394:	e003      	b.n	800039e <stexpired+0x4e>
 8000396:	4b06      	ldr	r3, [pc, #24]	; (80003b0 <stexpired+0x60>)
 8000398:	681a      	ldr	r2, [r3, #0]
 800039a:	687b      	ldr	r3, [r7, #4]
 800039c:	4413      	add	r3, r2
 800039e:	4a04      	ldr	r2, [pc, #16]	; (80003b0 <stexpired+0x60>)
 80003a0:	6013      	str	r3, [r2, #0]
  return 1;
 80003a2:	2301      	movs	r3, #1
}
 80003a4:	4618      	mov	r0, r3
 80003a6:	370c      	adds	r7, #12
 80003a8:	46bd      	mov	sp, r7
 80003aa:	f85d 7b04 	ldr.w	r7, [sp], #4
 80003ae:	4770      	bx	lr
 80003b0:	20010004 	.word	0x20010004
 80003b4:	20010000 	.word	0x20010000

080003b8 <userproc1>:


void userproc1()
{
 80003b8:	b580      	push	{r7, lr}
 80003ba:	b082      	sub	sp, #8
 80003bc:	af00      	add	r7, sp, #0
  //gpio_set_mode('B', 7, GPIO_MODE_OUTPUT); // PB7 is blue LED
  gpio_set_mode('B', 14, GPIO_MODE_OUTPUT); // PB14 is red LED
 80003be:	2201      	movs	r2, #1
 80003c0:	210e      	movs	r1, #14
 80003c2:	2042      	movs	r0, #66	; 0x42
 80003c4:	f7ff ff64 	bl	8000290 <gpio_set_mode>

  int on = 1;
 80003c8:	2301      	movs	r3, #1
 80003ca:	607b      	str	r3, [r7, #4]
  for(;;){
    if(stexpired(1000)){
 80003cc:	f44f 707a 	mov.w	r0, #1000	; 0x3e8
 80003d0:	f7ff ffbe 	bl	8000350 <stexpired>
 80003d4:	4603      	mov	r3, r0
 80003d6:	2b00      	cmp	r3, #0
 80003d8:	d0f8      	beq.n	80003cc <userproc1+0x14>
      gpio_write('B', 14, on);
 80003da:	687a      	ldr	r2, [r7, #4]
 80003dc:	210e      	movs	r1, #14
 80003de:	2042      	movs	r0, #66	; 0x42
 80003e0:	f7ff ff94 	bl	800030c <gpio_write>
      on = !on;
 80003e4:	687b      	ldr	r3, [r7, #4]
 80003e6:	2b00      	cmp	r3, #0
 80003e8:	bf0c      	ite	eq
 80003ea:	2301      	moveq	r3, #1
 80003ec:	2300      	movne	r3, #0
 80003ee:	b2db      	uxtb	r3, r3
 80003f0:	607b      	str	r3, [r7, #4]
      syscall();
 80003f2:	f000 fa17 	bl	8000824 <syscall>
    if(stexpired(1000)){
 80003f6:	e7e9      	b.n	80003cc <userproc1+0x14>

080003f8 <main>:
    }
  }
}

int main()
{
 80003f8:	b580      	push	{r7, lr}
 80003fa:	f5ad 6d81 	sub.w	sp, sp, #1032	; 0x408
 80003fe:	af00      	add	r7, sp, #0
  uint32 userstack[256];
  uint32 *usstart = userstack + 256 - 16;
 8000400:	1d3b      	adds	r3, r7, #4
 8000402:	f503 7370 	add.w	r3, r3, #960	; 0x3c0
 8000406:	f8c7 3404 	str.w	r3, [r7, #1028]	; 0x404
  usstart[8] = (uint32)userproc1;
 800040a:	f8d7 3404 	ldr.w	r3, [r7, #1028]	; 0x404
 800040e:	3320      	adds	r3, #32
 8000410:	4a08      	ldr	r2, [pc, #32]	; (8000434 <main+0x3c>)
 8000412:	601a      	str	r2, [r3, #0]

  swtch((uint32)usstart);
 8000414:	f8d7 3404 	ldr.w	r3, [r7, #1028]	; 0x404
 8000418:	4618      	mov	r0, r3
 800041a:	f000 f9f6 	bl	800080a <swtch>

  gpio_set_mode('B', 7, GPIO_MODE_OUTPUT); // PB7 is blue LED
 800041e:	2201      	movs	r2, #1
 8000420:	2107      	movs	r1, #7
 8000422:	2042      	movs	r0, #66	; 0x42
 8000424:	f7ff ff34 	bl	8000290 <gpio_set_mode>
  gpio_write('B', 7, 1);
 8000428:	2201      	movs	r2, #1
 800042a:	2107      	movs	r1, #7
 800042c:	2042      	movs	r0, #66	; 0x42
 800042e:	f7ff ff6d 	bl	800030c <gpio_write>
  while(1);
 8000432:	e7fe      	b.n	8000432 <main+0x3a>
 8000434:	080003b9 	.word	0x080003b9

08000438 <gpio_set_mode>:
{
 8000438:	b480      	push	{r7}
 800043a:	b085      	sub	sp, #20
 800043c:	af00      	add	r7, sp, #0
 800043e:	4603      	mov	r3, r0
 8000440:	6039      	str	r1, [r7, #0]
 8000442:	71fb      	strb	r3, [r7, #7]
 8000444:	4613      	mov	r3, r2
 8000446:	71bb      	strb	r3, [r7, #6]
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
 8000448:	79fb      	ldrb	r3, [r7, #7]
 800044a:	3b41      	subs	r3, #65	; 0x41
 800044c:	029b      	lsls	r3, r3, #10
 800044e:	461a      	mov	r2, r3
 8000450:	4b16      	ldr	r3, [pc, #88]	; (80004ac <gpio_set_mode+0x74>)
 8000452:	4413      	add	r3, r2
 8000454:	60fb      	str	r3, [r7, #12]
  pin &= 0xF;
 8000456:	683b      	ldr	r3, [r7, #0]
 8000458:	f003 030f 	and.w	r3, r3, #15
 800045c:	603b      	str	r3, [r7, #0]
  *(RCC_AHB1ENR) |= (1U << (port - 'A'));
 800045e:	4b14      	ldr	r3, [pc, #80]	; (80004b0 <gpio_set_mode+0x78>)
 8000460:	681a      	ldr	r2, [r3, #0]
 8000462:	79fb      	ldrb	r3, [r7, #7]
 8000464:	3b41      	subs	r3, #65	; 0x41
 8000466:	2101      	movs	r1, #1
 8000468:	fa01 f303 	lsl.w	r3, r1, r3
 800046c:	4910      	ldr	r1, [pc, #64]	; (80004b0 <gpio_set_mode+0x78>)
 800046e:	4313      	orrs	r3, r2
 8000470:	600b      	str	r3, [r1, #0]
  gp->moder &= ~(0x3 << (pin * 2)); // clear previos
 8000472:	68fb      	ldr	r3, [r7, #12]
 8000474:	681b      	ldr	r3, [r3, #0]
 8000476:	683a      	ldr	r2, [r7, #0]
 8000478:	0052      	lsls	r2, r2, #1
 800047a:	2103      	movs	r1, #3
 800047c:	fa01 f202 	lsl.w	r2, r1, r2
 8000480:	43d2      	mvns	r2, r2
 8000482:	401a      	ands	r2, r3
 8000484:	68fb      	ldr	r3, [r7, #12]
 8000486:	601a      	str	r2, [r3, #0]
  gp->moder |= ((gpio_mode & 0x3) << (pin * 2)); // set mode 
 8000488:	68fb      	ldr	r3, [r7, #12]
 800048a:	681b      	ldr	r3, [r3, #0]
 800048c:	79ba      	ldrb	r2, [r7, #6]
 800048e:	f002 0103 	and.w	r1, r2, #3
 8000492:	683a      	ldr	r2, [r7, #0]
 8000494:	0052      	lsls	r2, r2, #1
 8000496:	fa01 f202 	lsl.w	r2, r1, r2
 800049a:	431a      	orrs	r2, r3
 800049c:	68fb      	ldr	r3, [r7, #12]
 800049e:	601a      	str	r2, [r3, #0]
}
 80004a0:	bf00      	nop
 80004a2:	3714      	adds	r7, #20
 80004a4:	46bd      	mov	sp, r7
 80004a6:	f85d 7b04 	ldr.w	r7, [sp], #4
 80004aa:	4770      	bx	lr
 80004ac:	40020000 	.word	0x40020000
 80004b0:	40023830 	.word	0x40023830

080004b4 <gpio_set_af>:
{
 80004b4:	b480      	push	{r7}
 80004b6:	b087      	sub	sp, #28
 80004b8:	af00      	add	r7, sp, #0
 80004ba:	4603      	mov	r3, r0
 80004bc:	60b9      	str	r1, [r7, #8]
 80004be:	607a      	str	r2, [r7, #4]
 80004c0:	73fb      	strb	r3, [r7, #15]
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
 80004c2:	7bfb      	ldrb	r3, [r7, #15]
 80004c4:	3b41      	subs	r3, #65	; 0x41
 80004c6:	029b      	lsls	r3, r3, #10
 80004c8:	461a      	mov	r2, r3
 80004ca:	4b1c      	ldr	r3, [pc, #112]	; (800053c <gpio_set_af+0x88>)
 80004cc:	4413      	add	r3, r2
 80004ce:	617b      	str	r3, [r7, #20]
  pin &= 0xF;
 80004d0:	68bb      	ldr	r3, [r7, #8]
 80004d2:	f003 030f 	and.w	r3, r3, #15
 80004d6:	60bb      	str	r3, [r7, #8]
  gp->afr[pin >> 3] &= ~(0xF << ((pin & 0x7) * 4)); // clear
 80004d8:	68bb      	ldr	r3, [r7, #8]
 80004da:	10da      	asrs	r2, r3, #3
 80004dc:	697b      	ldr	r3, [r7, #20]
 80004de:	3208      	adds	r2, #8
 80004e0:	f853 3022 	ldr.w	r3, [r3, r2, lsl #2]
 80004e4:	68ba      	ldr	r2, [r7, #8]
 80004e6:	f002 0207 	and.w	r2, r2, #7
 80004ea:	0092      	lsls	r2, r2, #2
 80004ec:	210f      	movs	r1, #15
 80004ee:	fa01 f202 	lsl.w	r2, r1, r2
 80004f2:	43d2      	mvns	r2, r2
 80004f4:	4611      	mov	r1, r2
 80004f6:	68ba      	ldr	r2, [r7, #8]
 80004f8:	10d2      	asrs	r2, r2, #3
 80004fa:	4019      	ands	r1, r3
 80004fc:	697b      	ldr	r3, [r7, #20]
 80004fe:	3208      	adds	r2, #8
 8000500:	f843 1022 	str.w	r1, [r3, r2, lsl #2]
  gp->afr[pin >> 3] |= (af << ((pin & 0x7) * 4));   // set
 8000504:	68bb      	ldr	r3, [r7, #8]
 8000506:	10da      	asrs	r2, r3, #3
 8000508:	697b      	ldr	r3, [r7, #20]
 800050a:	3208      	adds	r2, #8
 800050c:	f853 3022 	ldr.w	r3, [r3, r2, lsl #2]
 8000510:	68ba      	ldr	r2, [r7, #8]
 8000512:	f002 0207 	and.w	r2, r2, #7
 8000516:	0092      	lsls	r2, r2, #2
 8000518:	6879      	ldr	r1, [r7, #4]
 800051a:	fa01 f202 	lsl.w	r2, r1, r2
 800051e:	4611      	mov	r1, r2
 8000520:	68ba      	ldr	r2, [r7, #8]
 8000522:	10d2      	asrs	r2, r2, #3
 8000524:	4319      	orrs	r1, r3
 8000526:	697b      	ldr	r3, [r7, #20]
 8000528:	3208      	adds	r2, #8
 800052a:	f843 1022 	str.w	r1, [r3, r2, lsl #2]
}
 800052e:	bf00      	nop
 8000530:	371c      	adds	r7, #28
 8000532:	46bd      	mov	sp, r7
 8000534:	f85d 7b04 	ldr.w	r7, [sp], #4
 8000538:	4770      	bx	lr
 800053a:	bf00      	nop
 800053c:	40020000 	.word	0x40020000

08000540 <uartinit>:
#include "gpio.h"
#include "uart.h"

void
uartinit(struct uart *up, uint32 baud)
{
 8000540:	b580      	push	{r7, lr}
 8000542:	b086      	sub	sp, #24
 8000544:	af00      	add	r7, sp, #0
 8000546:	6078      	str	r0, [r7, #4]
 8000548:	6039      	str	r1, [r7, #0]
  char port;
  int tx, rx, af;

  switch((uint32)up)
 800054a:	687b      	ldr	r3, [r7, #4]
 800054c:	4a68      	ldr	r2, [pc, #416]	; (80006f0 <uartinit+0x1b0>)
 800054e:	4293      	cmp	r3, r2
 8000550:	d06c      	beq.n	800062c <uartinit+0xec>
 8000552:	4a67      	ldr	r2, [pc, #412]	; (80006f0 <uartinit+0x1b0>)
 8000554:	4293      	cmp	r3, r2
 8000556:	d81e      	bhi.n	8000596 <uartinit+0x56>
 8000558:	4a66      	ldr	r2, [pc, #408]	; (80006f4 <uartinit+0x1b4>)
 800055a:	4293      	cmp	r3, r2
 800055c:	f000 8084 	beq.w	8000668 <uartinit+0x128>
 8000560:	4a64      	ldr	r2, [pc, #400]	; (80006f4 <uartinit+0x1b4>)
 8000562:	4293      	cmp	r3, r2
 8000564:	d817      	bhi.n	8000596 <uartinit+0x56>
 8000566:	4a64      	ldr	r2, [pc, #400]	; (80006f8 <uartinit+0x1b8>)
 8000568:	4293      	cmp	r3, r2
 800056a:	d06e      	beq.n	800064a <uartinit+0x10a>
 800056c:	4a62      	ldr	r2, [pc, #392]	; (80006f8 <uartinit+0x1b8>)
 800056e:	4293      	cmp	r3, r2
 8000570:	d811      	bhi.n	8000596 <uartinit+0x56>
 8000572:	4a62      	ldr	r2, [pc, #392]	; (80006fc <uartinit+0x1bc>)
 8000574:	4293      	cmp	r3, r2
 8000576:	d04a      	beq.n	800060e <uartinit+0xce>
 8000578:	4a60      	ldr	r2, [pc, #384]	; (80006fc <uartinit+0x1bc>)
 800057a:	4293      	cmp	r3, r2
 800057c:	d80b      	bhi.n	8000596 <uartinit+0x56>
 800057e:	4a60      	ldr	r2, [pc, #384]	; (8000700 <uartinit+0x1c0>)
 8000580:	4293      	cmp	r3, r2
 8000582:	d035      	beq.n	80005f0 <uartinit+0xb0>
 8000584:	4a5e      	ldr	r2, [pc, #376]	; (8000700 <uartinit+0x1c0>)
 8000586:	4293      	cmp	r3, r2
 8000588:	d805      	bhi.n	8000596 <uartinit+0x56>
 800058a:	4a5e      	ldr	r2, [pc, #376]	; (8000704 <uartinit+0x1c4>)
 800058c:	4293      	cmp	r3, r2
 800058e:	d011      	beq.n	80005b4 <uartinit+0x74>
 8000590:	4a5d      	ldr	r2, [pc, #372]	; (8000708 <uartinit+0x1c8>)
 8000592:	4293      	cmp	r3, r2
 8000594:	d01d      	beq.n	80005d2 <uartinit+0x92>
  {
    default:
    case USART1:
      *(RCC_APB2ENR) |= (1U << 4);
 8000596:	4b5d      	ldr	r3, [pc, #372]	; (800070c <uartinit+0x1cc>)
 8000598:	681b      	ldr	r3, [r3, #0]
 800059a:	4a5c      	ldr	r2, [pc, #368]	; (800070c <uartinit+0x1cc>)
 800059c:	f043 0310 	orr.w	r3, r3, #16
 80005a0:	6013      	str	r3, [r2, #0]
      port = 'A', tx = 9, rx = 10, af = 7;
 80005a2:	2341      	movs	r3, #65	; 0x41
 80005a4:	75fb      	strb	r3, [r7, #23]
 80005a6:	2309      	movs	r3, #9
 80005a8:	613b      	str	r3, [r7, #16]
 80005aa:	230a      	movs	r3, #10
 80005ac:	60fb      	str	r3, [r7, #12]
 80005ae:	2307      	movs	r3, #7
 80005b0:	60bb      	str	r3, [r7, #8]
      break;
 80005b2:	e068      	b.n	8000686 <uartinit+0x146>
    case USART2:
      *(RCC_APB1ENR) |= (1U << 17);
 80005b4:	4b56      	ldr	r3, [pc, #344]	; (8000710 <uartinit+0x1d0>)
 80005b6:	681b      	ldr	r3, [r3, #0]
 80005b8:	4a55      	ldr	r2, [pc, #340]	; (8000710 <uartinit+0x1d0>)
 80005ba:	f443 3300 	orr.w	r3, r3, #131072	; 0x20000
 80005be:	6013      	str	r3, [r2, #0]
      port = 'A', tx = 2, rx = 3, af = 7;
 80005c0:	2341      	movs	r3, #65	; 0x41
 80005c2:	75fb      	strb	r3, [r7, #23]
 80005c4:	2302      	movs	r3, #2
 80005c6:	613b      	str	r3, [r7, #16]
 80005c8:	2303      	movs	r3, #3
 80005ca:	60fb      	str	r3, [r7, #12]
 80005cc:	2307      	movs	r3, #7
 80005ce:	60bb      	str	r3, [r7, #8]
      break;
 80005d0:	e059      	b.n	8000686 <uartinit+0x146>
    case USART3:
      *(RCC_APB1ENR) |= (1U << 18);
 80005d2:	4b4f      	ldr	r3, [pc, #316]	; (8000710 <uartinit+0x1d0>)
 80005d4:	681b      	ldr	r3, [r3, #0]
 80005d6:	4a4e      	ldr	r2, [pc, #312]	; (8000710 <uartinit+0x1d0>)
 80005d8:	f443 2380 	orr.w	r3, r3, #262144	; 0x40000
 80005dc:	6013      	str	r3, [r2, #0]
      port = 'B', tx = 10, rx = 11, af = 7;
 80005de:	2342      	movs	r3, #66	; 0x42
 80005e0:	75fb      	strb	r3, [r7, #23]
 80005e2:	230a      	movs	r3, #10
 80005e4:	613b      	str	r3, [r7, #16]
 80005e6:	230b      	movs	r3, #11
 80005e8:	60fb      	str	r3, [r7, #12]
 80005ea:	2307      	movs	r3, #7
 80005ec:	60bb      	str	r3, [r7, #8]
      break;
 80005ee:	e04a      	b.n	8000686 <uartinit+0x146>
    case UART4:
      *(RCC_APB1ENR) |= (1U << 19);
 80005f0:	4b47      	ldr	r3, [pc, #284]	; (8000710 <uartinit+0x1d0>)
 80005f2:	681b      	ldr	r3, [r3, #0]
 80005f4:	4a46      	ldr	r2, [pc, #280]	; (8000710 <uartinit+0x1d0>)
 80005f6:	f443 2300 	orr.w	r3, r3, #524288	; 0x80000
 80005fa:	6013      	str	r3, [r2, #0]
      port = 'A', tx = 0, rx = 1, af = 8;
 80005fc:	2341      	movs	r3, #65	; 0x41
 80005fe:	75fb      	strb	r3, [r7, #23]
 8000600:	2300      	movs	r3, #0
 8000602:	613b      	str	r3, [r7, #16]
 8000604:	2301      	movs	r3, #1
 8000606:	60fb      	str	r3, [r7, #12]
 8000608:	2308      	movs	r3, #8
 800060a:	60bb      	str	r3, [r7, #8]
      break;
 800060c:	e03b      	b.n	8000686 <uartinit+0x146>
    case UART5:
      *(RCC_APB1ENR) |= (1U << 20);
 800060e:	4b40      	ldr	r3, [pc, #256]	; (8000710 <uartinit+0x1d0>)
 8000610:	681b      	ldr	r3, [r3, #0]
 8000612:	4a3f      	ldr	r2, [pc, #252]	; (8000710 <uartinit+0x1d0>)
 8000614:	f443 1380 	orr.w	r3, r3, #1048576	; 0x100000
 8000618:	6013      	str	r3, [r2, #0]
      port = 'C', tx = 12, rx = 2, af = 8;
 800061a:	2343      	movs	r3, #67	; 0x43
 800061c:	75fb      	strb	r3, [r7, #23]
 800061e:	230c      	movs	r3, #12
 8000620:	613b      	str	r3, [r7, #16]
 8000622:	2302      	movs	r3, #2
 8000624:	60fb      	str	r3, [r7, #12]
 8000626:	2308      	movs	r3, #8
 8000628:	60bb      	str	r3, [r7, #8]
      break;
 800062a:	e02c      	b.n	8000686 <uartinit+0x146>
    case USART6:
      *(RCC_APB2ENR) |= (1U << 5);
 800062c:	4b37      	ldr	r3, [pc, #220]	; (800070c <uartinit+0x1cc>)
 800062e:	681b      	ldr	r3, [r3, #0]
 8000630:	4a36      	ldr	r2, [pc, #216]	; (800070c <uartinit+0x1cc>)
 8000632:	f043 0320 	orr.w	r3, r3, #32
 8000636:	6013      	str	r3, [r2, #0]
      port = 'G', tx = 14, rx = 9, af = 8;
 8000638:	2347      	movs	r3, #71	; 0x47
 800063a:	75fb      	strb	r3, [r7, #23]
 800063c:	230e      	movs	r3, #14
 800063e:	613b      	str	r3, [r7, #16]
 8000640:	2309      	movs	r3, #9
 8000642:	60fb      	str	r3, [r7, #12]
 8000644:	2308      	movs	r3, #8
 8000646:	60bb      	str	r3, [r7, #8]
      break;
 8000648:	e01d      	b.n	8000686 <uartinit+0x146>
    case UART7:
      *(RCC_APB1ENR) |= (1U << 30);
 800064a:	4b31      	ldr	r3, [pc, #196]	; (8000710 <uartinit+0x1d0>)
 800064c:	681b      	ldr	r3, [r3, #0]
 800064e:	4a30      	ldr	r2, [pc, #192]	; (8000710 <uartinit+0x1d0>)
 8000650:	f043 4380 	orr.w	r3, r3, #1073741824	; 0x40000000
 8000654:	6013      	str	r3, [r2, #0]
      port = 'E', tx = 8, rx = 7, af = 8;
 8000656:	2345      	movs	r3, #69	; 0x45
 8000658:	75fb      	strb	r3, [r7, #23]
 800065a:	2308      	movs	r3, #8
 800065c:	613b      	str	r3, [r7, #16]
 800065e:	2307      	movs	r3, #7
 8000660:	60fb      	str	r3, [r7, #12]
 8000662:	2308      	movs	r3, #8
 8000664:	60bb      	str	r3, [r7, #8]
      break;
 8000666:	e00e      	b.n	8000686 <uartinit+0x146>
    case UART8:
      *(RCC_APB1ENR) |= (1U << 31);
 8000668:	4b29      	ldr	r3, [pc, #164]	; (8000710 <uartinit+0x1d0>)
 800066a:	681b      	ldr	r3, [r3, #0]
 800066c:	4a28      	ldr	r2, [pc, #160]	; (8000710 <uartinit+0x1d0>)
 800066e:	f043 4300 	orr.w	r3, r3, #2147483648	; 0x80000000
 8000672:	6013      	str	r3, [r2, #0]
      port = 'E', tx = 1, rx = 0, af = 8;
 8000674:	2345      	movs	r3, #69	; 0x45
 8000676:	75fb      	strb	r3, [r7, #23]
 8000678:	2301      	movs	r3, #1
 800067a:	613b      	str	r3, [r7, #16]
 800067c:	2300      	movs	r3, #0
 800067e:	60fb      	str	r3, [r7, #12]
 8000680:	2308      	movs	r3, #8
 8000682:	60bb      	str	r3, [r7, #8]
      break;
 8000684:	bf00      	nop
  }

  gpio_set_mode(port, tx, GPIO_MODE_AF);
 8000686:	7dfb      	ldrb	r3, [r7, #23]
 8000688:	2202      	movs	r2, #2
 800068a:	6939      	ldr	r1, [r7, #16]
 800068c:	4618      	mov	r0, r3
 800068e:	f7ff fed3 	bl	8000438 <gpio_set_mode>
  gpio_set_af(port, tx, af);
 8000692:	7dfb      	ldrb	r3, [r7, #23]
 8000694:	68ba      	ldr	r2, [r7, #8]
 8000696:	6939      	ldr	r1, [r7, #16]
 8000698:	4618      	mov	r0, r3
 800069a:	f7ff ff0b 	bl	80004b4 <gpio_set_af>

  if((uint32)up == UART5) port = 'D';
 800069e:	687b      	ldr	r3, [r7, #4]
 80006a0:	4a16      	ldr	r2, [pc, #88]	; (80006fc <uartinit+0x1bc>)
 80006a2:	4293      	cmp	r3, r2
 80006a4:	d101      	bne.n	80006aa <uartinit+0x16a>
 80006a6:	2344      	movs	r3, #68	; 0x44
 80006a8:	75fb      	strb	r3, [r7, #23]

  gpio_set_mode(port, rx, GPIO_MODE_AF);
 80006aa:	7dfb      	ldrb	r3, [r7, #23]
 80006ac:	2202      	movs	r2, #2
 80006ae:	68f9      	ldr	r1, [r7, #12]
 80006b0:	4618      	mov	r0, r3
 80006b2:	f7ff fec1 	bl	8000438 <gpio_set_mode>
  gpio_set_af(port, rx, af);
 80006b6:	7dfb      	ldrb	r3, [r7, #23]
 80006b8:	68ba      	ldr	r2, [r7, #8]
 80006ba:	68f9      	ldr	r1, [r7, #12]
 80006bc:	4618      	mov	r0, r3
 80006be:	f7ff fef9 	bl	80004b4 <gpio_set_af>

  up->CR1 &= ~(0xD); //clear
 80006c2:	687b      	ldr	r3, [r7, #4]
 80006c4:	681b      	ldr	r3, [r3, #0]
 80006c6:	f023 020d 	bic.w	r2, r3, #13
 80006ca:	687b      	ldr	r3, [r7, #4]
 80006cc:	601a      	str	r2, [r3, #0]
  up->BRR = (FREQ / baud);
 80006ce:	4a11      	ldr	r2, [pc, #68]	; (8000714 <uartinit+0x1d4>)
 80006d0:	683b      	ldr	r3, [r7, #0]
 80006d2:	fbb2 f2f3 	udiv	r2, r2, r3
 80006d6:	687b      	ldr	r3, [r7, #4]
 80006d8:	60da      	str	r2, [r3, #12]
  up->CR1 |= (0xD); // enable TE RE UE (1101 == 0xD)
 80006da:	687b      	ldr	r3, [r7, #4]
 80006dc:	681b      	ldr	r3, [r3, #0]
 80006de:	f043 020d 	orr.w	r2, r3, #13
 80006e2:	687b      	ldr	r3, [r7, #4]
 80006e4:	601a      	str	r2, [r3, #0]
}
 80006e6:	bf00      	nop
 80006e8:	3718      	adds	r7, #24
 80006ea:	46bd      	mov	sp, r7
 80006ec:	bd80      	pop	{r7, pc}
 80006ee:	bf00      	nop
 80006f0:	40011400 	.word	0x40011400
 80006f4:	40007c00 	.word	0x40007c00
 80006f8:	40007800 	.word	0x40007800
 80006fc:	40005000 	.word	0x40005000
 8000700:	40004c00 	.word	0x40004c00
 8000704:	40004400 	.word	0x40004400
 8000708:	40004800 	.word	0x40004800
 800070c:	40023844 	.word	0x40023844
 8000710:	40023840 	.word	0x40023840
 8000714:	00f42400 	.word	0x00f42400

08000718 <uartputc>:

static void
uartputc(struct uart *up, uint8 c)
{
 8000718:	b480      	push	{r7}
 800071a:	b083      	sub	sp, #12
 800071c:	af00      	add	r7, sp, #0
 800071e:	6078      	str	r0, [r7, #4]
 8000720:	460b      	mov	r3, r1
 8000722:	70fb      	strb	r3, [r7, #3]
  up->TDR = c;
 8000724:	78fa      	ldrb	r2, [r7, #3]
 8000726:	687b      	ldr	r3, [r7, #4]
 8000728:	629a      	str	r2, [r3, #40]	; 0x28
  while( !(up->ISR & (1U << 7)) ); // spin when TXE == 0
 800072a:	bf00      	nop
 800072c:	687b      	ldr	r3, [r7, #4]
 800072e:	69db      	ldr	r3, [r3, #28]
 8000730:	f003 0380 	and.w	r3, r3, #128	; 0x80
 8000734:	2b00      	cmp	r3, #0
 8000736:	d0f9      	beq.n	800072c <uartputc+0x14>
}
 8000738:	bf00      	nop
 800073a:	bf00      	nop
 800073c:	370c      	adds	r7, #12
 800073e:	46bd      	mov	sp, r7
 8000740:	f85d 7b04 	ldr.w	r7, [sp], #4
 8000744:	4770      	bx	lr

08000746 <uartwrite>:

void
uartwrite(struct uart *up, char *buf, uint32 len)
{
 8000746:	b580      	push	{r7, lr}
 8000748:	b086      	sub	sp, #24
 800074a:	af00      	add	r7, sp, #0
 800074c:	60f8      	str	r0, [r7, #12]
 800074e:	60b9      	str	r1, [r7, #8]
 8000750:	607a      	str	r2, [r7, #4]
  char *c = buf;
 8000752:	68bb      	ldr	r3, [r7, #8]
 8000754:	617b      	str	r3, [r7, #20]
  uint32 i = 0;
 8000756:	2300      	movs	r3, #0
 8000758:	613b      	str	r3, [r7, #16]

  while(i++ < len){
 800075a:	e008      	b.n	800076e <uartwrite+0x28>
    uartputc(up, *c);
 800075c:	697b      	ldr	r3, [r7, #20]
 800075e:	781b      	ldrb	r3, [r3, #0]
 8000760:	4619      	mov	r1, r3
 8000762:	68f8      	ldr	r0, [r7, #12]
 8000764:	f7ff ffd8 	bl	8000718 <uartputc>
    c++;
 8000768:	697b      	ldr	r3, [r7, #20]
 800076a:	3301      	adds	r3, #1
 800076c:	617b      	str	r3, [r7, #20]
  while(i++ < len){
 800076e:	693b      	ldr	r3, [r7, #16]
 8000770:	1c5a      	adds	r2, r3, #1
 8000772:	613a      	str	r2, [r7, #16]
 8000774:	687a      	ldr	r2, [r7, #4]
 8000776:	429a      	cmp	r2, r3
 8000778:	d8f0      	bhi.n	800075c <uartwrite+0x16>
  }
}
 800077a:	bf00      	nop
 800077c:	bf00      	nop
 800077e:	3718      	adds	r7, #24
 8000780:	46bd      	mov	sp, r7
 8000782:	bd80      	pop	{r7, pc}

08000784 <uartgetc>:

static int
uartgetc(struct uart *up)
{
 8000784:	b480      	push	{r7}
 8000786:	b083      	sub	sp, #12
 8000788:	af00      	add	r7, sp, #0
 800078a:	6078      	str	r0, [r7, #4]
  if( !(up->ISR & (1U << 5)) )
 800078c:	687b      	ldr	r3, [r7, #4]
 800078e:	69db      	ldr	r3, [r3, #28]
 8000790:	f003 0320 	and.w	r3, r3, #32
 8000794:	2b00      	cmp	r3, #0
 8000796:	d102      	bne.n	800079e <uartgetc+0x1a>
    return up->RDR;
 8000798:	687b      	ldr	r3, [r7, #4]
 800079a:	6a5b      	ldr	r3, [r3, #36]	; 0x24
 800079c:	e001      	b.n	80007a2 <uartgetc+0x1e>
  else
    return -1;
 800079e:	f04f 33ff 	mov.w	r3, #4294967295	; 0xffffffff
}
 80007a2:	4618      	mov	r0, r3
 80007a4:	370c      	adds	r7, #12
 80007a6:	46bd      	mov	sp, r7
 80007a8:	f85d 7b04 	ldr.w	r7, [sp], #4
 80007ac:	4770      	bx	lr

080007ae <uartread>:

void
uartread(struct uart *up, char *buf, uint32 len)
{
 80007ae:	b580      	push	{r7, lr}
 80007b0:	b086      	sub	sp, #24
 80007b2:	af00      	add	r7, sp, #0
 80007b4:	60f8      	str	r0, [r7, #12]
 80007b6:	60b9      	str	r1, [r7, #8]
 80007b8:	607a      	str	r2, [r7, #4]
  int c;
  uint32 i = 0;
 80007ba:	2300      	movs	r3, #0
 80007bc:	617b      	str	r3, [r7, #20]

  while(i < len && (c = uartgetc(up)) != -1){
 80007be:	e008      	b.n	80007d2 <uartread+0x24>
    *(buf + i) = c;
 80007c0:	68ba      	ldr	r2, [r7, #8]
 80007c2:	697b      	ldr	r3, [r7, #20]
 80007c4:	4413      	add	r3, r2
 80007c6:	693a      	ldr	r2, [r7, #16]
 80007c8:	b2d2      	uxtb	r2, r2
 80007ca:	701a      	strb	r2, [r3, #0]
    i++;
 80007cc:	697b      	ldr	r3, [r7, #20]
 80007ce:	3301      	adds	r3, #1
 80007d0:	617b      	str	r3, [r7, #20]
  while(i < len && (c = uartgetc(up)) != -1){
 80007d2:	697a      	ldr	r2, [r7, #20]
 80007d4:	687b      	ldr	r3, [r7, #4]
 80007d6:	429a      	cmp	r2, r3
 80007d8:	d207      	bcs.n	80007ea <uartread+0x3c>
 80007da:	68f8      	ldr	r0, [r7, #12]
 80007dc:	f7ff ffd2 	bl	8000784 <uartgetc>
 80007e0:	6138      	str	r0, [r7, #16]
 80007e2:	693b      	ldr	r3, [r7, #16]
 80007e4:	f1b3 3fff 	cmp.w	r3, #4294967295	; 0xffffffff
 80007e8:	d1ea      	bne.n	80007c0 <uartread+0x12>
  }
}
 80007ea:	bf00      	nop
 80007ec:	3718      	adds	r7, #24
 80007ee:	46bd      	mov	sp, r7
 80007f0:	bd80      	pop	{r7, pc}
 80007f2:	bf00      	nop

080007f4 <svc_handler>:
.syntax unified

.type svc_handler, %function
.global svc_handler
svc_handler:
	mrs r0, psp
 80007f4:	f3ef 8009 	mrs	r0, PSP
	stmdb r0!, {r4-r10, fp, lr}
 80007f8:	e920 4ff0 	stmdb	r0!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}

	mov r0, #0
 80007fc:	f04f 0000 	mov.w	r0, #0
	msr control, r0
 8000800:	f380 8814 	msr	CONTROL, r0

	#pop {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	pop {r4-r10, fp, ip, lr}
 8000804:	e8bd 5ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}

	bx lr
 8000808:	4770      	bx	lr

0800080a <swtch>:

.global swtch
swtch:
	/* save kernel state into main stack */
	mrs ip, psr
 800080a:	f3ef 8c03 	mrs	ip, PSR
	push {r4-r10, fp, ip, lr}
 800080e:	e92d 5ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
	
	/* switch to process stack */
	msr psp, a1
 8000812:	f380 8809 	msr	PSP, r0
	mov a1, #3
 8000816:	f04f 0003 	mov.w	r0, #3
	msr control, a1
 800081a:	f380 8814 	msr	CONTROL, r0

	/* restore process stack to finish switching */
	pop {r4, r5, r6, r7, r8, r9, r10, fp, lr}
 800081e:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}

	/* return to address lr */
	bx lr
 8000822:	4770      	bx	lr

08000824 <syscall>:
.thumb
.syntax unified

.global syscall
syscall:
	svc 0
 8000824:	df00      	svc	0
	nop
 8000826:	bf00      	nop
	bx lr
 8000828:	4770      	bx	lr
