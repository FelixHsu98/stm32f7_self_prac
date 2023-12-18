struct uart;

// uart.c
void uartinit(struct uart *up, uint32 baud);
void uartwrite(struct uart *up, char *buf, uint32 len);
void uartread(struct uart *up, char *buf, uint32 len);

// swtch.S
void swtch(uint32 ustack);
void syscall(void);
