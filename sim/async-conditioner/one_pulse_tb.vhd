library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity one_pulse_tb is
end entity;

architecture one_pulse_tb_arch of one_pulse_tb is
	
	signal clk_tb		: std_ulogic := '0';
	signal rst_tb		: std_ulogic := '0';
	signal input_tb		: std_ulogic := '0';
	signal pulse_tb		: std_ulogic;
	
	component one_pulse is
		port (
			clk		: in std_ulogic;
			rst		: in std_ulogic;
			input	: in std_ulogic;
			pulse	: out std_ulogic);
	end component;
	
	begin
	
		rst_tb <= '1','0' after 50 ns;
		clk_tb <= not clk_tb after CLK_PERIOD / 2;
		input_tb <= not input_tb after (CLK_PERIOD / 2) * 5;
		
		DUT : one_pulse port map (
				clk		=> clk_tb,
				rst		=> rst_tb,
				input	=> input_tb,
				pulse	=> pulse_tb);
	
end architecture;
