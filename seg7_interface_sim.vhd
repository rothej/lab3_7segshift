-- seg7_interface_sim.vhd, written by Josh Rothe 17 Feb 2020
-- This module decodes and checks the values going to the 7 segment display
-- derived from sample code given in module 4E, Johns Hopkins EN.525.642.82.SP20

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity seg7_interface_sim is
	Port ( 	cathodes 	: in std_logic_vector (7 downto 0);
			anodes 		: in std_logic_vector (7 downto 0);
			display0 	: out std_logic_vector (3 downto 0);
			display1 	: out std_logic_vector (3 downto 0);
			display2 	: out std_logic_vector (3 downto 0);
			display3 	: out std_logic_vector (3 downto 0);
			display4 	: out std_logic_vector (3 downto 0);
			display5 	: out std_logic_vector (3 downto 0);
			display6 	: out std_logic_vector (3 downto 0);
			display7 	: out std_logic_vector (3 downto 0));
end seg7_interface_sim;

architecture behavior of seg7_interface_sim is

signal digit_decode : std_logic_vector(3 downto 0);
signal char0        : std_logic_vector(3 downto 0);
signal char1        : std_logic_vector(3 downto 0);
signal char2        : std_logic_vector(3 downto 0);
signal char3        : std_logic_vector(3 downto 0);
signal char4        : std_logic_vector(3 downto 0);
signal char5        : std_logic_vector(3 downto 0);
signal char6        : std_logic_vector(3 downto 0);
signal char7        : std_logic_vector(3 downto 0);

begin

--decoder
with cathodes select
digit_decode <= X"0" when "11000000",
				X"1" when "11111001",
				X"2" when "10100100",
				X"3" when "10110000",
				X"4" when "10011001",
				X"5" when "10010010",
				X"6" when "10000010",
				X"7" when "11111000",
				X"8" when "10000000",
				X"9" when "10010000",
				X"A" when "10001000",
				X"B" when "10000011",
				X"C" when "11000110",
				X"D" when "10100001",
				X"E" when "10000110",
				X"F" when others;

--Capture decoded character for each anode low signal (LATCHES! DO NOT MAKE THESE FOR HARDWARE DESIGNS!)
char0 <= digit_decode when anodes(0) = '0' else char0;
char1 <= digit_decode when anodes(1) = '0' else char1;
char2 <= digit_decode when anodes(2) = '0' else char2;
char3 <= digit_decode when anodes(3) = '0' else char3;
char4 <= digit_decode when anodes(4) = '0' else char4;
char5 <= digit_decode when anodes(5) = '0' else char5;
char6 <= digit_decode when anodes(6) = '0' else char6;
char7 <= digit_decode when anodes(7) = '0' else char7;

display0 <= char0;
display1 <= char1;
display2 <= char2;
display3 <= char3;
display4 <= char4;
display5 <= char5;
display6 <= char6;
display7 <= char7;

end behavior;