library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity Clockgen_tb is
end entity;

architecture Clockgen_tb_arch of Clockgen_tb is
	
	component Clockgen is
		generic(
				base_period		: in std_ulogic_vector(7 downto 0) := "00000100" --Fixed point u8.4 (0.25 sec)
			);
			port(
				clk			: in std_ulogic;
				rst			: in std_ulogic;
				base_clock_half 	: inout std_ulogic;
				base_clock_quarter	: inout std_ulogic;
				base_clock_double	: inout std_ulogic;
				base_clock_eighth	: inout std_ulogic;
				base_clock_user 	: inout std_ulogic
			);
	end component;
	
	signal clk_tb, rst_tb 		: std_ulogic := '0';
	signal base_clock_half_tb 	: std_ulogic;
	signal base_clock_quarter_tb	: std_ulogic;
	signal base_clock_double_tb	: std_ulogic;
	signal base_clock_eighth_tb	: std_ulogic;
	signal base_clock_user_tb 	: std_ulogic;
	
	
	
	begin
	
	rst_tb <= '1', '0' after 50 ns;
	clk_tb <= not clk_tb after CLK_PERIOD / 2;
	
	DUT : Clockgen port map(
		clk => clk_tb,
		rst => rst_tb,
		base_clock_half 	=> base_clock_half_tb, 
		base_clock_quarter	=> base_clock_quarter_tb,
		base_clock_double	=> base_clock_double_tb,
		base_clock_eighth	=> base_clock_eighth_tb,
		base_clock_user 	=> base_clock_user_tb 
	);
	
	
end architecture;