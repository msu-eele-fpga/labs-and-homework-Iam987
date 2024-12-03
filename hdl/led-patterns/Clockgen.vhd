library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clockgen is
	port(
		base_period		: in std_ulogic_vector(7 downto 0);
		clk			: in std_ulogic;
		rst			: in std_ulogic;
		base_clock_half 	: inout std_ulogic;
		base_clock_quarter	: inout std_ulogic;
		base_clock_double	: inout std_ulogic;
		base_clock_eighth	: inout std_ulogic;
		base_clock_user 	: inout std_ulogic;
		base_clock		: inout std_ulogic
	);
end entity;

architecture Clockgen_arch of Clockgen is
	
	signal c12, c14, c2, c18, cu, cb : integer;
	constant sysclockrate : unsigned(24 downto 0)	:= "1011111010111100001000000";
	signal baseclk : unsigned(32 downto 0);
	
	begin
		
		baseclk <= shift_right(sysclockrate * unsigned(base_period),4);
		
		process(clk,rst) is
			begin
				if(rst = '1') then
					c12			<= 0;
					c14			<= 0;
					c2			<= 0;
					c18			<= 0;
					cu			<= 0;
					cb			<= 0;
					base_clock_double 	<= '0';
					base_clock_half 	<= '0';
					base_clock_quarter 	<= '0';
					base_clock_eighth 	<= '0';
					base_clock_user 	<= '0';
					base_clock 		<= '0';
				elsif(rising_edge(clk)) then
					if(c12 > to_integer(shift_right(baseclk,1))) then
						c12 <= 0;
						base_clock_half <= not base_clock_half;
					else c12 <= c12 + 1;
					end if;
					if(c14 > to_integer(shift_right(baseclk,2))) then
						c14 <= 0;
						base_clock_quarter <= not base_clock_quarter;
					else c14 <= c14 + 1;
					end if;
					if(c2 > to_integer(shift_left(baseclk,1))) then
						c2 <= 0;
						base_clock_double <= not base_clock_double;
					else c2 <= c2 + 1;
					end if;
					if(c18 > to_integer(shift_right(baseclk,3))) then
						c18 <= 0;
						base_clock_eighth <= not base_clock_eighth;
					else c18 <= c18 + 1;
					end if;
					if(cb > to_integer(baseclk)) then
						cb <= 0;
						base_clock <= not base_clock;
					else cb <= cb + 1;
					end if;
					if(cu > to_integer(shift_right(baseclk,4))) then
						cu <= 0;
						base_clock_user <= not base_clock_user;
					else cu <= cu + 1;
					end if;
				end if;
		end process;
	
end architecture;
