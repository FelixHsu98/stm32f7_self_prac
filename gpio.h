struct gpio {
  uint32 moder;
  uint32 otyper;
  uint32 ospeedr;
  uint32 pupdr;
  uint32 idr;
  uint32 odr;
  uint32 bsrr;
  uint32 lckr;
  uint32 afrl;
  uint32 afrh;
};

//#define GPIO_MODE_INPUT		0
//#define GPIO_MODE_OUTPUT	1
//#define GPIO_MODE_AF		2
//#define GPIO_MODE_ANALOG	3

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
  gp->moder &= ~(0x3 << (pin * 2)); // clear previos
  gp->moder |= ((gpio_mode & 0x3) << (pin * 2)); // set mode 
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
