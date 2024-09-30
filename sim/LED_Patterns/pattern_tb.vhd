library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity pattern_tb is
end entity;

architecture pattern_tb_arch of pattern_tb is
	
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
	
	signal clk_tb			: std_ulogic := '0';
	signal rst_tb			: std_ulogic;
	signal push_button_tb		: std_ulogic;
	signal switches_tb		: std_ulogic_vector(3 downto 0);
	signal hps_led_control_tb	: boolean;
	signal base_period_tb		: unsigned (7 downto 0);
	signal led_reg_tb			: std_ulogic_vector(7 downto 0);
	signal led_tb			: std_ulogic_vector(7 downto 0);
	
	begin
		
		rst_tb <= '1', '0' after 50 ns;
		clk_tb <= not clk_tb after CLK_PERIOD / 2;
		
		DUT : led_patterns port map (
					     clk 		=> clk_tb,
					     rst 		=> rst_tb,
					     push_button 	=> push_button_tb,
					     switches		=> switches_tb,
					     hps_led_control	=> hps_led_control_tb,
					     base_period	=> base_period_tb,
					     led_reg		=> led_reg_tb,
					     led		=> led_tb
		);
		
end architecture;
