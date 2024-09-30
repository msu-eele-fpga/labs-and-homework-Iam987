library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clockgen is
generic(
		base_period		: in std_ulogic_vector(7 downto 0) := "00000100" --Fixed point u8.4 (0.25 sec)
	);
	port(
		clk			: in std_ulogic;
		rst			: in std_ulogic;
		base_clock_half 	: inout std_ulogic;
		base_clock_quarter	: inout std_ulogic;
		base_clock_double	: inout std_ulogic;
		base_clock_eighth	: inout std_ulogic;
		base_clock_user 	: inout std_ulogic
	);
end entity;

architecture Clockgen_arch of Clockgen is
	
	signal c12, c14, c2, c18, cu : integer;
	signal basereal	: real range 0.00 to 10.00;
	
	begin
		
		basereal <= real(to_integer(unsigned(base_period))) * 0.0625;
		
		process(clk,rst) is
			begin
				if(rst = '1') then
					c12			<= 0;
					c14			<= 0;
					c2			<= 0;
					c18			<= 0;
					cu			<= 0;
					base_clock_double 	<= '0';
					base_clock_half 	<= '0';
					base_clock_quarter 	<= '0';
					base_clock_eighth 	<= '0';
					base_clock_user 	<= '0';
				elsif(rising_edge(clk)) then
					if(c12 > integer(25000000.0 * basereal * 0.5)) then
						c12 <= 0;
						base_clock_half <= not base_clock_half;
					else c12 <= c12 + 1;
					end if;
					if(c14 > integer(25000000.0 * basereal * 0.25)) then
						c14 <= 0;
						base_clock_quarter <= not base_clock_quarter;
					else c14 <= c14 + 1;
					end if;
					if(c2 > integer(25000000.0 * basereal * 2.0)) then
						c2 <= 0;
						base_clock_double <= not base_clock_double;
					else c2 <= c2 + 1;
					end if;
					if(c18 > integer(25000000.0 * basereal * 0.125)) then
						c18 <= 0;
						base_clock_eighth <= not base_clock_eighth;
					else c18 <= c18 + 1;
					end if;
					if(cu > integer(25000000.0 * basereal)) then
						cu <= 0;
						base_clock_user <= not base_clock_user;
					else cu <= cu + 1;
					end if;
				end if;
		end process;
	
end architecture;
