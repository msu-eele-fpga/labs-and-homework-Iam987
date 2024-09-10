library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity timed_counter_tb is
end entity timed_counter_tb;

architecture testbench of timed_counter_tb is
	component timed_counter is 
		generic (
			clk_period : time;
			count_time : time
			);
		port (
			clk 	: in	std_ulogic;
			enable	: in 	boolean;
			done	: out 	boolean
			);
	end component;
	
	signal clk_tb : std_ulogic := '0';
	
	signal enable_100ns_tb 	: boolean := false;
	signal done_100ns_tb	: boolean;
	
	signal enable_260ns_tb 	: boolean := false;
	signal done_260ns_tb	: boolean;
	
	constant HUNDRED_NS	: time := 100 ns;
	constant TWOSIXTY_NS	: time := 260 ns;
	
	procedure predict_counter_done (
		constant count_time : in time;
		signal enable		: in boolean;
		signal done			: in boolean;
		constant count_iter	: in natural
	) is
			begin 
				if enable then
					if count_iter < (count_time / CLK_PERIOD) then
						assert_false(done, "counter not done");
					else
						assert_true(done, "counter is done");
					end if;
				else
					assert_false(done, "counter not enabled");
				end if;
	end procedure;
	
	begin
		dut_100ns_counter	: component timed_counter
			generic map (
				clk_period => CLK_PERIOD,
				count_time => HUNDRED_NS)
			port map(
				clk 	=> clk_tb,
				enable 	=> enable_100ns_tb,
				done 	=> done_100ns_tb);
		clk_tb <= not clk_tb after CLK_PERIOD / 2;
		
		dut_260ns_counter	: component timed_counter
			generic map (
				clk_period => CLK_PERIOD,
				count_time => TWOSIXTY_NS)
			port map(
				clk 	=> clk_tb,
				enable 	=> enable_260ns_tb,
				done 	=> done_260ns_tb);
		
		stimuli_and_checker : process is
			begin
			
				-- test 100 ns timer when it's enabled
				print("testing 100 ns timer: enabled");
				wait_for_clock_edge(clk_tb);
				enable_100ns_tb <= true;
				
				-- Loop for the number of clock cycles that is equal to the timer's period
				for i in 0 to (HUNDRED_NS / CLK_PERIOD) Loop
					wait_for_clock_edge(clk_tb);
					predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i); -- test whether the counter's done output is correct or not
				end loop;
				print("test done");
				
				-- Test for no assersion of done when disabled for two count_time periods (100 ns)
				print("testing disabled for two count_time periods (100 ns)");
				wait_for_clock_edge(clk_tb);
				enable_100ns_tb <= false;
				for i in 0 to (2 * (HUNDRED_NS / CLK_PERIOD)) Loop
					wait_for_clock_edge(clk_tb);
					predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
				end loop;
				print("test done");
				
				-- Test for correct done toggling for multiple enabled count_time periods (100 ns)
				print("testing enabled for multiple count_time periods (100 ns)");
				wait_for_clock_edge(clk_tb);
				enable_100ns_tb <= true;
				for j in 0 to 5 Loop
					for i in 0 to (HUNDRED_NS / CLK_PERIOD) Loop
						wait_for_clock_edge(clk_tb);
						predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
					end loop;
				end loop;
				print("test done");
				
				
				------------------------------------------------------------------------------------------
				-- test 260 ns timer when it's enabled
				print("testing 260 ns timer: enabled");
				wait_for_clock_edge(clk_tb);
				enable_260ns_tb <= true;
				
				-- Loop for the number of clock cycles that is equal to the timer's period
				for i in 0 to (TWOSIXTY_NS / CLK_PERIOD) Loop
					wait_for_clock_edge(clk_tb);
					predict_counter_done(TWOSIXTY_NS, enable_260ns_tb, done_260ns_tb, i); -- test whether the counter's done output is correct or not
				end loop;
				print("test done");
				
				-- Test for no assersion of done when disabled for two count_time periods (260 ns)
				print("testing disabled for two count_time periods (260 ns)");
				wait_for_clock_edge(clk_tb);
				enable_260ns_tb <= false;
				for i in 0 to (2 * (TWOSIXTY_NS / CLK_PERIOD)) Loop
					wait_for_clock_edge(clk_tb);
					predict_counter_done(TWOSIXTY_NS, enable_260ns_tb, done_260ns_tb, i);
				end loop;
				print("test done");
				
				-- Test for correct done toggling for multiple enabled count_time periods (260 ns)
				print("testing enabled for multiple count_time periods (260 ns)");
				wait_for_clock_edge(clk_tb);
				enable_260ns_tb <= true;
				for j in 0 to 5 Loop
					for i in 0 to (TWOSIXTY_NS / CLK_PERIOD) Loop
						wait_for_clock_edge(clk_tb);
						predict_counter_done(TWOSIXTY_NS, enable_260ns_tb, done_260ns_tb, i);
					end loop;
				end loop;
				print("test done");
				
				
				-- add other test cases here
				
				-- testbench is done :)
				std.env.finish;
				wait;
		end process;
end architecture;