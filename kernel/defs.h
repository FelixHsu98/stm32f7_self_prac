struct uart;
struct proc;

// uart.c
void uartinit(struct uart *up, uint32 baud);
//void uartwrite(struct uart *up, char *buf, uint32 len);
void uartwrite(struct uart *up, char *buf);
void uartread(struct uart *up, char *buf, uint32 len);

// swtch.S
void swtch(uint32 *ustack);
void syscall(void);
void task_init_env(uint32 *stack);

// proc.c
struct proc *allocproc(uint32 *ustack, void (* func)(void));
void yield(void);
void sched(void);
