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
	
	type state_type is (s0, s1, waiting);
	signal current_state	: state_type;
	signal next_state	: state_type;
	signal enable		: std_ulogic := '0';
	signal done		: std_ulogic := '0';
	signal toggle		: std_ulogic;
	signal check		: std_ulogic;
	
	component Timer1Sec is
		port(
			clk	: in std_ulogic;
			enable	: in std_ulogic;
			done	: out std_ulogic
		);
	end component;
	
	begin
		
		-- State Memory
		STATE_MEMORY : process(PBsync, done, toggle)
			begin
				if(rst = '1') then
					current_state <= s0;
					check <= toggle;
				elsif(rising_edge(PBsync)) then
					current_state <= waiting;
				end if;
				if(done = '1') then
					current_state <= next_state;
				elsif(toggle = not check) then
					current_state <= next_state;
					check <= toggle;
				end if;
		end process;
		
		-- Next State Logic
		NEXT_STATE_LOGIC : process(hps_led_control)
			begin
				case(hps_led_control) is
					when false => next_state <= s0;
					when true => next_state <= s1;
				end case;
				toggle <= not toggle;
		end process;
		
		-- Output Logic
		OUTPUT_LOGIC : process(current_state, done)
			begin
				case(current_state) is
					when waiting => led <= "000" & switches;
					when s0 => led <= cur_pat;
					when s1 => led <= led_reg(6 downto 0);
				end case;
		end process;
	
		TIMEHELP : process(clk)
			begin
				if(current_state = waiting) then
					enable <= '1';
				end if;
				if(done = '1') then
					enable <= '0';
				end if;
		end process;
		
		TIMER : Timer1Sec port map(
			clk => clk,
			enable => enable,
			done => done
		);
	
end architecture;
