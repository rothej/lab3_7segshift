-- tb_seg7_controller.vhd, written by Josh Rothe 6 Feb 2020
-- This testbench verifies the sim functionality of the 
-- 7-segment controller written for lab 3. This tb simply
-- verifies the anodes work, and the values are read appropriately

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity tb_shiftReg is
end tb_shiftReg;

architecture behavior of tb_shiftReg is

-- define constants
constant c_clkPer	: time := 20 ns;		-- 100 MHz clk

component shiftReg is 
	port (		clk 		: in std_logic;
				reset 		: in std_logic;
				enable		: in std_logic;
				regIn		: in std_logic_vector(3 downto 0);
				regOut7		: out std_logic_vector(3 downto 0);
				regOut6		: out std_logic_vector(3 downto 0);
				regOut5		: out std_logic_vector(3 downto 0);
				regOut4		: out std_logic_vector(3 downto 0);
				regOut3		: out std_logic_vector(3 downto 0);
				regOut2		: out std_logic_vector(3 downto 0);
				regOut1		: out std_logic_vector(3 downto 0);
				regOut0		: out std_logic_vector(3 downto 0)
	);
end component;

-- signal instantiation
signal s_clk		: std_logic;
signal s_reset 		: std_logic;
signal s_enable 	: std_logic;
signal s_regIn		: std_logic_vector(3 downto 0);
signal s_regOut7	: std_logic_vector(3 downto 0);
signal s_regOut6	: std_logic_vector(3 downto 0);
signal s_regOut5	: std_logic_vector(3 downto 0);
signal s_regOut4	: std_logic_vector(3 downto 0);
signal s_regOut3	: std_logic_vector(3 downto 0);
signal s_regOut2	: std_logic_vector(3 downto 0);
signal s_regOut1	: std_logic_vector(3 downto 0);
signal s_regOut0	: std_logic_vector(3 downto 0);

begin
-- instantiate the unit under test, top lvl signals on right
uut : shiftReg
port map (	clk		=> s_clk,
			reset	=> s_reset,
			enable	=> s_enable,
			regIn	=> s_regIn,
			regOut7	=> s_regOut7,
			regOut6	=> s_regOut6,
			regOut5	=> s_regOut5,
			regOut4	=> s_regOut4,
			regOut3	=> s_regOut3,
			regOut2	=> s_regOut2,
			regOut1	=> s_regOut1,
			regOut0	=> s_regOut0
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
    wait;
end process;

-- enable pulse - set to 40 ns for faster sim
proc_pulse	: process
begin
	s_enable <= '0';
	wait for 70 ns;
	s_enable <= '1';
	wait for 10 ns;
end process;

-- signal input values test
proc_sig	: process
begin
	s_regIn <= "1000";
	wait for 41 ns;
	s_regIn <= "0111";
	wait for 40 ns;
	s_regIn <= "0110";
	wait for 40 ns;
	s_regIn <= "0101";
	wait for 40 ns;
	s_regIn <= "0100";
	wait for 40 ns;
	s_regIn <= "0011";
	wait for 40 ns;
	s_regIn <= "0010";
	wait for 40 ns;
	s_regIn <= "0001";
	wait for 40 ns;
end process;

end behavior;