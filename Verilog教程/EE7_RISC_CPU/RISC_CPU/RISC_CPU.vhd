library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity RISC_CPU is
port(clk,reset :in std_logic;
     data : inout std_logic_vector(7 downto 0);
	  rd,wr,halt : out std_logic;
	  addr: buffer std_logic_vector(10 downto 0));
end RISC_CPU;
architecture instru of RISC_CPU is
component clkgen is
port(clk,reset :in std_logic;
     clk1,fetch,alu_clk: out std_logic);
end component;
component instruction_register is
port(data: in std_logic_vector(7 downto 0);
     ena : in std_logic;
	  clk1 :in std_logic;
	  rst : in std_logic;
	  opcode : out std_logic_vector(4 downto 0);
	  ir_addr : out std_logic_vector(10 downto 0));
end component;
component accumulator is
port(data : in std_logic_vector(7 downto 0);
     ena : in std_logic;
	  clk1: in std_logic;
	  rst : in std_logic;
	  accum : out std_logic_vector(7 downto 0));
end component;
component myalu is
port(alu_clk : in std_logic;
     accum,data : in std_logic_vector(7 downto 0);
	  opcode : in std_logic_vector(4 downto 0);
	  data_specical : in std_logic_vector(10 downto 0);
	  zero : out std_logic;
	  alu_out: out std_logic_vector(7 downto 0));
end component;
component machinectl is
port(ena : out std_logic;
     fetch : in std_logic;
	  rst :in std_logic);
end component;
component machine is
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
end component;
component myaddr is
port (fetch : in std_logic;
     ir_addr,pc_addr : in std_logic_vector( 10 downto 0);
	  addr : out std_logic_vector(10 downto 0));
end component;
component counter is
port(load,clk,rst : in std_logic;
     ir_addr : in std_logic_vector(10 downto 0);
	  pc_addr : buffer std_logic_vector(10 downto 0));
end component;
component datactl is
port(in_alu_out : in std_logic_vector(7 downto 0);
     data_ena : in std_logic;
	  data : out std_logic_vector(7 downto 0));
end component;
--------------------------------------------------------------
signal carry_clk1,carry_fetch,carry_alu_clock : std_logic;
signal carry_zero,carry_machine_ena : std_logic;
signal carry_inc_pc,carry_load_acc,carry_load_pc : std_logic;
signal carry_load_ir,carry_datactl_ena : std_logic;
signal carry_opcode : std_logic_vector(4 downto 0);
signal carry_ir_addr : std_logic_vector(10 downto 0);
signal carry_alu_out : std_logic_vector(7 downto 0);
signal carry_accum : std_logic_vector( 7 downto 0);
signal carry_pc_addr : std_logic_vector( 10 downto 0);
signal carry_specicaldata : std_logic_vector( 10 downto 0);
begin
U0:clkgen  port map(clk,reset,carry_clk1,carry_fetch,carry_alu_clock);
U1:instruction_register port map(data,carry_load_ir,carry_clk1,reset,carry_opcode,carry_ir_addr);
U2:accumulator port map (carry_alu_out,carry_load_acc,carry_clk1,reset,carry_accum);
U3:myalu port map(carry_alu_clock,carry_accum,data,carry_opcode,addr,carry_zero,carry_alu_out);
U4:machinectl port map(carry_machine_ena,carry_fetch,reset);
U5:machine port map(carry_clk1,carry_zero,carry_machine_ena,carry_opcode,carry_inc_pc,
                    carry_load_acc,carry_load_pc,rd,wr,carry_load_ir,carry_datactl_ena,halt);
U6:myaddr port map(carry_fetch,carry_ir_addr,carry_pc_addr,addr);
U7:counter port map(carry_load_pc,carry_inc_pc,reset,carry_ir_addr,carry_pc_addr);
U8:datactl port map(carry_alu_out,carry_datactl_ena,data);
end instru;
