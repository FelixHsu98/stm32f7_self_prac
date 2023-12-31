struct uart;
struct proc;
struct context;

// uart.c
void uartinit(struct uart *up, uint32 baud);
void uartwrite(struct uart *up, char *buf);
void uartread(struct uart *up, char *buf, uint32 len);

// swtch.S
void swtch(struct context *, struct context *);
void syscall(void);
void procinit_env(uint32 *stack);

// proc.c
void procinit(void);
struct proc *allocproc(void (* func)(void));
void yield(void);
void sched(void);
struct proc *myproc(void);
void usertrapret(void);
