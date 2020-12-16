module top(CLOCK_50,KEY,AUD_ADCDAT,AUD_BCLK,AUD_DACLRCK,AUD_ADCLRCK,I2C_SDAT,I2C_SCLK,AUD_DACDAT,KEYON,AUD_XCK);
input CLOCK_50;
input [1:0] KEY;
input AUD_ADCDAT;
input AUD_BCLK;
input AUD_DACLRCK;
input AUD_ADCLRCK;


output I2C_SDAT;
output I2C_SCLK;
output AUD_DACDAT;
output AUD_XCK;
output KEYON;

wire END;
wire CLOCK_500;
wire GO;

wire [23:0] DATA;

wire ACK;
wire [5:0] SD_COUNTER;
wire SDO;

wire AUD_DACDAT=AUD_ADCDAT;

CLOCK_500 CLK (.CLOCK(CLOCK_50),
 	            .CLOCK_500(CLKOCK_500),
	            .DATA(DATA),
	            .END(END),
	            .RESET(KEYON),
	            .GO(GO),
	            .CLOCK_2(AUD_XCK)
					);
					
i2c I2C (			 .CLOCK(CLKOCK_500),
			 .I2C_SCLK(I2C_SCLK),		//I2C CLOCK
			 .I2C_SDAT(I2C_SDAT),		//I2C DATA
			 .I2C_DATA(DATA),		//DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
			 .GO(GO),      		//GO transfor
			 .END(END),    	    //END transfor 
			 //.W_R,     		//W_R
			 .ACK(ACK),     	    //ACK
			 .RESET(1'b1),
			 //TEST
			 .SD_COUNTER(SD_COUNTER),
			 .SDO(SDO));

keytr key(				.key(KEY[0]),
				.key1(KEY[1]),
				.ON,
				.clock(CLOCK_500),
				.KEYON(KEYON),
				.counter(counter)	
				);

endmodule