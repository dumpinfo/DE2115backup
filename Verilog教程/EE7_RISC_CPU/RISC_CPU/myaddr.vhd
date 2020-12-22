library ieee;
use ieee.std_logic_1164.all;
entity myaddr is
port (fetch : in std_logic;
     ir_addr,pc_addr : in std_logic_vector( 10 downto 0);
	  addr : out std_logic_vector(10 downto 0));
end myaddr;
architecture behav of myaddr is
begin 
addr<=ir_addr when fetch='0' else
      pc_addr when fetch='1' else
		"XXXXXXXXXXX";
end behav;
