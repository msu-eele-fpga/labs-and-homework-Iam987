library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Patgen3 is
	port(
		rst		: in std_ulogic;
		pat_clock	: in std_ulogic;
		pat		: out std_ulogic_vector(7 downto 0)
	);
end entity;

architecture Patgen3_arch of Patgen3 is

	begin
	
end architecture;
