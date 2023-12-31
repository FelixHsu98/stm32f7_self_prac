#include "type.h"
#include "proc.h"
#include "defs.h"
#include "arm.h"

static struct cpu cpu;

static struct proc proc[MAX_PROC_NUM];

static uint32 userstack[MAX_PROC_NUM][USTACK_SIZE];
static uint32 ukstack[MAX_PROC_NUM][USTACK_SIZE];

static int nextpid = 1;

static struct {
  struct proc *freelist[MAX_PROC_NUM + 1];  // proc in runnable circular queue
  int tail;  // push in used ptr
  int head;  // pop out used ptr
} procs;

void
procinit(void)
{
  uint32 empty[32];
  procinit_env(empty+32);
}

struct cpu*
mycpu()
{
  return &cpu;
} 

struct proc*
myproc()
{ 
  struct cpu *c = mycpu();
  return c->proc;
}

static void
push_in(struct proc *p)
{
  if(p->state == RUNNABLE){
    procs.tail = (procs.tail+1) % (MAX_PROC_NUM+1);
    procs.freelist[procs.tail] = p;
  }
}

// release process from executing state
void
yield()
{
  struct cpu *c = mycpu();
  struct proc *p = myproc();

  // set state to runnable and add into freelist
  p->state = RUNNABLE;
  push_in(p);

  // switch back to kernel
  swtch(&p->context, &c->context);
}

// determine a another process to run
void
sched()
{
  struct cpu *c = mycpu();
  struct proc *p;
  
  // pop out runnable state process
  procs.head = (procs.head + 1) % (MAX_PROC_NUM + 1);
  p = procs.freelist[procs.head];

  // change state to running
  p->state = RUNNING;
  c->proc = p;

  // swtch
  swtch(&c->context, &p->context);
}

static int
allocpid()
{
  int pid = nextpid;
  nextpid++;
  return pid;
}

// Create user process
struct proc*
allocproc(void (* func)(void))
{  
  struct proc *p;
  uint32 *ustack, *kstack;

  ustack = (uint32 *)userstack[0];
  kstack = (uint32 *)ukstack[0];
  // search free pcb block for a new process
  for(p = proc; p < &proc[MAX_PROC_NUM]; p++, ustack += USTACK_SIZE, kstack += USTACK_SIZE){
    if(p->state == UNUSED)
      break; 
  }
  if(p == (proc + MAX_PROC_NUM)) return 0;
  
  ustack += USTACK_SIZE - 8;
  kstack += USTACK_SIZE;
  // low |_,_,_,_,_,_,_,_| high total 8
  //     0 1 2 3 4 5 6 7 8  
  // when svc called xPSR, PC, LR, R12, R3, R2, R1, R0
  // automatically pushed by hardware are called exception
  // entry sequence. When exiting exception handler, LR
  // need to be EXC_RETURN after pop among swtch(). So
  // stack[0] to [7] for unstacking in the exception exiting
  // sequence done by hardware.
  ustack[6] = (uint32)func;		// PC
  ustack[7] = (uint32)0x01000000;	// xPSR

  p->exceret = (uint32)THREAD_PSP;
  p->context.lr = (uint32)usertrapret;
  p->context.sp = (uint32)ustack;
  p->context.kernel_sp = (uint32)kstack;

  p->state = RUNNABLE;
  p->pid = allocpid();

  push_in(p);
 
  return p;
}

// return to user process's kernel stack
// this function won't be called after first swtch() from kernel
void
usertrapret()
{
  struct proc *p = myproc();
  w_psp(p->context.sp);
  w_lr((uint32)&p->exceret);
}
