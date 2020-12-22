LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
entity machine is
	port(clk1: in std_logic;					--the clock of cpu
		zero: in std_logic;						--data of acc is zero
		ena: in std_logic;						--enable port
		opcode: in std_logic_vector(4 downto 0);--operation code
		inc_pc:out std_logic;					--increase pc point
		load_acc: out std_logic;				--acc output enable
		load_pc: out std_logic;					--pc point load
		rd:out std_logic;						--read from ROM
		wr:out std_logic;						--write to RAM
		load_ir:out std_logic;					--load target address
		datactl_ena:out std_logic;				--data out enable
		halt:out std_logic);					--halt code
end machine;
architecture behav of machine is
begin 

main:process(clk1,zero,ena,opcode)
	type state_type is (clk_0,clk_1,clk_2,clk_3,clk_4,clk_5,clk_6,clk_7);
	--define eight state represent for eight clocks
	variable state:state_type;
	--define eight codes using constant standard logic
	constant HLT:std_logic_vector:= "00000";
	constant SKZ:std_logic_vector:= "00010";
	constant ADD:std_logic_vector:= "00100";
	constant ANDD:std_logic_vector:="00110";
	constant XORR:std_logic_vector:="01000";
	constant LDA:std_logic_vector:= "01010";
	constant STO:std_logic_vector:= "01100";
	constant JMP:std_logic_vector:= "01110";
	--------------------------------------------------
	--constant HLT_1:std_logic_vector:= "00001";
	--constant SKZ_1:std_logic_vector:= "00011";
	constant ADD_1:std_logic_vector:= "00101";
	constant ANDD_1:std_logic_vector:="00111";
	constant XORR_1:std_logic_vector:="01001";
	constant LDA_1:std_logic_vector:= "01011";
	--constant STO_1:std_logic_vector:= "01101";
	--constant JMP_1:std_logic_vector:= "01111";
	---------------------------------------------------
	constant SLLL:std_logic_vector:= "10000";
	constant SRLL:std_logic_vector:= "10010";
	constant ROLL:std_logic_vector:= "10100";
	constant RORR:std_logic_vector:="10110";
	constant MUL:std_logic_vector:="11000";
	constant DIV:std_logic_vector:= "11010";
	constant SUB:std_logic_vector:= "11100";
	constant NOTT:std_logic_vector:= "11110";
   -------------------------------------------------------
	--constant SLLL_1:std_logic_vector:= "10001";
	--constant SRLL_1:std_logic_vector:= "10011";
	--constant ROLL_1:std_logic_vector:= "10101";
	--constant RORR_1:std_logic_vector:="10111";
	constant MUL_1:std_logic_vector:="11001";
	constant DIV_1:std_logic_vector:= "11011";
	constant SUB_1:std_logic_vector:= "11101";
	--constant NOTT_1:std_logic_vector:= "11111";
	-----------------------------------------------------------
	begin
	if(clk1'event and clk1='0')then				--the negative edge of clock
		if(ena='0')then							--state loop enable
			state:=clk_0;
			inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
			wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';--initialize; 
		else
			case state is
			--load the high 8bits instruction
			when clk_0 =>						--the zreoth clock
				inc_pc<='0';load_acc<='0';load_pc<='0';rd<='1';--read from ROM
				wr<='0';load_ir<='1';datactl_ena<='0';halt<='0';
					state:=clk_1;
			--pc increase then load low 8bits instruction
			when clk_1 =>						--the first clock
					inc_pc<='1';load_acc<='0';load_pc<='0';rd<='1';
					--pc increase ,read from ROM
					wr<='0';load_ir<='1';datactl_ena<='0';halt<='0';
					--load the target pc point
					state:=clk_2;
			--idle
			when clk_2 =>						--the second clock
				inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
				wr<='0';load_ir<='0';datactl_ena<='0';halt<='0'; 
					state:=clk_3;
			--the instruction of the halt code
			when clk_3 =>						--the third clock
					if(opcode=HLT)then
						inc_pc<='1';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='1';
					else 
						inc_pc<='1';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0'; 
					end if;
					state:=clk_4;
			--other code instruction
			when clk_4 =>						--the forth clock
					if(opcode=JMP)then
						inc_pc<='0';load_acc<='0';load_pc<='1';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					elsif(opcode=ADD or opcode=ANDD or opcode=XORR or opcode=LDA
					      or opcode=ADD_1 or opcode=ANDD_1 or opcode=XORR_1 or opcode=LDA_1 
                     or opcode=MUL or opcode=DIV or opcode=SUB or opcode=NOTT 						
							or opcode=MUL_1 or opcode=DIV_1 or opcode=SUB_1
                     or opcode=SLLL or opcode=SRLL or opcode=ROLL or opcode=RORR	 )then
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='1';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					elsif(opcode=STO)then
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='1';halt<='0';
					else 
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					end if;
					state:=clk_5;
			when clk_5 =>						--the fifth clock
					if(opcode=ADD or opcode=ANDD or opcode=XORR or opcode=LDA
					      or opcode=ADD_1 or opcode=ANDD_1 or opcode=XORR_1 or opcode=LDA_1 
                     or opcode=MUL or opcode=DIV or opcode=SUB or opcode=NOTT 							
							or opcode=MUL_1 or opcode=DIV_1 or opcode=SUB_1
                     or opcode=SLLL or opcode=SRLL or opcode=ROLL or opcode=RORR	)then
						inc_pc<='0';load_acc<='1';load_pc<='0';rd<='1';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					elsif(opcode=SKZ and zero='1')then
						inc_pc<='1';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					elsif(opcode=JMP)then
						inc_pc<='1';load_acc<='0';load_pc<='1';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					elsif(opcode=STO)then
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
						wr<='1';load_ir<='0';datactl_ena<='1';halt<='0';
					else 
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					end if;
					state:=clk_6;
			when clk_6 =>						--the sixth clock
					if(opcode=STO)then
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='1';halt<='0';
						--output the data
					elsif(opcode=ADD or opcode=ANDD or opcode=XORR or opcode=LDA
					      or opcode=ADD_1 or opcode=ANDD_1 or opcode=XORR_1 or opcode=LDA_1 
                     or opcode=MUL or opcode=DIV or opcode=SUB or opcode=NOTT 							
							or opcode=MUL_1 or opcode=DIV_1 or opcode=SUB_1
                     or opcode=SLLL or opcode=SRLL or opcode=ROLL or opcode=RORR	 
					)then
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='1';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					else 
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					end if;
					state:=clk_7;
			when clk_7 =>						--the seventh clock
					if(opcode=SKZ and zero='1')then
						inc_pc<='1';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					else 
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					end if;
					state:=clk_0;
			when others =>						--for other state(s)
						inc_pc<='0';load_acc<='0';load_pc<='0';rd<='0';
						wr<='0';load_ir<='0';datactl_ena<='0';halt<='0';
					state:=clk_0;
			end case;
		end if;
	else null;
	end if;
end process main;

end behav;
