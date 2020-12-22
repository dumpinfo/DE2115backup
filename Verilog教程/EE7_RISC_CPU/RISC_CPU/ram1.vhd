library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity ram1 is
port (rst : in std_logic;
      ena : in std_logic;
      writein,readout : in std_logic;
		data : inout std_logic_vector(7 downto 0);
		addr : in std_logic_vector(9 downto 0));
end ram1;
architecture behav of ram1 is
type ram_array is array(0 to 255) of std_logic_vector (7 downto 0);
signal  mem:ram_array;
begin 
process(readout,data,addr,ena)
begin 
if(readout='1' and ena='1') then
data<=mem(conv_integer(addr));
else
data<="ZZZZZZZZ";
end if;
end process;
process(writein,rst)
begin
if(rst='1') then
mem(0)<="00000000";--800H DATA_0;
mem(1)<="00000001";--801H DATA_1;
mem(2)<="00000010";--802H DATA_2;
mem(3)<="00000011";--803H DATA_3;
mem(4)<="00000100";--804H DATA_4;
mem(5)<="00000101";--805H DATA_5;
mem(6)<="00000110";--806H DATA_6;
mem(7)<="00000111";--807H DATA_7;
mem(8)<="00001000";--808H DATA_8;
mem(9)<="00001001";--809H DATA_9;
mem(10)<="00001010";--80aH DATA_10;
mem(11)<="11111111";--80bH DATA_11;
mem(12)<="10101010";--80cH DATA_12;
mem(13)<="01010101";--800H DATA_13;
elsif(rising_edge(writein)) then 
mem(conv_integer(addr))<=data;
end if;
end process;
end behav;