/*****************************************************************************
 *                                                                           *
 * Module:       Altera_UP_Avalon_to_External_Bus_Bridge                     *
 * Description:                                                              *
 *      This module connects the Avalon Switch Frabic to an External Bus     *
 *                                                                           *
 *****************************************************************************/

/******************************************************************************
Altera_UP_Avalon_to_External_Bus_Bridge the_Bridge (
	// Inputs
	.clk					(),
	.reset					(),

	.avalon_address			(),
	.avalon_byteenable		(),
	.avalon_chipselect		(),
	.avalon_read			(),
	.avalon_write			(),
	.avalon_writedata		(),

	.acknowledge			(),
	.read_data				(),

	// Bidirectionals

	// Outputs
	.avalon_readdata		(),
	.avalon_waitrequest		(),

	.address				(),
	.bus_enable				(),
	.byte_enable			(),
	.rw						(),
	.write_data				()
);
defparam the_Bridge.ADDR_BITS		= 18;
defparam the_Bridge.DATA_BITS		= 16;
defparam the_Bridge.ADDR_LOW		= 1;
defparam the_Bridge.BYTE_EN_BITS	= 2;
******************************************************************************/

module Altera_UP_Avalon_to_External_Bus_Bridge (
	// Inputs
	clk,
	reset,

	avalon_address,
	avalon_byteenable,
	avalon_chipselect,
	avalon_read,
	avalon_write,
	avalon_writedata,

	acknowledge,
	read_data,

	// Bidirectionals

	// Outputs
	avalon_readdata,
	avalon_waitrequest,

	address,
	bus_enable,
	byte_enable,
	rw,
	write_data
);


/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

parameter	ADDR_BITS		= 18;
parameter	DATA_BITS		= 16;

parameter	ADDR_LOW		= 1;
parameter	BYTE_EN_BITS	= 2;

//parameter	BUS_UPPER_BITS	= 12'h000;

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input								clk;
input								reset;

input		[(ADDR_BITS-1):0]		avalon_address;
input		[(BYTE_EN_BITS-1):0]	avalon_byteenable;
input								avalon_chipselect;
input								avalon_read;
input								avalon_write;
input		[(DATA_BITS-1):0]		avalon_writedata;

input								acknowledge;
input		[(DATA_BITS-1):0]		read_data;

// Bidirectionals

// Outputs
output	reg	[(DATA_BITS-1):0]		avalon_readdata;
output								avalon_waitrequest;

output	reg	[31:0]					address;
output	reg							bus_enable;
output	reg	[(BYTE_EN_BITS-1):0]	byte_enable;
output	reg							rw;
output	reg	[(DATA_BITS-1):0]		write_data;


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires

// Internal Registers
reg			[7:0]	time_out_counter;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge clk)
begin
	if (reset == 1'b1)
	begin
		avalon_readdata <= {DATA_BITS{1'b0}};
	end
	else if (acknowledge | (&(time_out_counter)))
	begin
		avalon_readdata <= read_data;
	end
end

always @(posedge clk)
begin
	if (reset == 1'b1)
	begin
		address		<= {32{1'b0}};
		bus_enable	<= 1'b0;
		byte_enable	<= {BYTE_EN_BITS{1'b0}};
		rw			<= 1'b1;
		write_data	<= {DATA_BITS{1'b0}};
	end
	else
	begin
		if (avalon_chipselect == 1'b1)
		begin
			address	<= {{(32-(ADDR_BITS+ADDR_LOW)){1'b0}}, avalon_address, 
				{ADDR_LOW{1'b0}}};
			bus_enable	<= avalon_waitrequest;
		end
		else
		begin
			address	<= {{(32-(ADDR_BITS+ADDR_LOW)){1'b1}}, avalon_address, 
				{ADDR_LOW{1'b0}}};
			bus_enable	<= bus_enable ^ 1'b1;
		end
		byte_enable	<= avalon_byteenable;
		rw			<= avalon_read | ~avalon_write;
		write_data	<= avalon_writedata;
	end
end

always @(posedge clk)
begin
	if (reset == 1'b1)
	begin
		time_out_counter <= 8'h00;
	end
	else if (avalon_waitrequest == 1'b1)
	begin
		time_out_counter <= time_out_counter + 8'h01;
	end
	else
	begin
		time_out_counter <= 8'h00;
	end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign avalon_waitrequest =
		avalon_chipselect & ~acknowledge & ~(&(time_out_counter));

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

endmodule

