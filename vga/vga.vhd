----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:31:25 12/01/2016 
-- Design Name: 
-- Module Name:    vga - Behavioral 
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
use IEEE. STD_LOGIC_ARITH. ALL;
use IEEE. STD_LOGIC_UNSIGNED. ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  vsync_o : out  STD_LOGIC;
			  hsync_o : out  STD_LOGIC;
			  vidon_o : out STD_LOGIC;
			  row_o : out  STD_LOGIC_VECTOR (9 downto 0);
			  column_o : out  STD_LOGIC_VECTOR (9 downto 0)
			);
end vga;

architecture Behavioral of vga is
	
	component Hsync
		Generic(
			BP : integer := 16;
			FP : integer := 48;
			SP : integer := 96;
			DT : integer := 640;
			ST : integer := 800
		);
		Port ( 
			clk : in  STD_LOGIC;
			rst : in  STD_LOGIC;
			hsync : out  STD_LOGIC;
			hvidon : out  STD_LOGIC;
			column : out  STD_LOGIC_VECTOR (9 downto 0);
			rowclk : out  STD_LOGIC 
		);
	end component;
	
	component Vsync
		Generic(
		BP : integer := 29;
		FP : integer := 10;
		SP : integer := 2;
		DT : integer := 480;
		ST : integer := 521
	);
    Port ( 
		clk : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		rowclk : in  STD_LOGIC;
		vsync : out  STD_LOGIC;
		row : out  STD_LOGIC_VECTOR (9 downto 0);
		vvidon : out  STD_LOGIC
		);
	end component;
	
	
	signal rowclk 		: STD_LOGIC;
	signal hvidon 		: STD_LOGIC;
	signal vvidon 		: STD_LOGIC;
	--signal column		: STD_LOGIC_VECTOR (9 downto 0);
	--signal row			: STD_LOGIC_VECTOR (8 downto 0);
	
begin

	vidon_o <= hvidon and vvidon;
	
hsyncModule : Hsync
generic map (
		FP => 16,
		BP => 48,
		SP => 96,
		DT => 640,
		ST => 800
	)
port map (
		clk => clk,
		rst => rst,
		hsync	=> hsync_o,
		rowclk => rowclk,
		hvidon => hvidon,
		column => column_o
	);
	
vsyncModule : Vsync
generic map (
		BP => 33,
		FP => 10,
		SP => 2,
		DT => 480,
		ST => 525
	)
port map (
		clk => clk,
		rst => rst,
		rowclk => rowclk,
		vsync => vsync_o,
		vvidon => vvidon,
		row => row_o
	);


end Behavioral;

