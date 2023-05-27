library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity FALLING_EDGE_DETECTOR is
	port (
		-- Inputs
		RD_IN: in std_logic;
		-- Outputs
		FALLING: out std_logic
	);
end FALLING_EDGE_DETECTOR;
 
architecture BEHAVIORAL of FALLING_EDGE_DETECTOR is

	-- Prevent logic optimization
	attribute DONT_TOUCH: string;
	signal y1, delay1, delay2,
		delay3, delay4, delay5,
		delay6, delay7, delay8: std_logic;
	attribute DONT_TOUCH of
		y1, delay1, delay2,
		delay3, delay4, delay5,
		delay6, delay7, delay8: signal is "true";
 
begin
 
-- Add delays to increase pulse width
y1 <= not(not(not(RD_IN)));
delay1 <= not(not(y1));
delay2 <= not(not(delay1));
delay3 <= not(not(delay2));
delay4 <= not(not(delay3));
delay5 <= not(not(delay4));
delay6 <= not(not(delay5));
delay7 <= not(not(delay6));
delay8 <= not(not(delay7));
-- Z = not(y1) and not(RD#)
FALLING <= not(delay8) and not(RD_IN);
 
end BEHAVIORAL;
