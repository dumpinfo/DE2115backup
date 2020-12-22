library ieee;
use ieee.std_logic_1164.all;
entity machinectl is
port(ena : out std_logic;
     fetch : in std_logic;
	  rst :in std_logic);
end machinectl;
architecture behav of machinectl is
begin
process(fetch,rst)
begin 
if(rst='1') then 
ena<='0';
elsif(rising_edge(fetch)) then
ena<='1';
end if;
end process;
end behav;