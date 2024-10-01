library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Patgen4 is
	port(
		rst		: in std_ulogic;
		pat_clock	: in std_ulogic;
		pat		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture Patgen4_arch of Patgen4 is
	
	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
	signal current_state	: state_type;
	signal next_state	: state_type;
	
	begin
	
		-- State Memory:
		STATE_MEMORY : process (pat_clock, rst)
			begin
				if (rst = '1') then
					current_state <= s0;
				elsif (rising_edge(pat_clock)) then
					current_state <= next_state;
				end if;
		end process;
		
		--Next State Logic:
		NEXT_STATE_LOGIC : process (current_state)
			begin
				case (current_state) is
					when s0 => next_state <= s1;
					when s1 => next_state <= s2;
					when s2 => next_state <= s3;
					when s3 => next_state <= s4;
					when s4 => next_state <= s5;
					when s5 => next_state <= s6;
					when s6 => next_state <= s7;
					when s7 => next_state <= s8;
					when s8 => next_state <= s9;
					when s9 => next_state <= s10;
					when s10 => next_state <= s0;
					when others => next_state <= s0;
				end case;
		end process;
		
		-- Output Logic:
		OUTPUT_LOGIC : process (current_state)
			begin
				case (current_state) is
					when s0 => pat <= "0101101";
					when s1 => pat <= "1001000";
					when s2 => pat <= "1010100";
					when s3 => pat <= "0111010";
					when s4 => pat <= "1001010";
					when s5 => pat <= "0101011";
					when s6 => pat <= "1001010";
					when s7 => pat <= "0001101";
					when s8 => pat <= "0011010";
					when s9 => pat <= "0101010";
					when s10 => pat <= "1010101";
				end case;
		end process;	
end architecture;
