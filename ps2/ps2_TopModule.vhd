----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:08:15 02/06/2017 
-- Design Name: 
-- Module Name:    ps2_TopModule - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ps2 is
    Port ( clk_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
           kbdclk_i : in  STD_LOGIC;
           kbddata_i : in  STD_LOGIC;
           data_o : out  STD_LOGIC_VECTOR (7 downto 0);
           sc_ready_o : out STD_LOGIC);
end ps2;

architecture Behavioral of ps2 is

	component kbdClkSync
		Port(
			clk_i : in  STD_LOGIC;
			reset_i : in STD_LOGIC;
			kbdclk_i : in  STD_LOGIC;
         clksync_o : out  STD_LOGIC
		);
	end component;
	
	component negedge is
		Port ( clk_i 		: in  STD_LOGIC;
           reset_i 		: in  STD_LOGIC;
           clksync_i 	: in  STD_LOGIC;
           pulse_o 		: out  STD_LOGIC
		);
	end component;
	
	component kbdDataSync is
		Port ( 
			clk_i 			: in  STD_LOGIC;
			reset_i 			: in  STD_LOGIC;
			kbddata_i 		: in  STD_LOGIC;
			dataSync_o 		: out  STD_LOGIC
		);
	end component;
	
	component ps2cu is
		Port ( 
			clk_i        : in STD_LOGIC;
			rst_i        : in STD_LOGIC;
			pulse_i      : in STD_LOGIC;
			skbddata_i   : in STD_LOGIC;
			we_o         : out STD_LOGIC;
			ready_o		 : out STD_LOGIC
	  );
	end component;
	
	component shift is
		Port (
			clk_i			: in STD_LOGIC;
			reset_i		: in STD_LOGIC;
			we_i			: in STD_LOGIC;
			dataSync_i	: in STD_LOGIC;
			data_o		: out STD_LOGIC_VECTOR (7 downto 0);
			parity_o		: out STD_LOGIC
		);
	end component;
	
	component parity is
	Port (
		parity_i	: in STD_LOGIC;
		data_i	: in STD_LOGIC_VECTOR (7 downto 0);
		ok_o		: out STD_LOGIC
	);
	end component;
	
	
	-- generiran sinhron clock
	signal clkSync 	: STD_LOGIC;
	signal dataSync 	: STD_LOGIC;
	signal pulse 		: STD_LOGIC;
	signal we 			: STD_LOGIC;
	signal data			: STD_LOGIC_VECTOR (7 downto 0);
	signal parityBit	: STD_LOGIC;
	signal parityOK 	: STD_LOGIC;
	signal ready		: STD_LOGIC;
	
begin
	
	sc_ready_o <= parityOK and ready;
	data_o <= data;

	clkSyncModule: kbdClkSync
	port map (
		clk_i => clk_i,
		reset_i => reset_i,
		kbdclk_i => kbdclk_i,
		clksync_o => clkSync
	);
	
	dataSyncModule: kbdDataSync
	port map (
		clk_i => clk_i,
		reset_i => reset_i,
		kbddata_i => kbddata_i,
		dataSync_o => dataSync
	);
	
	negedgeModule: negedge
	port map (
		clk_i => clk_i,
		reset_i => reset_i,
		clksync_i => clkSync,
		pulse_o => pulse
	);
	
	cu: ps2cu
	port map (
		clk_i => clk_i,
		rst_i => reset_i,
		pulse_i => pulse,
		skbddata_i => dataSync,
		we_o => we,
		ready_o => ready
	);
	
	shiftModule: shift
	port map (
		clk_i => clk_i,
		reset_i => reset_i,
		we_i => we,
		dataSync_i => dataSync,
		data_o => data,
		parity_o => parityBit
	);
	
	parityModule: parity
	port map(
		parity_i	=> parityBit,
		data_i => data,
		ok_o => parityOK
	);

end Behavioral;

