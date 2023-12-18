struct gpio {
  uint32 moder;
  uint32 otyper;
  uint32 ospeedr;
  uint32 pupdr;
  uint32 idr;
  uint32 odr;
  uint32 bsrr;
  uint32 lckr;
  uint32 afr[2]; //[0]afrl [1]afrh
};

typedef enum
{
  GPIO_MODE_INPUT,
  GPIO_MODE_OUTPUT, 
  GPIO_MODE_AF,
  GPIO_MODE_ANALOG
} gmode_t;

static inline void
gpio_set_mode(char port, int pin, gmode_t gpio_mode)
{
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
  pin &= 0xF;

  *(RCC_AHB1ENR) |= (1U << (port - 'A'));
  gp->moder &= ~(0x3 << (pin * 2)); // clear previos
  gp->moder |= ((gpio_mode & 0x3) << (pin * 2)); // set mode 
}

static inline void
gpio_set_af(char port, int pin, int af)
{
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
  pin &= 0xF;

  // afr[0] control pin 0~7, afr[1] for pin 8~15
  // so pin num shall masked by 7 when above 8
  gp->afr[pin >> 3] &= ~(0xF << ((pin & 0x7) * 4)); // clear
  gp->afr[pin >> 3] |= (af << ((pin & 0x7) * 4));   // set
}

static inline void
gpio_write(char port, int pin, int val)
{
  volatile struct gpio *gp = (volatile struct gpio *)GPIOX(port);
  gp->bsrr = (1U << pin) << (val ? 0 : 16);
}

//static inline void
//spin(volatile uint32 cnt)
//{
//  while(cnt != 0)
//    cnt--;
//}
