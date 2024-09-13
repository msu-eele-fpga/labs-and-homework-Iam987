library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity async_conditioner_tb is
end entity;

architecture async_conditioner_tb_arch of async_conditioner_tb is
		
	function rand_time(min_val, max_val : time; unit : time := ns) return time is
		variable r, r_scaled, min_real, max_real : real;
		variable seed1, seed2 : integer := 999;
		begin 
			uniform(seed1, seed2, r);
			min_real := real(min_val / unit);
			max_real := real(max_val / unit);
			r_scaled := r * (max_real - min_real) + min_real;
			return real(r_scaled) * unit;
	end function;
	
	component async_conditioner is
		port (
			clk		: in std_ulogic;
			rst		: in std_ulogic;
			async	: in std_ulogic;
			sync	: out std_ulogic
			);
	end component;
	
	signal clk_tb		: std_ulogic := '0';
	signal rst_tb		: std_ulogic := '0';
	signal async_tb		: std_ulogic := '0';
	signal sync_tb		: std_ulogic;
	
	begin 
	
	rst_tb <= '1','0' after 50 ns;
	clk_tb <= not clk_tb after CLK_PERIOD / 2;
	async_tb <= not async_tb after rand_time(10 ns, 300 ns, ns);
	
	DUT : async_conditioner port map(
		clk => clk_tb,
		rst => rst_tb,
		async => async_tb,
		sync => sync_tb
	);
	
end architecture;
