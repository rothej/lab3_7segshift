-- seg7_controller.vhd, written by Josh Rothe 5 Feb 2020
-- This defines a 7 segment display controller that utilizes
-- refresh rates to display 8 diff values across a display

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity seg7_controller is 
	generic (	pulseDiv	: integer := 10);	-- default value of 10, configurable
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
				an 			: out std_logic_vector(7 downto 0)
	);
end seg7_controller;

architecture behavior of seg7_controller is

-- signal instantiation
signal s_pulse		: std_logic;	-- enable synced with refresh rate of display
signal s_digit		: std_logic_vector(3 downto 0);
signal s_sel_an		: std_logic_vector(2 downto 0);	-- selects anode and cathode values

begin

-- instantiate components, top lvl signals on right
	pulseGen_1kHz_inst1	: entity pulseGenerator
	generic map(maxCount	=> pulseDiv)
	port map (	clk			=> clk,
				reset		=> reset,
				pulseOut	=> s_pulse
	);

	seg7hex_inst1	: entity seg7hex 
	port map (	digit	=> s_digit,
				seg7	=> en
	);

------- calculates which s_sel_an value to use based on pulse count -------
proc_calc_anode	: process(clk,reset)
    variable anodeCount : std_logic_vector(2 downto 0);     -- counts through the 8 values
begin
	if (reset='1') then
		anodeCount	:= (others => '0');	-- asynchronous reset of count
	elsif (rising_edge(clk)) then
		if (s_pulse='1') then			-- only triggers on a pulse
			if (anodeCount = "111") then
				anodeCount	:= "000";			-- cycle from 7 back to 0
			else
				anodeCount := std_logic_vector( unsigned(anodeCount) + 1 );	-- otherwise increment
			end if;
		end if;
	end if;
	s_sel_an <= anodeCount;
end process proc_calc_anode;
---------------------------------------------------------------------------

-- reads s_sel_an and outputs a decoded value to anodes --
-- also selects display value to send to 7-seg encoder ---
proc_set_an	: process(clk)
begin
    if (rising_edge(clk)) then
        case s_sel_an is
            when "000" =>
                an <= "11111110";
                s_digit	<= sigIn0;
            when "001" =>
                an <= "11111101";
                s_digit	<= sigIn1;
            when "010" =>
                an <= "11111011";
                s_digit	<= sigIn2;
            when "011" =>
                an <= "11110111";
                s_digit	<= sigIn3;
            when "100" =>
                an <= "11101111";
                s_digit	<= sigIn4;
            when "101" =>
                an <= "11011111";
                s_digit	<= sigIn5;
            when "110" =>
                an <= "10111111";
                s_digit	<= sigIn6;
            when others =>
                an <= "01111111";
                s_digit	<= sigIn7;
        end case;
    end if;
end process proc_set_an;
----------------------------------------------------------

end behavior;