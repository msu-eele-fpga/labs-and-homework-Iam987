library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns is
	generic (
		system_clock_period	: time := 20 ns
	);
	port (
		clk		: in std_ulogic;
		rst		: in std_ulogic;
		push_button	: in std_ulogic;
		switches	: in std_ulogic_vector(3 downto 0);
		hps_led_control	: in boolean;
		base_period	: in unsigned (7 downto 0);
		led_reg		: in std_ulogic_vector(7 downto 0);
		led		: out std_ulogic_vector(7 downto 0)
	);
end entity;


architecture led_patterns_arch of led_patterns is
	
	signal base_clock_half 		: std_ulogic;
	signal base_clock_quarter	: std_ulogic;
	signal base_clock_double	: std_ulogic;
	signal base_clock_eighth	: std_ulogic;
	signal base_clock_user 		: std_ulogic;
	signal base_clock 		: std_ulogic;
	signal Blinker			: std_ulogic;
	signal p0, p1, p2, p3, p4 	: std_ulogic_vector(6 downto 0);
	signal cur_pat 			: std_ulogic_vector(6 downto 0);
	signal PBsync			: std_ulogic;
	
	component async_conditioner is
		port (
			clk	: in std_ulogic;
			rst	: in std_ulogic;
			async	: in std_ulogic;
			sync	: out std_ulogic
		);
	end component; 
	
	component Clockgen is
		port(
			base_period		: in std_ulogic_vector(7 downto 0);
			clk			: in std_ulogic;
			rst			: in std_ulogic;
			base_clock_half 	: inout std_ulogic;
			base_clock_quarter	: inout std_ulogic;
			base_clock_double	: inout std_ulogic;
			base_clock_eighth	: inout std_ulogic;
			base_clock_user 	: inout std_ulogic;
			base_clock		: inout std_ulogic
		);
	end component;
	
	component Patgen0 is
		port(
			rst		: in std_ulogic;
			pat_clock	: in std_ulogic;
			pat		: out std_ulogic_vector(6 downto 0)
		);
	end component;
	
	component Patgen1 is
		port(
			rst		: in std_ulogic;
			pat_clock	: in std_ulogic;
			pat		: out std_ulogic_vector(6 downto 0)
		);
	end component;
	
	component Patgen2 is
		port(
			rst		: in std_ulogic;
			pat_clock	: in std_ulogic;
			pat		: out std_ulogic_vector(6 downto 0)
		);
	end component;
	
	component Patgen3 is
		port(
			rst		: in std_ulogic;
			pat_clock	: in std_ulogic;
			pat		: out std_ulogic_vector(6 downto 0)
		);
	end component;
	
	component Patgen4 is
		port(
			rst		: in std_ulogic;
			pat_clock	: in std_ulogic;
			pat		: out std_ulogic_vector(6 downto 0)
		);
	end component;
	
	component Patchooser is
		port(
			rst		: in std_ulogic;
			clk		: in std_ulogic;
			PBsync		: in std_ulogic;
			switches	: in std_ulogic_vector(3 downto 0);
			p0		: in std_ulogic_vector(6 downto 0);
			p1		: in std_ulogic_vector(6 downto 0);
			p2		: in std_ulogic_vector(6 downto 0);
			p3		: in std_ulogic_vector(6 downto 0);
			p4		: in std_ulogic_vector(6 downto 0);
			cur_pat		: out std_ulogic_vector(6 downto 0)
		);
	end component;
	
	component Srcchooser is
		port(
			rst		: in std_ulogic;
			clk		: in std_ulogic;
			PBsync		: in std_ulogic;
			hps_led_control	: in boolean;
			led_reg		: in std_ulogic_vector(7 downto 0);
			switches	: in std_ulogic_vector(3 downto 0);
			cur_pat		: in std_ulogic_vector(6 downto 0);
			led		: out std_ulogic_vector(6 downto 0)
		);
	end component;
			
			
	begin
	
	SYNCMAN : async_conditioner port map (
		clk	=> clk,
		rst	=> rst,
		async	=> push_button,
		sync	=> PBsync
	);
	
	CLOCKMAN : Clockgen port map (
		base_period		=> std_ulogic_vector(base_period),
		clk			=> clk,
		rst			=> rst,
		base_clock_half		=> base_clock_half,
		base_clock_quarter	=> base_clock_quarter,
		base_clock_double	=> base_clock_double,
		base_clock_eighth	=> base_clock_eighth,
		base_clock_user		=> base_clock_user,
		base_clock		=> base_clock
	);
	
	PATMAN0 : Patgen0 port map(
		rst		=> rst,
		pat_clock	=> base_clock_half,
		pat		=> p0
	);
	
	PATMAN1 : Patgen1 port map(
		rst		=> rst,
		pat_clock	=> base_clock_quarter,
		pat		=> p1
	);
	
	PATMAN2 : Patgen2 port map(
		rst		=> rst,
		pat_clock	=> base_clock_double,
		pat		=> p2
	);
	
	PATMAN3 : Patgen3 port map(
		rst		=> rst,
		pat_clock	=> base_clock_eighth,
		pat		=> p3
	);
	
	PATMAN4 : Patgen4 port map(
		rst		=> rst,
		pat_clock	=> base_clock_user,
		pat		=> p4
	);
	
	PATCHOOSEMAN : Patchooser port map (
		rst		=> rst,
		clk		=> clk,
		PBsync		=> PBsync,
		switches	=> switches,
		p0		=> p0,
		p1		=> p1,
		p2		=> p2,
		p3		=> p3,
		p4		=> p4,
		cur_pat		=> cur_pat
	);
	
	SRCCHOOSEMAN : Srcchooser port map (
		rst		=> rst,
		clk		=> clk,
		PBsync		=> PBsync,
		hps_led_control	=> hps_led_control,
		led_reg		=> led_reg,
		switches	=> switches,
		cur_pat		=> cur_pat,
		led		=> led(6 downto 0)
	);
	
	BLINKYMAN : process (base_clock) 
		begin
			if(rst = '1') then
				Blinker <= '0';
			elsif(rising_edge(base_clock)) then
				Blinker <= not Blinker;
			end if;
			if(not hps_led_control) then
				led(7) <= Blinker;
			else 
				led(7) <= led_reg(7);
			end if;
	end process;
	
	
end architecture;
