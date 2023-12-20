static inline uint32
r_sp()
{
  uint32 x;
  asm volatile("mrs %0, sp" : "=r" (x) );
  return x;
}

static inline uint32
r_psp()
{
  uint32 x;
  asm volatile("mrs %0, psp" : "=r" (x) );
  return x;
}
