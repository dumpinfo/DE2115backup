library ieee ;
use ieee.std_logic_1164.all;
entity clkgen is 
port(clk,reset :in std_logic;
     clk1,fetch,alu_clk: out std_logic);
end clkgen;
architecture behav of clkgen is
type my_type is (idle,c0,c1,c2,c3,c4,c5,c6,c7);
signal pr_state,next_state : my_type;
begin
 seq:process(clk)
 begin
 clk1<=not clk;
 if(falling_edge(clk)) then
 if (reset='1') then
 pr_state<=idle;
 else
 pr_state<=next_state;
 end if;
 end if;
 end process seq;
 ns:process(pr_state)
 begin 
 case pr_state is
 when c0=>next_state<=c1;
 when c1=>next_state<=c2;
 when c2=>next_state<=c3;
 when c3=>next_state<=c4;
 when c4=>next_state<=c5;
 when c5=>next_state<=c6;
 when c6=>next_state<=c7;
 when c7=>next_state<=c0;
 when idle=>next_state<=c0;
 end case;
 end process ns;
 op:process(pr_state)
 begin
case pr_state is
 when c0=>fetch<='0';alu_clk<='0';
 when c1=>fetch<='0';alu_clk<='1';
 when c2=>fetch<='0';alu_clk<='0';
 when c3=>fetch<='0';alu_clk<='0';
 when c4=>fetch<='1';alu_clk<='0';
 when c5=>fetch<='1';alu_clk<='0';
 when c6=>fetch<='1';alu_clk<='0';
 when c7=>fetch<='1';alu_clk<='0';
 when idle=>fetch<='0';alu_clk<='0';
 end case;
 end process op;
 end behav;