library ieee;
use ieee.std_logic_1164.all;

entity vending_machine is
    port (
		clk      : in  std_ulogic;
		rst      : in  std_ulogic;
		nickel   : in  std_ulogic;
		dime     : in  std_ulogic;
		dispense : out std_ulogic;
		amount   : out natural range 0 to 15
    );
end entity;

architecture vending_machine_arch of vending_machine is
	
	type State_Type is (c0, c5, c10, c15);
	signal current_state 	: State_Type;
	signal next_state		: State_Type;
	
	begin
	
		-- State Memory:
		STATE_MEMORY : process (clk, rst)
			begin
				if (rst = '1') then
					current_state <= c0;
				elsif (rising_edge(clk)) then
					current_state <= next_state;
				end if;
		end process;
		
		-- Next State Logic:
		NEXT_STATE_LOGIC : process (current_state, nickel, dime)
			begin
				case (current_state) is
					when c0 	=> 	if (dime = '1') then
										next_state <= c10;
									elsif (nickel = '1') then
										next_state <= c5;
									end if;
					when c5 	=>	if (dime = '1') then
										next_state <= c15;
									elsif (nickel = '1') then
										next_state <= c10;
									end if;
					when c10 	=>	if (dime = '1' or nickel = '1') then
										next_state <= c15;
									end if;
					when c15	=>	next_state <= c0;
					when others	=> next_state <= c0;
				end case;
		end process;
		
		-- Output Logic:
		OUTPUT_LOGIC : process (current_state, dime, nickel)
			begin
				case (current_state) is
					when c0	=>	dispense <= '0';
								amount <= 0;
					when c5 =>	dispense <= '0';
								amount <= 5;
					when c10 =>	dispense <= '0';
								amount <= 10;
					when c15 =>	dispense <= '1';
								amount <= 15;
				end case;
		end process;
	
end architecture;