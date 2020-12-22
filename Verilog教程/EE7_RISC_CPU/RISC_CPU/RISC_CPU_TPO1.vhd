library ieee;
use ieee.std_logic_1164.all; 
entity RISC_CPU_TPO1 is
port( clk : in std_logic;
      reset : in std_logic;     
halt : out std_logic);
end RISC_CPU_TPO1;
architecture instu of RISC_CPU_TPO1 is
component RISC_CPU is
port(clk,reset :in std_logic;
     data : inout std_logic_vector(7 downto 0);
	  rd,wr,halt : out std_logic;
	  addr: buffer std_logic_vector(10 downto 0));
end component;
component addr_decodeer is
port(addrin : in std_logic_vector(10 downto 0);
	  addrout : out std_logic_vector(9 downto 0);
     rom_sel,ram_sel : out std_logic);
end component;
component ram1 is
port (rst : in std_logic;
      ena : in std_logic;
      writein,readout : in std_logic;
		data : inout std_logic_vector(7 downto 0);
		addr : in std_logic_vector(9 downto 0));
end component;
component rom1 is
port (ena : in std_logic;
      readout : in std_logic;
		data : out std_logic_vector(7 downto 0);
		addr : in std_logic_vector(9 downto 0));
end component;
signal carry_rom_sel,carry_ram_sel : std_logic;
signal carry_write,carry_read : std_logic;
signal carry_data1 : std_logic_vector(7 downto 0);
signal carry_addr : std_logic_vector (10 downto 0);
signal carry_addrout : std_logic_vector (9 downto 0);
begin
U0:RISC_CPU port map (clk,reset,carry_data1,carry_read,carry_write,
                       halt,carry_addr);
U1:addr_decodeer port map (carry_addr,carry_addrout,carry_rom_sel,carry_ram_sel);
U2:ram1 port map (reset,carry_ram_sel,carry_write,carry_read,carry_data1,
                  carry_addrout);
U3:rom1 port map (carry_rom_sel,carry_read,carry_data1,carry_addrout);
end instu;
