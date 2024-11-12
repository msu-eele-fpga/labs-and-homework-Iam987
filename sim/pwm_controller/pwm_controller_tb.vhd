library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity pwm_controller_tb is
end entity pwm_controller_tb;

architecture pwm_controller_tb_arch of pwm_controller_tb is

	component pwm_controller is
		generic(
			CLK_PERIOD 	: time := 20 ns
		);
		port(
			clk		: in std_logic;
			rst		: in std_logic;
			period		: in unsigned(19 downto 0); -- U20.14
			duty_cycle	: in std_logic_vector(12 downto 0); -- U12.11
			output		: out std_logic := '0'
		);
	end component;
	
	signal clk_tb, rst_tb 		: std_logic := '0';
	signal period_tb		: unsigned(19 downto 0) := "00000000000000000000";
	signal duty_cycle_tb		: std_logic_vector(12 downto 0) := "0000000000000";
	signal output_tb		: std_logic;

	begin
	
		rst_tb <= '1', '0' after 50 ns;
		clk_tb <= not clk_tb after CLK_PERIOD / 20;
		period_tb <= period_tb + "1" after 8000 ns;
		duty_cycle_tb <= std_logic_vector(unsigned(duty_cycle_tb) + "111") after 150 ns;
		
		DUT : pwm_controller port map(
			clk => clk_tb,
			rst => rst_tb,
			period => period_tb,
			duty_cycle => duty_cycle_tb,
			output => output_tb
		);
end architecture;
