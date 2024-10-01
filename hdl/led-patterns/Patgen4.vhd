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
	
	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27);
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
					when s10 => next_state <= s11;
					when s11 => next_state <= s12;
					when s12 => next_state <= s13;
					when s13 => next_state <= s14;
					when s14 => next_state <= s15;
					when s15 => next_state <= s16;
					when s16 => next_state <= s17;
					when s17 => next_state <= s18;
					when s18 => next_state <= s19;
					when s19 => next_state <= s20;
					when s20 => next_state <= s21;
					when s21 => next_state <= s22;
					when s22 => next_state <= s23;
					when s23 => next_state <= s24;
					when s24 => next_state <= s25;
					when s25 => next_state <= s26;
					when s26 => next_state <= s27;
					when s27 => next_state <= s0;
					when others => next_state <= s0;
				end case;
		end process;
		
		-- Output Logic:
		OUTPUT_LOGIC : process (current_state)
			begin
				case (current_state) is
					when s0 => pat <= "0000000";
					when s1 => pat <= "0000001";
					when s2 => pat <= "0000011";
					when s3 => pat <= "0000111";
					when s4 => pat <= "0001111";
					when s5 => pat <= "0011111";
					when s6 => pat <= "0111111";
					when s7 => pat <= "1111111";
					when s8 => pat <= "1111110";
					when s9 => pat <= "1111100";
					when s10 => pat <= "1111000";
					when s11 => pat <= "1110000";
					when s12 => pat <= "1100000";
					when s13 => pat <= "1000000";
					when s14 => pat <= "0000000";
					when s15 => pat <= "1000000";
					when s16 => pat <= "1100000";
					when s17 => pat <= "1110000";
					when s18 => pat <= "1111000";
					when s19 => pat <= "1111100";
					when s20 => pat <= "1111110";
					when s21 => pat <= "1111111";
					when s22 => pat <= "0111111";
					when s23 => pat <= "0011111";
					when s24 => pat <= "0001111";
					when s25 => pat <= "0000111";
					when s26 => pat <= "0000011";
					when s27 => pat <= "0000001";
				end case;
		end process;	
end architecture;
