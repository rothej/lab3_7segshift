-- pulseGenerator.vhd, written by Josh Rothe 5 Feb 2020
-- derived from Johns Hopkins EN.525.642.82.SP20, Module 3F lecture
-- Pulse counter acts as a clk divider for a configurable number of cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity pulseGenerator is
	generic (	maxCount: integer := 100);	-- default value of 10, configurable
	port (		clk		: in std_logic;
				reset	: in std_logic;
				pulseOut: out std_logic);
end pulseGenerator;

architecture behavioral of pulseGenerator is
	signal pulseCnt	: integer;
	signal clear	: std_logic;
begin
	-- Pulse Generator logic
	process(clk,reset)
	begin
		if (reset='1') then
			pulseCnt <= 0;	-- reset signal to 0s
		elsif (rising_edge(clk)) then
			if (clear='1') then				-- when pulse goes high,
				pulseCnt <= 0;	-- reset to 0 after one cycle
				clear <= '0';
			else							-- otherwise increment the count
				pulseCnt <= pulseCnt + 1;
				if (PulseCnt = maxCount) then
				    clear <= '1';
				end if;
			end if;
		end if;
	end process;
	-- clear and pulseOut only go high at peak of count
	pulseOut <= clear;
	
end behavioral;