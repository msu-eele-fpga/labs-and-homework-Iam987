library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
	generic (
		clk_period		: time := 20 ns;
		debounce_time	: time
		);
	port (
		clk			: in std_ulogic;
		rst			: in std_ulogic;
		input		: in std_ulogic;
		debounced	: out std_ulogic
		);
end entity;

architecture debouncer_arch of debouncer is

	begin
	
end architecture;
