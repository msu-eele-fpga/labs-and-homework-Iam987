library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns_avalon is
	port(
		clk : in std_ulogic;
		rst : in std_ulogic;
		
		-- avalon memory-mapped slave interface
		avs_read	: in std_logic;
		avs_write	: in std_logic;
		avs_address	: in std_logic_vector(1 downto 0);
		avs_readdata	: out std_logic_vector(31 downto 0);
		avs_writedata	: in std_logic_vector(31 downto 0);
		
		-- external I/O; export to top-level
		push_button	: in std_ulogic;
		switches	: in std_ulogic_vector(3 downto 0);
		led		: out std_ulogic_vector(7 downto 0)
	);
end entity;

architecture led_patterns_avalon_arch of led_patterns_avalon is
	
	signal hps_led_control	: boolean;
	signal base_period	: unsigned(7 downto 0);
	signal led_reg		: std_ulogic_vector(7 downto 0);
	
	function To_Std_Logic(L : boolean) return std_logic_vector is
		begin
			if L then
				return("1");
			else
				return("0");
			end if;
	end function;
	
	function To_Bool(S : std_logic_vector) return boolean is
		begin
			if (S(0) = '1') then
				return true;
			else 
				return false;
			end if;
	end function;
	
	component led_patterns is
		generic (
			system_clock_period	: time := 20 ns
		);
		port (
			clk		: in std_ulogic;
			rst		: in std_ulogic;
			push_button	: in std_ulogic;
			switches	: in std_ulogic_vector(3 downto 0);
			hps_led_control	: in boolean;
			base_period	: in unsigned (7 downto 0);
			led_reg		: in std_ulogic_vector(7 downto 0);
			led		: out std_ulogic_vector(7 downto 0)
		);
	end component;
	
	begin
	
	avalon_register_read : process(clk) is
		begin
			if(rising_edge(clk) and avs_read = '1') then 
				case avs_address is
					when "00"	=> avs_readdata <= "0000000000000000000000000000000" & To_Std_Logic(hps_led_control);
					when "01"	=> avs_readdata <= "000000000000000000000000" & std_logic_vector(base_period);
					when "10"	=> avs_readdata <= "000000000000000000000000" & std_logic_vector(led_reg);
					when others	=> avs_readdata <= (others => '0'); -- return zeros for unused registers
				end case;
			end if;
	end process;
	
	avalon_register_write : process(clk, rst) is
		begin
			if(rst = '1') then
				hps_led_control <= false;
				base_period <= "00000100";
				led_reg <= "00000000";
			elsif (rising_edge(clk) and avs_write = '1') then
				case avs_address is
					when "00"	=> hps_led_control <= To_Bool(avs_writedata);
					when "01"	=> base_period <= unsigned(avs_writedata(7 downto 0));
					when "10"	=> led_reg <= std_ulogic_vector(avs_writedata(7 downto 0));
					when others	=> null;
				end case;
			end if;
	end process;
	
	LEDPATTERNMAN : led_patterns port map (
		clk		=> clk,
		rst		=> rst,
		push_button	=> push_button,
		switches	=> switches,
		hps_led_control	=> hps_led_control,
		base_period	=> base_period,
		led_reg		=> led_reg,
		led		=> led
	);
	
end architecture;