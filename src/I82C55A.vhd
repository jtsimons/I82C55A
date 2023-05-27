library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity I82C55A is
	port (
		-- Active high inputs
		A0: in std_logic;
		RESET: in std_logic;
		-- Active low inputs
		CE: in std_logic;
		RD, WR: in std_logic;
		STB, ACK: in std_logic;
		-- Bidirectional ports
		D: inout std_logic_vector(7 downto 0);
		P: inout std_logic_vector(7 downto 0);
		-- Outputs
		BUFEN_P, BUFEN_D: out std_logic;
		MODE_OUT, INTE_OUT, DIR_OUT: out std_logic;
		INTR_OUT, IBF_OUT, OBF_OUT: out std_logic
	);
end I82C55A;

architecture BEHAVIORAL of I82C55A is

	-- Use DONT_TOUCH attribute to prevent logic optimization
	attribute DONT_TOUCH: string;
	-- Assign/initialize internal signals
	signal d_reg: std_logic_vector(7 downto 0) := (others => '0');
	signal p_reg: std_logic_vector(7 downto 0) := (others => '0');
	signal mode, inte, intr: std_logic := '0';
	signal dir, ibf, obf: std_logic := '1';
	signal rd_falling: std_logic := '0';
	signal wr_rising: std_logic := '0';
	attribute DONT_TOUCH of rd_falling: signal is "true";
	attribute DONT_TOUCH of wr_rising: signal is "true";
	signal intr_in1, ibf_in: std_logic := '0';
	signal intr_in2, obf_in: std_logic := '1';
	signal mode1_en_in, mode1_en_out: std_logic;
	
	-- Instantiate edge detector components
	component FALLING_EDGE_DETECTOR
		port (
			RD_IN: in std_logic;
			FALLING: out std_logic
		);
	end component;
	
	component RISING_EDGE_DETECTOR
		port (
			WR_IN: in std_logic;
			RISING: out std_logic
		);
	end component;
		
	-- Instantiate Mode 1 Input/Output components
	component MODE1_INPUT is
		port (
			RESET, ENABLE: in std_logic;
			RD, STB, A0: in std_logic;
			INTR, IBF: inout std_logic;
			Y1_OUT, Y2_OUT: inout std_logic
		);
	end component;
	
	component MODE1_OUTPUT is
		port (
			RESET, ENABLE: in std_logic;
			WR, ACK: in std_logic;
			INTR, OBF: out std_logic;
			Y1_OUT, Y2_OUT: out std_logic
		);
	end component;
	
begin

	-- Port maps for falling/rising edge detectors
	RD_EDGE_DETECTOR: FALLING_EDGE_DETECTOR
		port map (
			RD_IN => RD,
			FALLING => rd_falling
		);

	WR_EDGE_DETECTOR: RISING_EDGE_DETECTOR
		port map (
			WR_IN => WR,
			RISING => wr_rising
		);

	-- Buffer Enable definitions
	-- Enable Px input buffer
	BUFEN_P <= '0' when ((RD = '0' or rd_falling = '1') and CE = '0' and A0 = '0' and dir = '1')
		else '1';
	-- Enable Dx input buffer
	BUFEN_D <= '0' when ((WR = '0' or wr_rising = '1') and CE = '0')
		else '1';
	
	-- Mode 1 Enable definitions
	mode1_en_in <= dir and mode;
	mode1_en_out <= not(dir) and mode;
	
	-- Port maps for Mode 1 I/O
	MODE1_IN: MODE1_INPUT
		port map (
			ENABLE => mode1_en_in,
			RESET => RESET,
			RD => RD,
			STB => STB,
			A0 => A0,
			INTR => intr_in1,
			IBF => ibf_in,
			Y1_OUT => open,
			Y2_OUT => open
		);
	
	MODE1_OUT: MODE1_OUTPUT
		port map (
			ENABLE => mode1_en_out,
			RESET => RESET,
			WR => WR,
			ACK => ACK,
			INTR => intr_in2,
			OBF => obf_in,
			Y1_OUT => open,
			Y2_OUT => open
		);
	
	-- Control register
	mode <= '0' when (RESET = '1')
		else D(0) when (wr_rising = '1' and A0 = '1' and CE = '0')
		else mode;
	MODE_OUT <= mode;
		
	inte <= '0' when (RESET = '1')
		else D(1) when (wr_rising = '1' and A0 = '1' and CE = '0')
		else inte;
	INTE_OUT <= inte;
		
	dir <= '1' when (RESET = '1')
		else D(2) when (wr_rising = '1' and A0 = '1' and CE = '0')
		else dir;
	DIR_OUT <= dir;

	-- Status register
	intr <= intr_in1 and inte when (mode1_en_in = '1' and RESET = '0')
		else intr_in2 and inte when (mode1_en_out = '1' and RESET = '0')
		else '0';
	INTR_OUT <= intr;
	
	ibf <= ibf_in when (mode1_en_in = '1' and RESET = '0')
		else '0';
	IBF_OUT <= ibf;
	
	obf <= obf_in when (mode1_en_out = '1' and RESET = '0')
		else '1';
	OBF_OUT <= obf;
	
	-- Data/peripheral buses
	D <= (others => 'Z') when (CE = '1')
		else (0 => ibf, 1 => inte, 2 => intr, 3 => obf, others => '0') when (mode = '1' and RD = '0' and A0 = '1')
		else p_reg when (dir = '1')
		else (others => 'Z');
		
	P <= (others => 'Z') when (CE = '1')
		else d_reg when (dir = '0')
		else (others => 'Z');
	
	d_reg <= (others => '0') when (RESET = '1')
		else D when (wr_rising = '1' and A0 = '0' and CE = '0' and dir = '0')
		else d_reg;

	p_reg <= (others => '0') when (RESET = '1')
		else P when (rd_falling = '1' and A0 = '0' and CE = '0' and dir = '1' and mode = '1')
		else P when (RD = '0' and A0 = '0' and CE = '0' and dir = '1' and mode = '0')
		else p_reg;
		
end BEHAVIORAL;
