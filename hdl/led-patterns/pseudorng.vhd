library ieee;
use ieee.std_logic_1164.all;

entity pseudorng is
	Port ( 
		clock : in std_ulogic;
		reset : in std_ulogic;
		en : in std_ulogic;
		Q : out std_ulogic_vector (6 downto 0)
	);
end pseudorng;

architecture pseudorng_arch of pseudorng is

	signal Qt: std_ulogic_vector(6 downto 0) := "0000001";
	
	begin
	
		process(clock)
			variable tmp : std_ulogic := '1';
			begin
	
				if (rising_edge(clock)) then
				if (reset='1') then
				Qt <= "0001101"; 
				elsif en = '1' then
				tmp := Qt(4) XOR Qt(3) XOR Qt(2) XOR Qt(0);
				Qt <= tmp & Qt(6 downto 1);
				end if;
				end if;
		end process;
	Q <= Qt;

end architecture;