-------------------------------------------------------------------------------
--                                                                           --
-- Module:       Altera_UP_Avalon_to_External_Bus_Bridge                     --
-- Description:                                                              --
--      This module connects the Avalon Switch Frabic to an External Bus     --
--                                                                           --
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Altera_UP_Avalon_to_External_Bus_Bridge is
-------------------------------------------------------------------------------
--                           Generic Declarations                            --
-------------------------------------------------------------------------------
generic (
	ADDR_BITS         : integer := 18;
	DATA_BITS         : integer := 16;
	ADDR_LOW          : integer := 1;
	BYTE_EN_BITS      : integer := 2
);

-------------------------------------------------------------------------------
--                             Port Declarations                             --
-------------------------------------------------------------------------------
port (
	-- Inputs
	clk                  : in std_logic;
	reset                : in std_logic;
	avalon_address       : in std_logic_vector ((ADDR_BITS-1) downto 0);
	avalon_byteenable    : in std_logic_vector ((BYTE_EN_BITS-1) downto 0);
	avalon_chipselect    : in std_logic;
	avalon_read          : in std_logic;
	avalon_write         : in std_logic;
	avalon_writedata     : in std_logic_vector ((DATA_BITS-1) downto 0);
	acknowledge          : in std_logic;
	read_data            : in std_logic_vector ((DATA_BITS-1) downto 0);
	
	-- Bidirectionals

	-- Outputs
	avalon_readdata      : buffer std_logic_vector ((DATA_BITS-1) downto 0);
	avalon_waitrequest   : buffer std_logic;
	address              : buffer std_logic_vector (31 downto 0);
	bus_enable           : buffer std_logic;
	byte_enable          : buffer std_logic_vector ((BYTE_EN_BITS-1) downto 0);
	rw                   : buffer std_logic;
	write_data           : buffer std_logic_vector ((DATA_BITS-1) downto 0)
);
end Altera_UP_Avalon_to_External_Bus_Bridge;



architecture Altera_UP_Avalon_to_External_Bus_Bridge_rtl of Altera_UP_Avalon_to_External_Bus_Bridge is

-------------------------------------------------------------------------------
--                 Internal Wires and Registers Declarations                 --
-------------------------------------------------------------------------------
-- Internal Wires

-- Internal Registers
signal	time_out_counter     : std_logic_vector (7 downto 0);
signal 	time_out			 : std_logic;

-- State Machine Registers

begin

-------------------------------------------------------------------------------
--                         Finite State Machine(s)                           --
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--                             Sequential Logic                              --
-------------------------------------------------------------------------------

process (clk)
begin
	if  ( reset = '1') then
		avalon_readdata <= (OTHERS => '0');
	elsif clk'event and clk = '1' then
		if  acknowledge = '1' or time_out = '1' then
			avalon_readdata <= read_data ;
		end if;
	end if;
end process;

process (clk)
begin
	if  ( reset = '1') then
		address		<= (OTHERS => '0');
		bus_enable	<= '0';
		byte_enable	<= (OTHERS => '0');
		rw			<= '1';
		write_data	<= (OTHERS => '0');
	elsif clk'event and clk = '1' then
		if  ( avalon_chipselect = '1') then
			address(31 downto (32 - (ADDR_BITS+ADDR_LOW-1)) ) <= (OTHERS => '0');
			address( (ADDR_BITS+ADDR_LOW) downto (ADDR_LOW+1) ) <= avalon_address;
			address(ADDR_LOW downto 0 ) <= (OTHERS => '0');
			--address <= { { ( 32- ( ADDR_BITS+ADDR_LOW ) ) { '0'} } , avalon_address , { ADDR_LOW { '0'} } } ;
			bus_enable <= avalon_waitrequest ;
		else
			address(31 downto (32 - (ADDR_BITS+ADDR_LOW) ) ) <= (OTHERS => '1');
			address( (ADDR_BITS+ADDR_LOW) downto (ADDR_LOW+1) ) <= avalon_address;
			address(ADDR_LOW downto 0 ) <= (OTHERS => '0');
			--address <= { { ( 32- ( ADDR_BITS+ADDR_LOW ) ) { '1'} } , avalon_address , { ADDR_LOW { '0'} } } ;
			bus_enable <= bus_enable xor '1';
		end if;
		byte_enable	<= avalon_byteenable ;
		rw			<= avalon_read or not avalon_write ;
		write_data	<= avalon_writedata ;
	end if;
end process;

process (clk)
begin
	if  ( reset = '1') then
		time_out_counter <= "00000000";
	elsif clk'event and clk = '1' then
		if  ( avalon_waitrequest = '1') then
			time_out_counter <= time_out_counter + "00000001";
		else
			time_out_counter <= "00000000";
		end if;
	end if;
end process;

-------------------------------------------------------------------------------
--                            Combinational Logic                            --
-------------------------------------------------------------------------------

time_out <= '1' when time_out_counter(7 downto 0) = (7 downto 0 => '1') ELSE '0';
avalon_waitrequest <= (avalon_chipselect and (not acknowledge) and (not time_out) );

-------------------------------------------------------------------------------
--                              Internal Modules                             --
-------------------------------------------------------------------------------


end Altera_UP_Avalon_to_External_Bus_Bridge_rtl;

