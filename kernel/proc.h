#define MAX_PROC_NUM	2
#define USTACK_SIZE	(4096 / 32)

#define THREAD_PSP	0xFFFFFFFD

struct context {
  /* 00 */uint32 r4;
  /* 04 */uint32 r5;
  /* 08 */uint32 r6;
  /* 12 */uint32 r7;
  /* 16 */uint32 r8;
  /* 20 */uint32 r9;
  /* 24 */uint32 r10;
  /* 28 */uint32 r11;
  /* 32 */uint32 r12;
  /* 36 */uint32 sp;
  /* 40 */uint32 lr;

  /* 44 */uint32 kernel_sp;  		// process's kernel stack
};

struct cpu {
  struct proc *proc;		// running process
  struct context context;	// swtch() here to get into kernel
}; 

enum procstate {UNUSED, RUNNABLE, RUNNING};

struct proc {
  int  pid;			// process id
  enum procstate state;		// process state
  struct context context;	// context switch context
  uint32 exceret;		// EXCE_RETURN for first jumping into userp stack
};
