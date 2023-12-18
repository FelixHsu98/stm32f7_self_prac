.thumb
.syntax unified

.type svc_handler, %function
.global svc_handler
svc_handler:
	mrs r0, psp
	stmdb r0!, {r4-r10, fp, lr}

	mov r0, #0
	msr control, r0

	#pop {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	pop {r4-r10, fp, ip, lr}

	bx lr

.global swtch
swtch:
	/* save kernel state into main stack */
	mrs ip, psr
	push {r4-r10, fp, ip, lr}
	
	/* switch to process stack */
	msr psp, a1
	mov a1, #3
	msr control, a1

	/* restore process stack to finish switching */
	pop {r4, r5, r6, r7, r8, r9, r10, fp, lr}

	/* return to address lr */
	bx lr
