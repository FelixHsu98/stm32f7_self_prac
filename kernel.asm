
firmware.elf:     file format elf32-littlearm


Disassembly of section .text:

080001e0 <gpio_set_mode>:
  GPIO_MODE_ANALOG
} gmode_t;

static inline void
gpio_set_mode(char port, int pin, gmode_t gpio_mode)
{
 80001e0:	b480      	push	{r7}
 80001e2:	b085      	sub	sp, #20
 80001e4:	af00      	add	r7, sp, #0
 80001e6:	4603      	mov	r3, r0
 80001e8:	6039      	str	r1, [r7, #0]
 80001ea:	71fb      	strb	r3, [r7, #7]
 80001ec:	4613      	mov	r3, r2
 80001ee:	71bb      	strb	r3, [r7, #6]
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
 80001f0:	79fb      	ldrb	r3, [r7, #7]
 80001f2:	3b41      	subs	r3, #65	; 0x41
 80001f4:	029b      	lsls	r3, r3, #10
 80001f6:	461a      	mov	r2, r3
 80001f8:	4b11      	ldr	r3, [pc, #68]	; (8000240 <gpio_set_mode+0x60>)
 80001fa:	4413      	add	r3, r2
 80001fc:	60fb      	str	r3, [r7, #12]
  pin &= 0xF;
 80001fe:	683b      	ldr	r3, [r7, #0]
 8000200:	f003 030f 	and.w	r3, r3, #15
 8000204:	603b      	str	r3, [r7, #0]
  gp->moder &= ~(0x3 << (pin * 2)); // clear previos
 8000206:	68fb      	ldr	r3, [r7, #12]
 8000208:	681b      	ldr	r3, [r3, #0]
 800020a:	683a      	ldr	r2, [r7, #0]
 800020c:	0052      	lsls	r2, r2, #1
 800020e:	2103      	movs	r1, #3
 8000210:	fa01 f202 	lsl.w	r2, r1, r2
 8000214:	43d2      	mvns	r2, r2
 8000216:	401a      	ands	r2, r3
 8000218:	68fb      	ldr	r3, [r7, #12]
 800021a:	601a      	str	r2, [r3, #0]
  gp->moder |= ((gpio_mode & 0x3) << (pin * 2)); // set mode 
 800021c:	68fb      	ldr	r3, [r7, #12]
 800021e:	681b      	ldr	r3, [r3, #0]
 8000220:	79ba      	ldrb	r2, [r7, #6]
 8000222:	f002 0103 	and.w	r1, r2, #3
 8000226:	683a      	ldr	r2, [r7, #0]
 8000228:	0052      	lsls	r2, r2, #1
 800022a:	fa01 f202 	lsl.w	r2, r1, r2
 800022e:	431a      	orrs	r2, r3
 8000230:	68fb      	ldr	r3, [r7, #12]
 8000232:	601a      	str	r2, [r3, #0]
}
 8000234:	bf00      	nop
 8000236:	3714      	adds	r7, #20
 8000238:	46bd      	mov	sp, r7
 800023a:	bc80      	pop	{r7}
 800023c:	4770      	bx	lr
 800023e:	bf00      	nop
 8000240:	40020000 	.word	0x40020000

08000244 <gpio_write>:

static inline void
gpio_write(char port, int pin, int val)
{
 8000244:	b480      	push	{r7}
 8000246:	b087      	sub	sp, #28
 8000248:	af00      	add	r7, sp, #0
 800024a:	4603      	mov	r3, r0
 800024c:	60b9      	str	r1, [r7, #8]
 800024e:	607a      	str	r2, [r7, #4]
 8000250:	73fb      	strb	r3, [r7, #15]
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
 8000252:	7bfb      	ldrb	r3, [r7, #15]
 8000254:	3b41      	subs	r3, #65	; 0x41
 8000256:	029b      	lsls	r3, r3, #10
 8000258:	461a      	mov	r2, r3
 800025a:	4b0a      	ldr	r3, [pc, #40]	; (8000284 <gpio_write+0x40>)
 800025c:	4413      	add	r3, r2
 800025e:	617b      	str	r3, [r7, #20]
  gp->bsrr = (1U << pin) << (val ? 0 : 16);
 8000260:	2201      	movs	r2, #1
 8000262:	68bb      	ldr	r3, [r7, #8]
 8000264:	409a      	lsls	r2, r3
 8000266:	687b      	ldr	r3, [r7, #4]
 8000268:	2b00      	cmp	r3, #0
 800026a:	d001      	beq.n	8000270 <gpio_write+0x2c>
 800026c:	2300      	movs	r3, #0
 800026e:	e000      	b.n	8000272 <gpio_write+0x2e>
 8000270:	2310      	movs	r3, #16
 8000272:	409a      	lsls	r2, r3
 8000274:	697b      	ldr	r3, [r7, #20]
 8000276:	619a      	str	r2, [r3, #24]
}
 8000278:	bf00      	nop
 800027a:	371c      	adds	r7, #28
 800027c:	46bd      	mov	sp, r7
 800027e:	bc80      	pop	{r7}
 8000280:	4770      	bx	lr
 8000282:	bf00      	nop
 8000284:	40020000 	.word	0x40020000

08000288 <stexpired>:

static volatile uint32  _sticks = 0;

static uint32
stexpired(uint32 period)
{
 8000288:	b480      	push	{r7}
 800028a:	b083      	sub	sp, #12
 800028c:	af00      	add	r7, sp, #0
 800028e:	6078      	str	r0, [r7, #4]
  static uint32 t = 0;
  //if(_sticks + period < t) t = 0;
  if(t == 0) t = period + _sticks;
 8000290:	4b15      	ldr	r3, [pc, #84]	; (80002e8 <stexpired+0x60>)
 8000292:	681b      	ldr	r3, [r3, #0]
 8000294:	2b00      	cmp	r3, #0
 8000296:	d105      	bne.n	80002a4 <stexpired+0x1c>
 8000298:	4b14      	ldr	r3, [pc, #80]	; (80002ec <stexpired+0x64>)
 800029a:	681a      	ldr	r2, [r3, #0]
 800029c:	687b      	ldr	r3, [r7, #4]
 800029e:	4413      	add	r3, r2
 80002a0:	4a11      	ldr	r2, [pc, #68]	; (80002e8 <stexpired+0x60>)
 80002a2:	6013      	str	r3, [r2, #0]
  if(_sticks < t) return 0;
 80002a4:	4b11      	ldr	r3, [pc, #68]	; (80002ec <stexpired+0x64>)
 80002a6:	681a      	ldr	r2, [r3, #0]
 80002a8:	4b0f      	ldr	r3, [pc, #60]	; (80002e8 <stexpired+0x60>)
 80002aa:	681b      	ldr	r3, [r3, #0]
 80002ac:	429a      	cmp	r2, r3
 80002ae:	d201      	bcs.n	80002b4 <stexpired+0x2c>
 80002b0:	2300      	movs	r3, #0
 80002b2:	e013      	b.n	80002dc <stexpired+0x54>
  t = (_sticks - t) > period ? (_sticks + period) : (period + t);
 80002b4:	4b0d      	ldr	r3, [pc, #52]	; (80002ec <stexpired+0x64>)
 80002b6:	681a      	ldr	r2, [r3, #0]
 80002b8:	4b0b      	ldr	r3, [pc, #44]	; (80002e8 <stexpired+0x60>)
 80002ba:	681b      	ldr	r3, [r3, #0]
 80002bc:	1ad3      	subs	r3, r2, r3
 80002be:	687a      	ldr	r2, [r7, #4]
 80002c0:	429a      	cmp	r2, r3
 80002c2:	d204      	bcs.n	80002ce <stexpired+0x46>
 80002c4:	4b09      	ldr	r3, [pc, #36]	; (80002ec <stexpired+0x64>)
 80002c6:	681a      	ldr	r2, [r3, #0]
 80002c8:	687b      	ldr	r3, [r7, #4]
 80002ca:	4413      	add	r3, r2
 80002cc:	e003      	b.n	80002d6 <stexpired+0x4e>
 80002ce:	4b06      	ldr	r3, [pc, #24]	; (80002e8 <stexpired+0x60>)
 80002d0:	681a      	ldr	r2, [r3, #0]
 80002d2:	687b      	ldr	r3, [r7, #4]
 80002d4:	4413      	add	r3, r2
 80002d6:	4a04      	ldr	r2, [pc, #16]	; (80002e8 <stexpired+0x60>)
 80002d8:	6013      	str	r3, [r2, #0]
  return 1;
 80002da:	2301      	movs	r3, #1
}
 80002dc:	4618      	mov	r0, r3
 80002de:	370c      	adds	r7, #12
 80002e0:	46bd      	mov	sp, r7
 80002e2:	bc80      	pop	{r7}
 80002e4:	4770      	bx	lr
 80002e6:	bf00      	nop
 80002e8:	20010004 	.word	0x20010004
 80002ec:	20010000 	.word	0x20010000

080002f0 <main>:

int main()
{
 80002f0:	b580      	push	{r7, lr}
 80002f2:	b082      	sub	sp, #8
 80002f4:	af00      	add	r7, sp, #0
  *(RCC_AHB1ENR) |= (0x00000002); // enable GPIO B for LEDs
 80002f6:	4b10      	ldr	r3, [pc, #64]	; (8000338 <main+0x48>)
 80002f8:	681b      	ldr	r3, [r3, #0]
 80002fa:	4a0f      	ldr	r2, [pc, #60]	; (8000338 <main+0x48>)
 80002fc:	f043 0302 	orr.w	r3, r3, #2
 8000300:	6013      	str	r3, [r2, #0]
  gpio_set_mode('B', 7, GPIO_MODE_OUTPUT); // PB7 is blue LED
 8000302:	2201      	movs	r2, #1
 8000304:	2107      	movs	r1, #7
 8000306:	2042      	movs	r0, #66	; 0x42
 8000308:	f7ff ff6a 	bl	80001e0 <gpio_set_mode>

  int on = 1;
 800030c:	2301      	movs	r3, #1
 800030e:	607b      	str	r3, [r7, #4]
  for(;;){
    if(stexpired(1000)){
 8000310:	f44f 707a 	mov.w	r0, #1000	; 0x3e8
 8000314:	f7ff ffb8 	bl	8000288 <stexpired>
 8000318:	4603      	mov	r3, r0
 800031a:	2b00      	cmp	r3, #0
 800031c:	d0f8      	beq.n	8000310 <main+0x20>
      gpio_write('B', 7, on);
 800031e:	687a      	ldr	r2, [r7, #4]
 8000320:	2107      	movs	r1, #7
 8000322:	2042      	movs	r0, #66	; 0x42
 8000324:	f7ff ff8e 	bl	8000244 <gpio_write>
      on = !on;
 8000328:	687b      	ldr	r3, [r7, #4]
 800032a:	2b00      	cmp	r3, #0
 800032c:	bf0c      	ite	eq
 800032e:	2301      	moveq	r3, #1
 8000330:	2300      	movne	r3, #0
 8000332:	b2db      	uxtb	r3, r3
 8000334:	607b      	str	r3, [r7, #4]
    if(stexpired(1000)){
 8000336:	e7eb      	b.n	8000310 <main+0x20>
 8000338:	40023830 	.word	0x40023830

0800033c <timerinit>:
  return 0;
}

void
timerinit(void)
{
 800033c:	b480      	push	{r7}
 800033e:	af00      	add	r7, sp, #0
  *(SYS_CSR) |= (0x00000007); // enable CLKSOURCE, TICKINT, ENABLE
 8000340:	4b0b      	ldr	r3, [pc, #44]	; (8000370 <timerinit+0x34>)
 8000342:	681b      	ldr	r3, [r3, #0]
 8000344:	4a0a      	ldr	r2, [pc, #40]	; (8000370 <timerinit+0x34>)
 8000346:	f043 0307 	orr.w	r3, r3, #7
 800034a:	6013      	str	r3, [r2, #0]
  // default systick is generated by HSI RC oscillator with 16MHz
  // at here, let's set RVR to 1ms. That means _systick_handler will
  // be triggered every 1ms
  *(SYS_RVR) = (16000000 / 1000) - 1;
 800034c:	4b09      	ldr	r3, [pc, #36]	; (8000374 <timerinit+0x38>)
 800034e:	f643 627f 	movw	r2, #15999	; 0x3e7f
 8000352:	601a      	str	r2, [r3, #0]
  *(SYS_CVR) = 0;
 8000354:	4b08      	ldr	r3, [pc, #32]	; (8000378 <timerinit+0x3c>)
 8000356:	2200      	movs	r2, #0
 8000358:	601a      	str	r2, [r3, #0]
  *(RCC_APB2ENR) |= (1U << 14); // enable SYSCFGEN
 800035a:	4b08      	ldr	r3, [pc, #32]	; (800037c <timerinit+0x40>)
 800035c:	681b      	ldr	r3, [r3, #0]
 800035e:	4a07      	ldr	r2, [pc, #28]	; (800037c <timerinit+0x40>)
 8000360:	f443 4380 	orr.w	r3, r3, #16384	; 0x4000
 8000364:	6013      	str	r3, [r2, #0]
}
 8000366:	bf00      	nop
 8000368:	46bd      	mov	sp, r7
 800036a:	bc80      	pop	{r7}
 800036c:	4770      	bx	lr
 800036e:	bf00      	nop
 8000370:	e000e010 	.word	0xe000e010
 8000374:	e000e014 	.word	0xe000e014
 8000378:	e000e018 	.word	0xe000e018
 800037c:	40023844 	.word	0x40023844

08000380 <_reset>:

// Startup code
__attribute__((naked, noreturn)) void _reset(void)
{
  for(int *dst = &_sbss; dst < &_ebss; dst++) *dst = 0;
 8000380:	4c0b      	ldr	r4, [pc, #44]	; (80003b0 <_reset+0x30>)
 8000382:	e002      	b.n	800038a <_reset+0xa>
 8000384:	2300      	movs	r3, #0
 8000386:	6023      	str	r3, [r4, #0]
 8000388:	3404      	adds	r4, #4
 800038a:	4b0a      	ldr	r3, [pc, #40]	; (80003b4 <_reset+0x34>)
 800038c:	429c      	cmp	r4, r3
 800038e:	d3f9      	bcc.n	8000384 <_reset+0x4>

  for(int *dst = &_sdata, *src = &_sidata; dst < &_edata; dst++, src++)
 8000390:	4c09      	ldr	r4, [pc, #36]	; (80003b8 <_reset+0x38>)
 8000392:	4d0a      	ldr	r5, [pc, #40]	; (80003bc <_reset+0x3c>)
 8000394:	e003      	b.n	800039e <_reset+0x1e>
    *dst = *src;
 8000396:	682b      	ldr	r3, [r5, #0]
 8000398:	6023      	str	r3, [r4, #0]
  for(int *dst = &_sdata, *src = &_sidata; dst < &_edata; dst++, src++)
 800039a:	3404      	adds	r4, #4
 800039c:	3504      	adds	r5, #4
 800039e:	4b08      	ldr	r3, [pc, #32]	; (80003c0 <_reset+0x40>)
 80003a0:	429c      	cmp	r4, r3
 80003a2:	d3f8      	bcc.n	8000396 <_reset+0x16>
  
  timerinit();
 80003a4:	f7ff ffca 	bl	800033c <timerinit>
  main();
 80003a8:	f7ff ffa2 	bl	80002f0 <main>
  for(;;);
 80003ac:	e7fe      	b.n	80003ac <_reset+0x2c>
 80003ae:	bf00      	nop
 80003b0:	20010000 	.word	0x20010000
 80003b4:	20010008 	.word	0x20010008
 80003b8:	20010000 	.word	0x20010000
 80003bc:	080003e0 	.word	0x080003e0
 80003c0:	20010000 	.word	0x20010000

080003c4 <_systick_handler>:
}

void _systick_handler(void)
{
 80003c4:	b480      	push	{r7}
 80003c6:	af00      	add	r7, sp, #0
  _sticks++;
 80003c8:	4b04      	ldr	r3, [pc, #16]	; (80003dc <_systick_handler+0x18>)
 80003ca:	681b      	ldr	r3, [r3, #0]
 80003cc:	3301      	adds	r3, #1
 80003ce:	4a03      	ldr	r2, [pc, #12]	; (80003dc <_systick_handler+0x18>)
 80003d0:	6013      	str	r3, [r2, #0]
}
 80003d2:	bf00      	nop
 80003d4:	46bd      	mov	sp, r7
 80003d6:	bc80      	pop	{r7}
 80003d8:	4770      	bx	lr
 80003da:	bf00      	nop
 80003dc:	20010000 	.word	0x20010000
