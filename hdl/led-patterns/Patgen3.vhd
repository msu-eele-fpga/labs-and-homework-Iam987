library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Patgen3 is
	port(
		rst		: in std_ulogic;
		pat_clock	: in std_ulogic;
		pat		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture Patgen3_arch of Patgen3 is

	signal Cnt : unsigned(6 downto 0) := "0000000";
	
	begin
	
	COUNT : process (pat_clock)
		begin
			if (rising_edge(pat_clock)) then
				cnt <= cnt - 1;
			end if;
	end process;
	
	pat <= std_ulogic_vector(cnt);
	
end architecture;
