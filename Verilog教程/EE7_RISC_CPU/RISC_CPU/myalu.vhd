library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity myalu is
port(alu_clk : in std_logic;
     accum,data : in std_logic_vector(7 downto 0);
	  opcode : in std_logic_vector(4 downto 0);
	  data_specical : in std_logic_vector(10 downto 0);
	  zero : out std_logic;
	  alu_out: out std_logic_vector(7 downto 0));
end myalu;
architecture behav of myalu is
begin
zero<='1' when accum="00000000" else
      '0' ;
process(alu_clk)
begin
if (rising_edge(alu_clk)) then
case opcode is
when "00000"=>alu_out<=accum;--HLT
when "00010"=>alu_out<=accum;--SKZ
when "00100"=>alu_out<=data+accum;--ADD
when "00110"=>alu_out<=data and accum;--ANDD
when "01000"=>alu_out<=data xor accum;--XORR
when "01010"=>alu_out<=data;--LDA
when "01100"=>alu_out<=accum;--STO
when "01110"=>alu_out<=accum;--JMP
-------------------------------------------------------------
--when "00001"=>alu_out<=accum;--HLT#
--when "00011"=>alu_out<=accum;--SKZ#
when "00101"=>alu_out<=data_specical(7 downto 0)+accum;--ADD#
when "00111"=>alu_out<=data_specical(7 downto 0) and accum;--ANDD#
when "01001"=>alu_out<=data_specical(7 downto 0) xor accum;--XORR#
when "01011"=>alu_out<=data_specical(7 downto 0);--LDA#
--when "01101"=>alu_out<=accum;--STO#
--when "01111"=>alu_out<=accum;--JMP#
---------------------------------------------------------------
when "10000"=>alu_out<=accum(6 downto 0) & '0';--SLL
when "10010"=>alu_out<='0' & accum(7 downto 1);--SRL
when "10100"=>alu_out<=accum(6 downto 0) & accum(7);--ROL
when "10110"=>alu_out<=accum(0) & accum(7 downto 1);--ROR
when "11000"=>alu_out<=conv_std_logic_vector(conv_integer(accum)*conv_integer(data),8);--*
when "11010"=>alu_out<=conv_std_logic_vector(conv_integer(accum)/conv_integer(data),8);--/
when "11100"=>alu_out<=accum-data;--SUB
when "11110"=>alu_out<=not accum;--NOT
----------------------------------------------------------------
--when "10001"=>alu_out<=accum(6 downto 0) & '0';--SLL#
--when "10011"=>alu_out<='0' & accum(7 downto 1);--SRL#
--when "10101"=>alu_out<=accum(6 downto 0) & accum(7);--ROL#
--when "10111"=>alu_out<=accum(7) & accum(6 downto 0);--ROR#
when "11001"=>alu_out<=conv_std_logic_vector(conv_integer(accum)*conv_integer(data_specical(7 downto 0)),8);--*#
when "11011"=>alu_out<=conv_std_logic_vector(conv_integer(accum)/conv_integer(data_specical(7 downto 0)),8);--/#
when "11101"=>alu_out<=accum-data_specical(7 downto 0);--SUB#
--when "11111"=>alu_out<=not accum;--NOT#
when others => alu_out<="XXXXXXXX";
end case;
end if;
end process;
end behav;
