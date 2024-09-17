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
	
	
	
	type natural_array is array (natural range<>) of natural;

	type time_array is array (natural range<>) of time;
	
	signal bouncer_tb : std_ulogic := '0';
	
	constant BOUNCE_PERIOD : time := 100 ns;
	
	constant DEBOUNCE_TIME_1US       : time    := 1000 ns;
	constant DEBOUNCE_CYCLES_1US     : natural := DEBOUNCE_TIME_1US / BOUNCE_PERIOD;
	constant DEBOUNCE_CLK_CYCLES_1US : natural := DEBOUNCE_TIME_1US / CLK_PERIOD;
	
	constant DEBOUNCE_TIME_10US       : time    := 10 us;
	constant DEBOUNCE_CYCLES_10US     : natural := DEBOUNCE_TIME_10US / BOUNCE_PERIOD;
	constant DEBOUNCE_CLK_CYCLES_10US : natural := DEBOUNCE_TIME_10US / CLK_PERIOD;
	
	signal debounced_tb : std_ulogic_vector(0 to 1);
	
	constant DEBOUNCE_TIMES : time_array(0 to 1) :=
	(
	DEBOUNCE_TIME_1US,
	DEBOUNCE_TIME_10US
	);
	
	constant DEBOUNCE_CYCLES : natural_array(0 to 1) :=
	(
	DEBOUNCE_CYCLES_1US,
	DEBOUNCE_CYCLES_10US
	);
	
	constant DEBOUNCE_CLK_CYCLES : natural_array(0 to 1) :=
	(
	DEBOUNCE_CLK_CYCLES_1US,
	DEBOUNCE_CLK_CYCLES_10US
	);
	
	procedure bounce_signal (
	signal bounce          : out std_ulogic;
	constant BOUNCE_PERIOD : time;
	constant BOUNCE_CYCLES : natural;
	constant FINAL_VALUE   : std_ulogic
	) is
	
	-- If BOUNCE_CYCLES is not an integer multiple of 4, the division
	-- operation will only return the integer part (i.e., perform a floor
	-- operation). Thus, we need to calculate how many cycles are remaining
	-- after waiting for 3 * BOUNCE_CYCLES_BY_4 BOUNCE_PERIODs. If BOUNCE_CYCLES
	-- is an integer multiple of 4, then REMAINING_CYCLES will be equal to
	-- BOUNCE_CYCLES_BY_4.
	constant BOUNCE_CYCLES_BY_4 : natural := BOUNCE_CYCLES / 4;
	constant REMAINING_CYCLES   : natural := BOUNCE_CYCLES - (3 * BOUNCE_CYCLES_BY_4);
	
	begin
	
	-- Toggle the bouncing input quickly for ~1/4 of the debounce time
	for i in 1 to BOUNCE_CYCLES_BY_4 loop
		bounce <= not bounce;
		wait for BOUNCE_PERIOD;
	end loop;
	
	-- Toggle the bouncing input slowly for ~1/2 of the debounce time
	for i in 1 to BOUNCE_CYCLES_BY_4 loop
		bounce <= not bounce;
		wait for 2 * BOUNCE_PERIOD;
	end loop;
	
	-- Settle at the final value for the rest of the debounce time
	bounce <= FINAL_VALUE;
	wait for REMAINING_CYCLES * BOUNCE_PERIOD;
	
	end procedure bounce_signal;
	
	
	begin 
	
	--rst_tb <= '1','0' after 50 ns;
	--clk_tb <= not clk_tb after CLK_PERIOD / 2;
	async_tb <= bouncer_tb;
	
	DUT : async_conditioner port map(
		clk => clk_tb,
		rst => rst_tb,
		async => async_tb,
		sync => sync_tb
	);
	
	
	
	--rst_tb <= '1','0' after 50 ns;
		clk_tb <= not clk_tb after CLK_PERIOD / 2;
		--input_tb <= not input_tb after (CLK_PERIOD / 2) * 5;
		
		stimuli_generator : process is
		begin
		
			print("testing async conditioner");
		for debouncer_num in DEBOUNCE_TIMES'range loop
			-- Reset at the beginning of the tests to make sure the debouncers
			-- are in their reset/idle state.
			rst_tb <= '1', '0' after 50 ns;
		
			-- Let the input sit low for a while
			wait_for_clock_edges(clk_tb, 20);
		
			-- Transition the bouncing signal on the falling edges of the clock
			wait for CLK_PERIOD / 2;
		
			-- Press the button
			bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES(debouncer_num), '1');
		
			-- Hold the button for an extra debounce time
			wait_for_clock_edges(clk_tb, DEBOUNCE_CLK_CYCLES(debouncer_num));
		
			-- Transition the bouncing signal on the falling edges of the clock
			wait for CLK_PERIOD / 2;
		
			-- Release the button
			bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES(debouncer_num), '0');
		
			-- Keep the button unpressed for an extra debounce time
			wait_for_clock_edges(clk_tb, DEBOUNCE_CLK_CYCLES(debouncer_num));
		
			-- Transition the bouncing signal on the falling edges of the clock
			wait for CLK_PERIOD / 2;
		
			-- Press the button again, but release it right after the deboucne time
			-- is up; this makes sure the debouncer is not debouncing for longer than
			-- it is supposed to.
			bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES(debouncer_num), '1');
			bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES(debouncer_num), '0');
		
			-- Wait a few clock cycles to allow for the release debounce time to be done
			wait_for_clock_edges(clk_tb, 10);
		
			-- Make sure the debouncer works even if the final value during the
			-- initial-press debounce time is 0 (e.g., the button was pressed
			-- and released before the debounce time was up, or somehow settled
			-- in an unpressed state). In other words, make sure the debouncer
			-- output stays high for the whole debounce time, .
			-- NOTE: this test relies on the fact that bouncer_tb = '0' right before
			-- running this procedure, that way the first toggle sets bouncer_tb = '1'.
			bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES(debouncer_num), '0');
		end loop;
		
		std.env.finish;
		
		end process stimuli_generator;
		
		
		CHECKER : process is
			begin
			wait_for_clock_edge(clk_tb);
			if(async_tb = '0' and rst_tb ='0') then
				assert_eq(sync_tb,'0',"Is 1 when should be 0");
			elsif(async_tb = '1' and sync_tb = '1') then
				assert_eq(sync_tb,'1',"Is 0 when should be 1");
				wait until async_tb = '0';
			end if;
		end process;
	
	
	
	
	
	
end architecture;
