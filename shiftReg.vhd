-- shiftReg.vhd, written by Josh Rothe 5 Feb 2020
-- This shifts values across outputs to be read
-- by a 7-segment controller

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity shiftReg is 
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
end shiftReg;

architecture behavior of shiftReg is

-- signal instantiation for output regs
signal s_reg7	: std_logic_vector(3 downto 0);
signal s_reg6	: std_logic_vector(3 downto 0);
signal s_reg5	: std_logic_vector(3 downto 0);
signal s_reg4	: std_logic_vector(3 downto 0);
signal s_reg3	: std_logic_vector(3 downto 0);
signal s_reg2	: std_logic_vector(3 downto 0);
signal s_reg1	: std_logic_vector(3 downto 0);
signal s_reg0	: std_logic_vector(3 downto 0);

begin

------- shifts each data input in based on enable pulse -------
proc_shift_reg	: process(clk,reset)
begin
	if (reset='1') then			-- asynchronous reset of outputs
		s_reg7	<= (others => '0');
		s_reg6	<= (others => '0');
		s_reg5	<= (others => '0');
		s_reg4	<= (others => '0');
		s_reg3	<= (others => '0');
		s_reg2	<= (others => '0');
		s_reg1	<= (others => '0');
		s_reg0	<= (others => '0');
	elsif (rising_edge(clk)) then
		if (enable='1') then	-- enable input from pulse
			s_reg7 <= s_reg6;			-- when enabled, shift all values
			s_reg6 <= s_reg5;			-- with input entering least sig reg
			s_reg5 <= s_reg4;
			s_reg4 <= s_reg3;
			s_reg3 <= s_reg2;
			s_reg2 <= s_reg1;
			s_reg1 <= s_reg0;
			s_reg0 <= regIn;
		end if;
	end if;
end process proc_shift_reg;
---------------------------------------------------------------

regOut7 <= s_reg7;	-- continuously assign signals to outputs
regOut6 <= s_reg6;
regOut5 <= s_reg5;
regOut4 <= s_reg4;
regOut3 <= s_reg3;
regOut2 <= s_reg2;
regOut1 <= s_reg1;
regOut0 <= s_reg0;

end behavior;
