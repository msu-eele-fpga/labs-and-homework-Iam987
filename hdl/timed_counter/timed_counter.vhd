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
	
	constant COUNTER_LIMIT : integer := count_time / clk_period;
	
	signal count : integer range 0 to COUNTER_LIMIT;
	
	begin
	
	COUNT_proc : process (clk, enable) is
		begin 
		if (enable = false) then
			count <= 0;
			done <= false;
		elsif (rising_edge(clk))then
			if (count = COUNTER_LIMIT) then
				count <= 0;
				done <= true;
			elsif (count = 0) then
				count <= count + 1;
				done <= false;
			else count <= count + 1;
			end if;
		end if;	
	end process;	
end architecture;
