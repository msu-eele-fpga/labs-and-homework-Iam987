library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Srcchooser is
	port(
		rst		: in std_ulogic;
		clk		: in std_ulogic;
		PBsync		: in std_ulogic;
		hps_led_control	: in boolean;
		led_reg		: in std_ulogic_vector(7 downto 0);
		switches	: in std_ulogic_vector(3 downto 0);
		cur_pat		: in std_ulogic_vector(6 downto 0);
		led		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture Srcchooser_arch of Srcchooser is
	
	type state_type is (s0, s1);
	signal current_state	: state_type;
	signal next_state	: state_type;
	signal Cnt		: integer := 0;
	signal enable		: boolean := false;
	signal done		: boolean := true;
	
	begin
		
		-- State Memory
		STATE_MEMORY : process(PBsync, done)
			begin
				if(rst = '1') then
					current_state <= s0;
				elsif(rising_edge(PBsync)) then
					current_state <= next_state;
					enable <= true;
				elsif(done = true) then
					enable <= false;
				end if;
		end process;
		
		-- Next State Logic
		NEXT_STATE_LOGIC : process(hps_led_control)
			begin
				case(hps_led_control) is
					when false => next_state <= s0;
					when true => next_state <= s1;
				end case;
		end process;
		
		-- Output Logic
		OUTPUT_LOGIC : process(current_state, done)
			begin
				case(current_state) is
					when s0 => if(done = false) then
							led <= "000" & switches;
						   else led <= cur_pat;
						   end if;
					when s1 => led <= led_reg(6 downto 0);
				end case;
		end process;
	
		TIMER : process(clk)
			begin
				if(rst = '1') then
					Cnt <= 0;
				elsif(rising_edge(clk) and enable = true) then
					if(Cnt > 25000000) then
						Cnt <= 0;
						done <= true;
					else 	Cnt <= Cnt + 1;
						done <= false;
					end if;
				end if;
		end process;
	
end architecture;
