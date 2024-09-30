library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Patgen1 is
	port(
		rst		: in std_ulogic;
		pat_clock	: in std_ulogic;
		pat		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture Patgen1_arch of Patgen1 is
	
	type state_type is (l0, l1, l2, l3, l4, l5, l6);
	signal current_state	: state_type;
	signal next_state 		: state_type;
	
	begin
		
		-- State Memory:
		STATE_MEMORY : process (pat_clock, rst)
			begin
				if (rst = '1') then
					current_state <= l0;
				elsif (rising_edge(pat_clock)) then
					current_state <= next_state;
				end if;
		end process;
		
		--Next State Logic:
		NEXT_STATE_LOGIC : process (current_state)
			begin
				case (current_state) is
					when l0 => next_state <= l1;
					when l1 => next_state <= l2;
					when l2 => next_state <= l3;
					when l3 => next_state <= l4;
					when l4 => next_state <= l5;
					when l5 => next_state <= l6;
					when l6 => next_state <= l0;
					when others => next_state <= l0;
				end case;
		end process;
		
		-- Output Logic:
		OUTPUT_LOGIC : process (current_state)
			begin
				case (current_state) is
					when l0 => pat <= "1100000";
					when l1 => pat <= "1000001";
					when l2 => pat <= "0000011";
					when l3 => pat <= "0000110";
					when l4 => pat <= "0001100";
					when l5 => pat <= "0011000";
					when l6 => pat <= "0110000";
				end case;
		end process;	
	
end architecture;

