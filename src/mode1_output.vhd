library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity MODE1_OUTPUT is
	port (
		-- Inputs
		ENABLE, RESET: in std_logic;
		WR, ACK: in std_logic;
		-- Outputs
		INTR, OBF: out std_logic;
		Y1_OUT, Y2_OUT: out std_logic
	);
end MODE1_OUTPUT;
 
architecture BEHAVIORAL of MODE1_OUTPUT is

	-- Initialize temp signals for logic functions
	signal y1, y2: std_logic := '0';
 
begin

	y1 <= ((not(WR) and ACK) or
		(y1 and ACK) or
		(y1 and not(y2) and WR)) and not(RESET) and ENABLE;

	y2 <= ((y1 and y2 and not(ACK)) or
		(y2 and WR and not(ACK)) or
		(y1 and WR and not(ACK)) or
		(not(y1) and y2 and not(WR) and ACK)) and not(RESET) and ENABLE;

	INTR <= (not(y1) and not(y2) and WR) or (not(y1) and WR and ACK);

	OBF <= not(ACK) or not(WR) or not(y1);
 
	-- Y = y
	Y1_OUT <= y1;
	Y2_OUT <= y2;
 
end BEHAVIORAL;
