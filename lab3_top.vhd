-- lab3_top.vhd, written by Josh Rothe 5 Feb 2020
-- this module instantiates the 7 segment controller, shift reg,
-- and pulse generator/clk divider to shift LCD values continuously
-- across a display

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity lab3_top is port (
	clk 		: in std_logic;
	btnc 		: in std_logic;							-- reset
	sw			: in std_logic_vector(15 downto 0);		-- switches (16 switches)
	led 		: out std_logic_vector(15 downto 0); 	-- LEDs (16 LEDs)
	seg7_cath	: out std_logic_vector(7 downto 0); 	-- seg7 display signals
	an 			: out std_logic_vector(7 downto 0)
	);
end lab3_top;

architecture behavior of lab3_top is

-- signal instantiation
signal s_pulse			: std_logic;
signal s_displayChar7 	: std_logic_vector(3 downto 0);
signal s_displayChar6 	: std_logic_vector(3 downto 0);
signal s_displayChar5 	: std_logic_vector(3 downto 0);
signal s_displayChar4 	: std_logic_vector(3 downto 0);
signal s_displayChar3 	: std_logic_vector(3 downto 0);
signal s_displayChar2 	: std_logic_vector(3 downto 0);
signal s_displayChar1 	: std_logic_vector(3 downto 0);
signal s_displayChar0 	: std_logic_vector(3 downto 0);

-- constant definition
constant c_oneHz		: integer := 100000000;  -- to convert from 100Mhz to 1Hz
constant c_onekHz		: integer := 100000;	    -- to convert from 100Mhz to 1kHz

-- alias definition
alias a_swDisplayVal is sw(3 downto 0);			-- input value from switches

begin

-- instantiate components, top lvl signals on right
	pulseGen_1Hz_inst1	: entity pulseGenerator
	generic map(maxCount	=> c_oneHz)
	port map (	clk			=> clk,
				reset		=> btnc,
				pulseOut 	=> s_pulse
	);

	-- shift register handles the shifting/propagation of display values
	shiftReg_inst1		: entity shiftReg
	port map (	clk			=> clk,
				reset		=> btnc,
				enable 		=> s_pulse,
				regOut7		=> s_displayChar7,
				regOut6		=> s_displayChar6,
				regOut5		=> s_displayChar5,
				regOut4		=> s_displayChar4,
				regOut3		=> s_displayChar3,
				regOut2		=> s_displayChar2,
				regOut1		=> s_displayChar1,
				regOut0		=> s_displayChar0,
				regIn		=> a_swDisplayVal
	);

	-- controller reads whatever value the shift register presents it
	seg7_controller_inst1	: entity seg7_controller
	generic map ( 	pulseDiv	=> c_onekHz)		-- passes 1kHz constant in
	port map 	(	clk			=> clk,
					reset		=> btnc,
					en			=> seg7_cath,
					sigIn7		=> s_displayChar7,
					sigIn6		=> s_displayChar6,
					sigIn5		=> s_displayChar5,
					sigIn4		=> s_displayChar4,
					sigIn3		=> s_displayChar3,
					sigIn2		=> s_displayChar2,
					sigIn1		=> s_displayChar1,
					sigIn0		=> s_displayChar0,
					an			=> an
	);

-- LEDs indicate switch toggle, all switches enabled
led <= sw;

end behavior;