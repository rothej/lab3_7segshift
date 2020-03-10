-- tb_seg7_controller.vhd, written by Josh Rothe 6 Feb 2020
-- This testbench verifies the sim functionality of the 
-- 7-segment controller written for lab 3. This tb simply
-- verifies the anodes work, and the values are read appropriately

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity tb_seg7_controller is
end tb_seg7_controller;

architecture behavior of tb_seg7_controller is

-- define constants
constant c_pulseDiv : unsigned := "100000";	-- set for 1kHz
constant c_clkPer	: time := 20 ns;		-- 100 MHz clk

component seg7_controller is 
	generic (	pulseDiv	: unsigned := "10");	-- pull from above, overrides default
	port (		clk 		: in std_logic;
				reset 		: in std_logic;
				sigIn7		: in std_logic_vector(3 downto 0);
				sigIn6		: in std_logic_vector(3 downto 0);
				sigIn5		: in std_logic_vector(3 downto 0);
				sigIn4		: in std_logic_vector(3 downto 0);
				sigIn3		: in std_logic_vector(3 downto 0);
				sigIn2		: in std_logic_vector(3 downto 0);
				sigIn1		: in std_logic_vector(3 downto 0);
				sigIn0		: in std_logic_vector(3 downto 0);
				en			: out std_logic_vector(7 downto 0); 	-- seg7 display signals
				an 			: out std_logic_vector(7 downto 0)		-- annodes for activation
	);
end component;

-- signal instantiation
signal s_clk	: std_logic;
signal s_reset 	: std_logic;
signal s_sigIn7	: std_logic_vector(3 downto 0);
signal s_sigIn6	: std_logic_vector(3 downto 0);
signal s_sigIn5	: std_logic_vector(3 downto 0);
signal s_sigIn4	: std_logic_vector(3 downto 0);
signal s_sigIn3	: std_logic_vector(3 downto 0);
signal s_sigIn2	: std_logic_vector(3 downto 0);
signal s_sigIn1	: std_logic_vector(3 downto 0);
signal s_sigIn0	: std_logic_vector(3 downto 0);
signal s_en		: std_logic_vector(7 downto 0);
signal s_an 	: std_logic_vector(7 downto 0);

begin
-- instantiate the unit under test, top lvl signals on right
uut : seg7_controller
generic map(pulseDiv	=> c_pulseDiv)
port map (	clk			=> s_clk,
            reset       => s_reset,
			sigIn7		=> s_sigIn7,
			sigIn6		=> s_sigIn6,
			sigIn5		=> s_sigIn5,
			sigIn4		=> s_sigIn4,
			sigIn3		=> s_sigIn3,
			sigIn2		=> s_sigIn2,
			sigIn1		=> s_sigIn1,
			sigIn0		=> s_sigIn0,
			en			=> s_en,
			an			=> s_an
		);

-- clock process, repeats indefinitely
proc_clock	: process
begin
	s_clk <= '0';
	wait for c_clkPer/2;
	s_clk <= '1';
	wait for c_clkPer/2;
end process;

-- reset high at start (initialize)
proc_reset 	: process
begin
    s_reset <= '1';
    wait for c_clkPer;
    s_reset <= '0';
    wait;	-- does not repeat
end process;

-- signal input values test
proc_sig	: process
begin
	s_sigIn7 <= "1000";
	s_sigIn6 <= "0111";
	s_sigIn5 <= "0110";
	s_sigIn4 <= "0101";
	s_sigIn3 <= "0100";
	s_sigIn2 <= "0011";
	s_sigIn1 <= "0010";
	s_sigIn0 <= "0001";
	wait;
end process;

end behavior;