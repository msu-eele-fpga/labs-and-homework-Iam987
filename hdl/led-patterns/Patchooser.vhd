library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Patchooser is
	port(
		rst		: in std_ulogic;
		clk		: in std_ulogic;
		PBsync		: in std_ulogic;
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
	
	type state_type is (s0, s1, s2, s3, s4);
	signal current_state : state_type;
	signal next_state    : state_type;
	
	begin
	
		-- State memory
		STATE_MEMORY : process (PBsync, rst)
			begin
				if (rst = '1') then
					current_state <= s0;
				elsif (rising_edge(PBsync)) then
					current_state <= next_state;
				end if;
		end process;
		
		-- Next State Logic
		NEXT_STATE_LOGIC : process (switches)
			begin
				case (switches) is
					when "0001" => next_state <= s0;
					when "0010" => next_state <= s1;
					when "0011" => next_state <= s2;
					when "0100" => next_state <= s3;
					when "0101" => next_state <= s4;
					when others => null;
				end case;
		end process;
		
		-- Output Logic
		OUTPUT_LOGIC : process (clk) 
			begin
				case (current_state) is
					when s0 => cur_pat <= p0;
					when s1 => cur_pat <= p1;
					when s2 => cur_pat <= p2;
					when s3 => cur_pat <= p3;
					when s4 => cur_pat <= p4;
				end case;
		end process;
	
	
end architecture;
