library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clockgen is
generic(
		base_period		: in std_ulogic_vector(7 downto 0) := "00000100" --Fixed point u8.4 (0.25 sec)
	);
	port(
		clk			: in std_ulogic;
		base_clock_half 	: out std_ulogic;
		base_clock_quarter	: out std_ulogic;
		base_clock_double	: out std_ulogic;
		base_clock_eighth	: out std_ulogic;
		base_clock_user 	: out std_ulogic
	);
end entity;

architecture Clockgen_arch of Clockgen is
	
	begin
	
end architecture;
