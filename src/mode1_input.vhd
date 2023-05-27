library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity MODE1_INPUT is
	port (
		-- Inputs
		ENABLE, RESET: in std_logic;
		RD, STB, A0: in std_logic;
		-- Bidirectional ports
		INTR, IBF: inout std_logic;
		Y1_OUT, Y2_OUT: inout std_logic
	);
end MODE1_INPUT;
 
architecture BEHAVIORAL of MODE1_INPUT is

	-- Initialize temp signals for logic functions
	signal y1, y2: std_logic := '0';
 
begin

	-- Latch states to allow reading of status register (A0 = 1)
	y1 <= ((not(STB)) or
		(y1 and RD) or
		(y1 and not(y2))) and not(RESET) and ENABLE when (A0 = '0')
		else y1;

	y2 <= ((not(y1) and y2 and not(STB)) or
		(y2 and not(RD) and STB) or
		(y1 and not(RD) and STB) or
		(not(y1) and y2 and not(RD))) and not(RESET) and ENABLE when (A0 = '0')
		else y2;

	INTR <= (y1 and RD and STB) when (A0 = '0')
		else INTR;

	IBF <= (y1 or not(STB) or (y2 and not(RD))) when (A0 = '0')
		else IBF;
 
	-- Y = y
	Y1_OUT <= y1;
	Y2_OUT <= y2;
 
end BEHAVIORAL;
