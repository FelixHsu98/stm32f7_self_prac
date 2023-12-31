static inline uint32
r_sp()
{
  uint32 x;
  asm volatile("mrs %0, sp" : "=r" (x) );
  return x;
}

static inline uint32
r_lr()
{
  uint32 x;
  asm volatile("str lr, [%0]" : "=r" (x));
  return x;
}

static inline void
w_lr(uint32 x)
{
  asm volatile("ldr lr, [%0]" : : "r" (x));
}

static inline uint32
r_psp()
{
  uint32 x;
  asm volatile("mrs %0, psp" : "=r" (x) );
  return x;
}

static inline void
w_psp(uint32 x)
{
  asm volatile("msr psp, %0" : : "r" (x));
}
