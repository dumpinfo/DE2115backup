library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity rom1 is
port (ena : in std_logic;
      readout : in std_logic;
		data : out std_logic_vector(7 downto 0);
		addr : in std_logic_vector(9 downto 0));
end rom1;
architecture behav of rom1 is
type rom_array is array(0 to 1023) of std_logic_vector (7 downto 0);
signal  mem:rom_array;
begin
mem(0)<="01011100"; --00 begin:LDA# DATA_4          "00000100"
mem(1)<="00000100"; 
mem(2)<="00000000"; --02 HALT                "00100000"
mem(3)<="00000000";
process(addr,ena,readout)
begin
if(readout='1'and ena='1') then
data<=mem(conv_integer(addr));
else 
data<="ZZZZZZZZ";
end if;
end process;
end behav;