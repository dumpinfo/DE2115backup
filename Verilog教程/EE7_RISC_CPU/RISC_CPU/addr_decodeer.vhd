library ieee;
use ieee.std_logic_1164.all;
entity addr_decodeer is
port(addrin : in std_logic_vector(10 downto 0);
	  addrout : out std_logic_vector(9 downto 0);
     rom_sel,ram_sel : out std_logic);
end addr_decodeer;
architecture behav of addr_decodeer is
begin
addrout<=addrin(9 downto 0);
process(addrin)
begin
case addrin(10) is
when '0'=>
rom_sel<='1';ram_sel<='0';
when '1'=>
rom_sel<='0';ram_sel<='1';
when others =>
rom_sel<='0';ram_sel<='0';
end case;
end process;
end behav;