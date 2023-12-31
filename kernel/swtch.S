.thumb
.syntax unified

.type _svc_handler, %function
.global _svc_handler
_svc_handler:
	mrs r0, psp
	stmdb r0!, {r4-r11, lr}
	msr psp, r0

	pop {r4-r12, lr}
	msr psr, r12

	bx lr

.global swtch
swtch:
	/* save state into context */
	mrs r12, psr
	str r4,  [r0, #0] 
	str r5,  [r0, #4] 
	str r6,  [r0, #8] 
	str r7,  [r0, #12] 
	str r8,  [r0, #16] 
	str r9,  [r0, #20] 
	str r10, [r0, #24] 
	str r11, [r0, #28] 
	str r12, [r0, #32] 
	str lr,  [r0, #40] 
	str sp,  [r0, #44] 
	
	/* restore to finish switching */
	ldr r4,  [r1, #0] 
	ldr r5,  [r1, #4] 
	ldr r6,  [r1, #8] 
	ldr r7,  [r1, #12] 
	ldr r8,  [r1, #16] 
	ldr r9,  [r1, #20] 
	ldr r10, [r1, #24] 
	ldr r11, [r1, #28] 
	ldr r12, [r1, #32] 
	ldr lr,  [r1, #40] 
	ldr sp,  [r1, #44] 
	msr psr, r12

	/* return to address lr */
	bx lr

.global procinit_env
procinit_env:
	mrs r12, psr
	push {r4-r12, lr}

	msr psp, r0
	mov r0, #3
	msr control, r0
	isb
	bl syscall
	bx lr
