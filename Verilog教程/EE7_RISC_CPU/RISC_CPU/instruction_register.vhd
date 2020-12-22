library ieee;
use ieee.std_logic_1164.all;
entity instruction_register is
port(data: in std_logic_vector(7 downto 0);
     ena : in std_logic;
	  clk1 :in std_logic;
	  rst : in std_logic;
	  opcode : out std_logic_vector(4 downto 0);
	  ir_addr : out std_logic_vector(10 downto 0));
	  end instruction_register;
architecture behav of instruction_register is
signal state : std_logic;
begin 
process(clk1)
begin 
if(rising_edge(clk1)) then
if(rst='1')then
opcode<="00000";
ir_addr<="00000000000";
state<='0';
elsif(ena='1')then
case state is
when'0'=>
opcode<=data(7 downto 3);
ir_addr(10 downto 8)<= data(2 downto 0);
state<='1';
when'1'=>
ir_addr(7 downto 0)<=data;
state<='0';
when others=>
opcode<="XXXXX";
ir_addr<="XXXXXXXXXXX";
state<='X';
end case;
else state<='0';
end if;
end if;
end process;
end behav;