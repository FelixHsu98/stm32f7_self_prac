asm void  svc_handler_wrapper(void)
{
	IMPORT svc_handle
	TST	LR, #4
	ITE 	EQ
	MRSEQ	R0, MSP
	MRSNE	R0, PSP
	B	svc_handler
}

void svc_handler(uint32 *svc_args)
{
    uint32 svc_number;
    uint32 svc_r0;
    uint32 svc_r1;
    uint32 svc_r2;
    uint32 svc_r3;

  svc_number = ((char *)  svc_args[6])[-2];
  svc_r0 = ((uint32)svc_args[0]);
  svc_r1 = ((uint32)svc_args[1]);
  svc_r2 = ((uint32)svc_args[2]);
  svc_r3 = ((uint32)svc_args[3]);

  return;
}
