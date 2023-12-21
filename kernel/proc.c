#include "type.h"
#include "proc.h"
#include "defs.h"
#include "arm.h"

struct proc proc[MAX_PROC_NUM];

int nextpid = 1;

struct {
  struct proc *running;
  struct proc *freelist[MAX_PROC_NUM + 1];  // proc in runnable circular queue
  int tail;  // push in used ptr
  int head;  // pop out used ptr
} procs;

struct proc*
myproc()
{
  return procs.running;
}

//int
//is_full()
//{
//  return ( (procs.tail + 1) % (MAX_PROC_NUM + 1) ) == procs.head;
//}

//int
//is_empty()
//{
//  return procs.tail == procs.head;
//}

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
  struct proc *p;
  // disable interrupt

  // set state to runnable and add into freelist
  p = myproc();
  p->state = RUNNABLE;
  push_in(p);

  //if(p->pid == procs.running->pid)
  //  procs.running = 0;

  // switch back to kernel
  syscall();
}

// determine a another process to run
void
sched()
{
  struct proc *p;
  
  // update last running thread's sp
  if(procs.running != 0){
    p = procs.running;
    p->sp = r_psp();
  }
  
  // pop out runnable state process
  procs.head = (procs.head + 1) % (MAX_PROC_NUM + 1);
  p = procs.freelist[procs.head];

  // change state to running
  p->state = RUNNING;
  procs.running = p;

  // swtch
  swtch((uint32 *)p->sp);
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
allocproc(uint32 *stack, void (* func)(void))
{  
  struct proc *p;

  // low |_,_,_,_,_,_,_,_,_|_,_,_,_,_,_,_,_| high total 17
  //     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 
  // when svc called xPSR, PC, LR, R12, R3, R2, R1, R0
  // automatically pushed by hardware are called exception
  // entry sequence. When exiting exception handler, LR
  // need to be EXC_RETURN after pop among swtch(). So
  // stack[0] to [8] are used for leaving supervisor mode, 
  // and [9] to [16] for unstacking in the exception exiting
  // sequence done by hardware.
  stack += USTACK_SIZE - 17;
  stack[8] = (uint32)THREAD_PSP;
  stack[15] = (uint32)func;		// PC
  stack[16] = (uint32)0x01000000;	// xPSR

  for(p = proc; p < &proc[MAX_PROC_NUM]; p++){
    if(p->state == UNUSED)
      break; 
  }

  if(p == (proc + MAX_PROC_NUM))
    return 0;

  p->state = RUNNABLE;
  p->sp = (uint32)stack;
  p->pid = allocpid();

  push_in(p);
 
  return p;
}
