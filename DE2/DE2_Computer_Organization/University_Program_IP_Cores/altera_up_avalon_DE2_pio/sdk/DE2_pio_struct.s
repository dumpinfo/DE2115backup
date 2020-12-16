; ----------------------------------------------
; PIO Peripheral
;
	;
	; PIO Registers
	;
	.equ np_DE2_piodata,          0 ; read/write, up to 32 bits
	.equ np_DE2_piodirection,     1 ; write/readable, up to 32 bits, 1->output bit
	.equ np_DE2_piointerruptmask, 2 ; write/readable, up to 32 bits, 1->enable interrupt
	.equ np_de2_pioedgecapture,   3 ; read, up to 32 bits, cleared by any write.

