library ieee;
use ieee.std_logic_1164.all;
entity accumulator is
port(data : in std_logic_vector(7 downto 0);
     ena : in std_logic;
	  clk1: in std_logic;
	  rst : in std_logic;
	  accum : out std_logic_vector(7 downto 0));
end accumulator;
architecture behav of accumulator is
begin
process(clk1)
begin
if(rising_edge(clk1)) then
if(rst='1') then
accum<="00000000";
elsif(ena='1') then
accum<=data;
end if;
end if;
end process;
end behav;