typedef volatile uint32 reg_t;

/* GPIOX memory layout */
#define GPIOA		((reg_t) 0x40020000)

#define GSHIFT(x)	((x - 'A') * 0x400) // move to right GPIO port
#define GPIOX(x)	((reg_t) GPIOA + GSHIFT(x))

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

/* USART layout */
#define USART1		((reg_t) 0x40011000)
#define USART2		((reg_t) 0x40004400)
#define USART3		((reg_t) 0x40004800)
#define UART4		((reg_t) 0x40004C00)
#define UART5		((reg_t) 0x40005000)
#define USART6		((reg_t) 0x40011400)
#define UART7		((reg_t) 0x40007800)
#define UART8		((reg_t) 0x40007C00)

#define FREQ		(16000000) // HSI clock
/* This part are core perihperal registers*/
/* System timer */
#define SYS_CSR		((reg_t *) (0xE000E010))
#define SYS_RVR		((reg_t *) (0xE000E014))
#define SYS_CVR		((reg_t *) (0xE000E018))
#define SYS_CALIB	((reg_t *) (0xE000E01C))
/* System control block */
#define SYS_ICSR	((reg_t *) (0xE000ED04))  // set interrupt pending
#define SYS_SHPR1	((reg_t *) (0xE000ED18))  // set handler priority
#define SYS_SHPR2	((reg_t *) (0xE000ED1C))
#define SYS_SHPR3	((reg_t *) (0xE000ED20))
#define PENDSVSET	((reg_t)   (1 << 28))	  // trigger PendSV bit
#define PENDSVPRI	((reg_t)   (0x00FF0000))  // PendSV priority
