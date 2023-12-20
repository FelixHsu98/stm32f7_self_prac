#define MAX_PROC_NUM	2
#define USTACK_SIZE	(4096 / 32)

#define THREAD_PSP	0xFFFFFFFD


enum procstate {UNUSED, RUNNABLE, RUNNING};

struct proc{
  int  pid;			// process id
  enum procstate state;		// process state
  uint32 sp;			// process stack pointer
};
