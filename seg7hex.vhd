-- seg7hex.vhd, written by Josh Rothe 30 Jan 2020
-- derived from sample code from Lab 1
-- this module decodes the input value into outputs for the 7seg display

library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity seg7hex is
	port(
		digit	: in std_logic_vector(3 downto 0);
		seg7	: out std_logic_vector(7 downto 0));
end seg7hex;

architecture behavior of seg7hex is

begin

with digit select	-- defines the value output to the 7 segment display. Low = illuminate for cathode
	seg7 <=	
		"11000000" when x"0" ,
		"11111001" when x"1" ,
		"10100100" when x"2" ,
		"10110000" when x"3" ,
		"10011001" when x"4" ,
		"10010010" when x"5" ,
		"10000010" when x"6" ,
		"11111000" when x"7" ,
		"10000000" when x"8" ,
		"10010000" when x"9" ,
		"10001000" when x"A" ,
		"10000011" when x"B" ,
		"11000110" when x"C" ,
		"10100001" when x"D" ,
		"10000110" when x"E" ,
		"10001110" when others;	-- covers h'F, in sim it will also cover X,Z etc values

end behavior;