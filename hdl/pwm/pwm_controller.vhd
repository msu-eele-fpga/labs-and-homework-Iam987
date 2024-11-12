library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_controller is
	generic(
		CLK_PERIOD 	: time := 20 ns
	);
	port(
		clk		: in std_logic;
		rst		: in std_logic;
		period		: in unsigned(19 downto 0); -- U20.14
		duty_cycle	: in std_logic_vector(12 downto 0); -- U12.11
		output		: out std_logic
	);
end entity;

architecture pwm_controller_arch of pwm_controller is
	
	
	
	begin
		
		
	
end architecture;
