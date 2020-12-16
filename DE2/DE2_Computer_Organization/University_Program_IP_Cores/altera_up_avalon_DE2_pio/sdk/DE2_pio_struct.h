// DE2 PIO Peripheral

// DE2 PIO Registers
typedef volatile struct
	{
	int np_DE2_piodata;          // read/write, up to 32 bits
	int np_DE2_piodirection;     // write/readable, up to 32 bits, 1->output bit
	int np_DE2_piointerruptmask; // write/readable, up to 32 bits, 1->enable interrupt
	int np_DE2_pioedgecapture;   // read, up to 32 bits, cleared by any write
	} np_DE2_pio;

// PIO Routines
//void nr_DE2_pio_showhex(int value); // shows low byte on pio named na_seven_seg_pio

