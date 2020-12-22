library ieee;
use ieee.std_logic_1164.all;
entity datactl is
port(in_alu_out : in std_logic_vector(7 downto 0);
     data_ena : in std_logic;
	  data : out std_logic_vector(7 downto 0));
end datactl;
architecture behav of datactl is
begin
 data<=in_alu_out when data_ena='1' else
 "ZZZZZZZZ";
end behav;