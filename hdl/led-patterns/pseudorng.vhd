library ieee;
use ieee.std_logic_1164.all;

entity pseudorng is
Port ( clock : in std_ulogic;
       reset : in std_ulogic;
       en : in std_ulogic;
       Q : out std_ulogic_vector (7 downto 0);
       check: out std_ulogic);

--       constant seed: std_ulogic_vector(7 downto 0) := "00000001";
end pseudorng;

architecture pseudorng_arch of pseudorng is

	--signal temp: std_ulogic;
	signal Qt: std_ulogic_vector(7 downto 0) := x"01";
	
	begin
	
		PROCESS(clock)
			variable tmp : std_ulogic := '0';
			BEGIN
	
				IF rising_edge(clock) THEN
				IF (reset='1') THEN
				-- credit to QuantumRipple for pointing out that this should not
				-- be reset to all 0's, as you will enter an invalid state
				Qt <= x"01"; 
				--ELSE Qt <= seed;
				ELSIF en = '1' THEN
				tmp := Qt(4) XOR Qt(3) XOR Qt(2) XOR Qt(0);
				Qt <= tmp & Qt(7 downto 1);
				END IF;
				
				END IF;
		END PROCESS;
	-- check <= temp;
	check <= Qt(7);
	Q <= Qt;

end architecture;