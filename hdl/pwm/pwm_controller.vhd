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
		output		: out std_logic := '0'
	);
end entity;

architecture pwm_controller_arch of pwm_controller is
	
	constant sysclockrate 	: unsigned(24 downto 0)	:= "1011111010111100001000000";
	signal clkcount		: unsigned(44 downto 0) := "000000000000000000000000000000000000000000000";
	signal count		: unsigned(44 downto 0) := "000000000000000000000000000000000000000000000";
	signal readoutput	: std_logic := '0';
	
	begin
		clkcount <= shift_right(sysclockrate * unsigned(period),14);
		output <= readoutput;
		
		process(clk,rst) is
			begin
				if(rst = '1') then
					readoutput 	<= '0';
					count 		<= "000000000000000000000000000000000000000000000";
				elsif(rising_edge(clk)) then
					if(count >= clkcount) then
						count <= "000000000000000000000000000000000000000000000";
						readoutput <= not readoutput;
					else 	count <= count + 1;
					end if;
				end if;
		end process;
end architecture;
