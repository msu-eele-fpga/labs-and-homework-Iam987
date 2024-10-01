library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer1Sec is
	port(
		clk	: in std_ulogic;
		enable	: in std_ulogic;
		done	: out std_ulogic
	);
end entity;

architecture Timer1Sec_arch of Timer1Sec is
	
	signal Cnt		: integer := 0;
	
	begin
	
		TIMER : process(clk)
			begin
				if(rising_edge(clk) and enable = '1') then
					if(Cnt > 50000000) then
						Cnt <= 0;
						done <= '1';
					else 
						Cnt <= Cnt + 1;
						done <= '0';
					end if;
				elsif(rising_edge(clk) and enable = '0') then	
					Cnt <= 0;
					done <= '0';
				end if;
		end process;
	
end architecture;
