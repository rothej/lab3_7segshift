-- tb_lab3_top.vhd, written by Josh Rothe 10 Feb 2020
-- Revised 17 Feb 2020 to incorporate decoder
-- This testbench verifies the sim functionality of the 
-- entire lab 3 design

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity tb_lab3_top is
end tb_lab3_top;

architecture behavior of tb_lab3_top is

-- define constants
constant c_clkPer	: time := 20 ns;		-- 100 MHz clk = 20 ns

component lab3_top is 
	port (	clk 		: in std_logic;
			btnc 		: in std_logic;		-- reset
			sw			: in std_logic_vector(15 downto 0);
			led 		: out std_logic_vector(15 downto 0);
			seg7_cath	: out std_logic_vector(7 downto 0);
			an 			: out std_logic_vector(7 downto 0)
	);
end component;

-- decoder for 7 segment display (sim only)
component seg7_interface_sim is
	port ( 	cathodes 	: in std_logic_vector (7 downto 0);
			anodes 		: in std_logic_vector (7 downto 0);
			display0 	: out std_logic_vector (3 downto 0);
			display1 	: out std_logic_vector (3 downto 0);
			display2 	: out std_logic_vector (3 downto 0);
			display3 	: out std_logic_vector (3 downto 0);
			display4 	: out std_logic_vector (3 downto 0);
			display5 	: out std_logic_vector (3 downto 0);
			display6 	: out std_logic_vector (3 downto 0);
			display7 	: out std_logic_vector (3 downto 0));
end component;

-- signal instantiation
signal s_clk		: std_logic;
signal s_btnc 		: std_logic;
signal s_sw 		: std_logic_vector(15 downto 0);
signal s_led		: std_logic_vector(15 downto 0);
signal s_seg7_cath	: std_logic_vector(7 downto 0);
signal s_an			: std_logic_vector(7 downto 0);
signal s_display0	: std_logic_vector(3 downto 0);
signal s_display1	: std_logic_vector(3 downto 0);
signal s_display2	: std_logic_vector(3 downto 0);
signal s_display3	: std_logic_vector(3 downto 0);
signal s_display4	: std_logic_vector(3 downto 0);
signal s_display5	: std_logic_vector(3 downto 0);
signal s_display6	: std_logic_vector(3 downto 0);
signal s_display7	: std_logic_vector(3 downto 0);

-- exit and initialization flags
signal f_exit		: boolean := false;
signal f_initialize	: boolean := false;

begin
-- instantiate the unit under test, top lvl signals on right
uut : lab3_top
port map (	clk			=> s_clk,
			btnc		=> s_btnc,
			sw			=> s_sw,
			led			=> s_led,
			seg7_cath	=> s_seg7_cath,
			an			=> s_an);
		
-- instantiate decoder
decode_uut : seg7_interface_sim
port map ( 	cathodes	=> s_seg7_cath,
			anodes 		=> s_an,
			display0 	=> s_display0,
			display1 	=> s_display1,
			display2 	=> s_display2,
			display3 	=> s_display3,
			display4 	=> s_display4,
			display5 	=> s_display5,
			display6 	=> s_display6,
			display7 	=> s_display7);

-- clock process, repeats until exit flag
proc_clock	: process
begin
    while f_exit = false loop
        s_clk <= '0';
        wait for c_clkPer/2;
        s_clk <= '1';
        wait for c_clkPer/2;
	end loop;
end process;

-- reset high at start (initialize)
proc_reset 	: process
begin
    s_btnc <= '1';
    wait for c_clkPer;
    s_btnc <= '0';
	wait for c_clkPer;
	f_initialize <= true;
    wait;
end process;

-- signal input values test - stimulus process
proc_sw	: process
begin
	s_sw <= "0000000000000010";
	wait for c_clkPer*100000000;
	s_sw <= "0000000000000101";
	wait for c_clkPer*100000000;
	s_sw <= "0000000000000011";
	wait for c_clkPer*100000000;
	f_exit <= true;			-- exit flag triggered at end
end process;

end behavior;