library ieee;
use ieee.std_logic_1164.all;

entity timed_counter is 
	generic (
		clk_period : time;
		count_time : time
		);
	port (
		clk 	: in	std_ulogic;
		enable	: in 	boolean;
		done	: out 	boolean
		);
end entity;

architecture timed_counter_arch of timed_counter is

	begin
	
end architecture;
