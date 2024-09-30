library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Srcchooser is
	port(
		rst		: in std_ulogic;
		PBsync		: in std_ulogic;
		hps_led_control	: in boolean;
		led_reg		: in std_ulogic_vector(7 downto 0);
		switches	: in std_ulogic_vector(3 downto 0);
		cur_pat		: in std_ulogic_vector(6 downto 0);
		led		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture Srcchooser_arch of Srcchooser is
	
	begin
	
end architecture;
