.thumb
.syntax unified

.type svc_handler, %function
.global svc_handler
svc_handler:
	mrs r0, psp
	stmdb r0!, {r4-r10, fp, lr}
	msr psp, r0

	mov r0, #0
	msr control, r0

	pop {r4-r10, fp, ip, lr}
	msr psr, ip

	bx lr

.global swtch
swtch:
	/* save kernel state into main stack */
	mrs ip, psr
	push {r4-r10, fp, ip, lr}
	
	/* restore process stack to finish switching */
	ldmia r0!, {r4-r10, fp, lr}
	msr psp, r0

	/* switch to process stack */
	mov r0, #3
	msr control, r0

	/* return to address lr */
	bx lr

.global task_init_env
task_init_env:
	mrs ip, psr
	push {r4-r12, lr}

	msr psp, r0
	mov r0, #3
	msr control, r0
	isb
	bl syscall
	bx lr
