library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Patgen2 is
	port(
		rst		: in std_ulogic;
		pat_clock	: in std_ulogic;
		pat		: out std_ulogic_vector(7 downto 0)
	);
end entity;

architecture Patgen2_arch of Patgen2 is

	begin
	
end architecture;

