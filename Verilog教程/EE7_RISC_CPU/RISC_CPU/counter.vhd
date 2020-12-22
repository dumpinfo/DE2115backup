library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity counter is
port(load,clk,rst : in std_logic;
     ir_addr : in std_logic_vector(10 downto 0);
	  pc_addr : buffer std_logic_vector(10 downto 0));
end counter;
architecture behav of counter is
begin
process(clk,rst)
begin
if(rst='1') then
pc_addr<="00000000000";
elsif(rising_edge(clk)) then
if(load='1') then
pc_addr<=ir_addr;
else
pc_addr<=pc_addr+1;
end if;
end if;
end process;
end behav;