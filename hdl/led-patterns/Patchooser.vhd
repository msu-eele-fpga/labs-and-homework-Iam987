library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Patchooser is
	port(
		rst		: in std_ulogic;
		switches	: in std_ulogic_vector(3 downto 0);
		p0		: in std_ulogic_vector(6 downto 0);
		p1		: in std_ulogic_vector(6 downto 0);
		p2		: in std_ulogic_vector(6 downto 0);
		p3		: in std_ulogic_vector(6 downto 0);
		p4		: in std_ulogic_vector(6 downto 0);
		cur_pat		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture Patchooser_arch of Patchooser is

	begin
	
end architecture;
