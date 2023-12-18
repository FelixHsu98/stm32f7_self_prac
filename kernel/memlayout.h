typedef volatile uint32 reg_t;

/* GPIO A memory layout */
#define GPIOA		((reg_t) 0x40020000)
//#define GPIOA_MODER	((reg_t *) GPIOA + 0x00)
//#define GPIOA_OTYPER	((reg_t *) GPIOA + 0x04)
//#define GPIOA_OSPEEDR	((reg_t *) GPIOA + 0x08)
//#define GPIOA_PUPDR	((reg_t *) GPIOA + 0x0c)
//#define GPIOA_IDR	((reg_t *) GPIOA + 0x10)
//#define GPIOA_ODR	((reg_t *) GPIOA + 0x14)
//#define GPIOA_BSRR	((reg_t *) GPIOA + 0x18)
//#define GPIOA_LCKR	((reg_t *) GPIOA + 0x1c)
//#define GPIOA_AFRL	((reg_t *) GPIOA + 0x20)
//#define GPIOA_AFRH	((reg_t *) GPIOA + 0x24)

/* RCC memory layout */
#define RCC		((reg_t) 0x40023800)
#define RCC_CR		((reg_t *) (RCC + 0x00))
#define RCC_CFGR	((reg_t *) (RCC + 0x08))
#define RCC_CIR		((reg_t *) (RCC + 0x0C))
#define RCC_APB1RSTR	((reg_t *) (RCC + 0x20))
#define RCC_APB2RSTR	((reg_t *) (RCC + 0x24))
#define RCC_AHB1ENR	((reg_t *) (RCC + 0x30))
#define RCC_APB1ENR	((reg_t *) (RCC + 0x40))
#define RCC_APB2ENR	((reg_t *) (RCC + 0x44))
#define RCC_BDCR	((reg_t *) (RCC + 0x70))
#define RCC_CSR		((reg_t *) (RCC + 0x74))

/* GPIOx select */
#define GSHIFT(x)	((x - 'A') * 0x400) // move to right GPIO port
#define GPIOX(x)	((reg_t) GPIOA + GSHIFT(x))

/* SysTick memory layout */
#define SYS_CSR		((reg_t *) (0xE000E010))
#define SYS_RVR		((reg_t *) (0xE000E014))
#define SYS_CVR		((reg_t *) (0xE000E018))
#define SYS_CALIB	((reg_t *) (0xE000E01C))

/* USART layout */
#define USART1		((reg_t) 0x40011000)
#define USART2		((reg_t) 0x40004400)
#define USART3		((reg_t) 0x40004800)
#define UART4		((reg_t) 0x40004C00)
#define UART5		((reg_t) 0x40005000)
#define USART6		((reg_t) 0x40011400)
#define UART7		((reg_t) 0x40007800)
#define UART8		((reg_t) 0x40007C00)

#define FREQ		(16000000) // CPU clock
