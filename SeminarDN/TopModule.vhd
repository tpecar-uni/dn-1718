----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:09:24 02/09/2017 
-- Design Name: 
-- Module Name:    TopModule - Behavioral 
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

entity TopModule is
    Port ( clk_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
			  restart_i : in STD_LOGIC;
			  
			  -- ps2
           kbdclk_i : in  STD_LOGIC;
           kbddata_i : in  STD_LOGIC;
			  data_o : out  STD_LOGIC_VECTOR (7 downto 0);
           sc_ready_o : out STD_LOGIC;
			  
			  -- vga
           vsync_o : out  STD_LOGIC;
           hsync_o : out  STD_LOGIC;
           r_o : out  STD_LOGIC_VECTOR (2 downto 0);
           g_o : out  STD_LOGIC_VECTOR (2 downto 0);
           b_o : out  STD_LOGIC_VECTOR (1 downto 0);
			  
			  -- segment display
			  anode_o : out  STD_LOGIC_VECTOR (3 downto 0);
			  cathode_o : out  STD_LOGIC_VECTOR (6 downto 0)
		);
			  
end TopModule;

architecture Behavioral of TopModule is

	component seg7 is
    Port ( 
		clk_i : in  STD_LOGIC;
		score_i : in  STD_LOGIC_VECTOR (7 downto 0);
		clear_i : in  STD_LOGIC_VECTOR (7 downto 0);
		anode_o : out  STD_LOGIC_VECTOR (3 downto 0);
		cathode_o : out  STD_LOGIC_VECTOR (6 downto 0)
	);
	end component;

	
	component prescaler is
		Port (
			clk_i : in  STD_LOGIC;
			reset_i : in  STD_LOGIC;
			clk_o : out  STD_LOGIC;
			hz_i : integer range 0 to 63
		);		  
	end component;
	
	component ps2 is
		Port ( 
			clk_i : in  STD_LOGIC;
			reset_i : in  STD_LOGIC;
			kbdclk_i : in  STD_LOGIC;
			kbddata_i : in  STD_LOGIC;
			data_o : out  STD_LOGIC_VECTOR (7 downto 0);
			sc_ready_o : out STD_LOGIC
		);
	end component;
	
	component vga is
		Port ( 
			clk : in  STD_LOGIC;
			rst : in  STD_LOGIC;
			vsync_o : out  STD_LOGIC;
			hsync_o : out  STD_LOGIC;
			vidon_o : out  STD_LOGIC;
			
			row_o : out  STD_LOGIC_VECTOR (9 downto 0);
			column_o : out  STD_LOGIC_VECTOR (9 downto 0)
		);
	end component;
	
	component RAM32x40 is
		Port ( 
			clk_i 		: in  STD_LOGIC;
			reset_i		: in  STD_LOGIC;
			we_i 			: in  STD_LOGIC;
			addrIN_i 	: in  STD_LOGIC_VECTOR (4 downto 0);
			addrOUT_i 	: in  STD_LOGIC_VECTOR (4 downto 0);
			data_i 		: in 	STD_LOGIC_VECTOR (0 to 39);
			data_o 		: out  STD_LOGIC_VECTOR (0 to 39);
			bit_o			: out STD_LOGIC_VECTOR (0 to 39);
			clear_i		: in STD_LOGIC
		);
		end component;
	
	signal pClk			: STD_LOGIC;
	
	signal vidon 		: STD_LOGIC;
	signal column		: STD_LOGIC_VECTOR (9 downto 0);
	signal row			: STD_LOGIC_VECTOR (9 downto 0);
	
	signal ps2data		: STD_LOGIC_VECTOR (7 downto 0);
	signal ps2ready   : STD_LOGIC;
	
	signal rAddrIn 	: STD_LOGIC_VECTOR (4 downto 0) := "11011";
	signal rAddrOut	: STD_LOGIC_VECTOR (4 downto 0) := "00000";
	signal rWe		   : STD_LOGIC;
	signal rDataIn    : STD_LOGIC_VECTOR (0 to 39);
	signal rDataOut   : STD_LOGIC_VECTOR (0 to 39);
	signal rBit			: STD_LOGIC_VECTOR (0 to 39);
	
	signal indexX 		: integer range 0 to 39;
	signal indexY 		: integer range 0 to 29;
	
	signal snakeX		: integer range 0 to 40 := 37;
	signal snakeY		: integer range 0 to 30 := 27;
	signal direction	: STD_LOGIC_VECTOR (1 downto 0) := "01"; --00 desna; 01 gor; 10 levo; 11 dol	
	signal foodX		: integer range 0 to 40 := 25;
	signal foodY		: integer range 0 to 30 := 25;
	signal freeX		: integer range 0 to 40;
	signal freeY		: integer range 0 to 30;
	signal free			: STD_LOGIC;
	signal clear		: STD_LOGIC_VECTOR (7 downto 0) := "00000011";
	signal score 		: STD_LOGIC_VECTOR (7 downto 0) := "00000000";
	signal clearPulse	: STD_LOGIC;
	signal clearSafe	: STD_LOGIC;
	signal gameOver	: STD_LOGIC;
	signal speed		: integer range 0 to 63 := 0;

	-- debug
	--signal tempX		: STD_LOGIC_VECTOR (7 downto 0);
	--signal tempY		: STD_LOGIC_VECTOR (7 downto 0);
	

begin
	
	data_o <= ps2data;
	sc_ready_o <= ps2ready;
	
	--tempX <= conv_std_logic_vector(snakeX, tempX'length);
	--tempY <= conv_std_logic_vector(snakeY, tempY'length);
	
	segModule: seg7
	port map (
		clk_i => clk_i,
		score_i => score,
		clear_i => clear,
		anode_o => anode_o,
		cathode_o => cathode_o
	);
	
	prescalerModule: prescaler
	port map (
		clk_i => clk_i,
		reset_i => reset_i,
		clk_o => pClk,
		hz_i => speed
	);
	
	ps2Module: ps2
	port map (
		clk_i => clk_i,
		reset_i => reset_i,
		kbdclk_i => kbdclk_i,
		kbddata_i => kbddata_i,
		data_o => ps2data,
		sc_ready_o => ps2ready
	);
	
	vgaModule: vga
	port map (
		clk => clk_i,
		rst => reset_i,
		vsync_o => vsync_o,
		hsync_o => hsync_o,
		vidon_o => vidon,
		row_o => row,
		column_o => column
	);
	
	ram: RAM32x40
	port map (
		clk_i => clk_i,
		reset_i => reset_i,
		we_i => rWe,
		addrIN_i => rAddrIn,
		addrOUT_i => rAddrOut,
		data_i => rDataIn,
		data_o => rDataOut,
		bit_o => rBit,
		clear_i => clearPulse
	);
	
	-- change grid index
	process(column)
	begin
		indexX <= (conv_integer(column)/16);

	end process;
	
	process(row)
	begin
		indexY <= (conv_integer(row))/16;
		rAddrOut <= conv_std_logic_vector((conv_integer(row)/16), rAddrOut'length);
		
	end process;
	
	process(vidon, indexX, rDataOut)
	begin
	
		if vidon = '1' then
			
			if (rDataOut(indexX) = '1') then
				r_o <= "010";
				g_o <= "111";
				b_o <= "10";
			
			elsif (indexX = foodX and indexY = foodY) then
				r_o <= "111";
				g_o <= "111";
				b_o <= "11";
			
			elsif (gameOver = '1' and indexX = snakeX and indexY = snakeY) then
				r_o <= "000";
				g_o <= "000";
				b_o <= "00";
			
			elsif (gameOver = '1' and rDataOut(indexX) /= '1') then
				r_o <= "111";
				g_o <= "000";
				b_o <= "00";
			
			elsif (indexX = foodX or indexY = foodY ) then
				r_o <= "110";
				g_o <= "011";
				b_o <= "10";
			
			elsif (rDataOut(indexX) = '0') then
				r_o <= conv_std_logic_vector(speed/2, r_o'length);
				g_o <= conv_std_logic_vector((conv_integer(indexY)/2), r_o'length);
				b_o <= "01";

				
			else 
				r_o <= "000";
				g_o <= "000";
				b_o <= "00";
			end if;
			
--			elsif (gameOver = '0' and (foodX /= snakeX and foodY /= snakeY)) then
--				r_o <= "001";
--				g_o <= "101";
--				b_o <= "11";
--				
--			else 
--				r_o <= "000";
--				g_o <= "000";
--				b_o <= "00";
--			end if;
			
		else
			r_o <= "000";
			g_o <= "000";
			b_o <= "00";
		end if;
		
	end process;
	
	process(clk_i, pClk) 
	begin
		if (clk_i'event and clk_i = '1') then
			
			if (reset_i = '1' or restart_i = '1') then
				snakeX <= 37;
				snakeY <= 27;
			
			elsif (pClk = '1' and gameOver = '0') then
				-- right
				if (direction = "00") then
					snakeX <= snakeX + 1;
				-- up
				elsif (direction = "01") then
					snakeY <= snakeY - 1;
				-- left
				elsif (direction = "10") then
					snakeX <= snakeX - 1;
				-- down
				elsif (direction = "11") then
					snakeY <= snakeY + 1;
				end if;
				
				rWe <= '1';

			else 
				rWe <= '0';
			end if;
			
		
		end if;
	end process;
	
	process(snakeX, snakeY) 
	begin	
		rAddrIn <= conv_std_logic_vector((conv_integer(snakeY)), rAddrIn'length);
		rDataIn <= (others => '0');
		rDataIn(snakeX) <= '1';		
		
		if (snakeX >= 40 or snakeY >= 30) then
			gameOver <= '1';
		
		elsif (rBit(snakeX) = '0') then
			if (clearSafe = '1') then
				gameOver <= '0';
			else
				gameOver <= '1';
			end if;
		
		else
			gameOver <= '0';
		end if;

	end process;
	
		
	process(clk_i, free, foodX, foodY)
	begin
		if (clk_i'event and clk_i = '1') then
			if (reset_i = '1' or restart_i = '1') then
				score <= (others => '0');
				clear <=	"00000011";
				
			elsif (snakeX = foodX and snakeY = foodY) then
				score <= score + 1;
				clear <= clear - 1;
				free <= '0';
				foodX <= freeX;
				foodY <= freeY;

				
			end if;
			
			if (clear = "00000000") then
				clear <=	"00000011";
			end if;
			
			if (free = '0' or freeX >= 40 or freeY >= 30 or rDataOut(freeX) = '1') then
				if (rDataOut(indexX) = '0') then
					freeX <= indexX;
					freeY <= indexY;
					free <= '1';
				end if;
			end if;
			
		end if;
		
		if (foodX > 39 or foodY > 29) then
			foodX <= 20;
			foodY <= 0;
		end if;
	end process;

	process(clk_i, clear, pClk)
	begin
		if (clk_i'event and clk_i = '1') then
			if (reset_i = '1') then
				speed <= 0;
			
			elsif (clear = 0) then
				clearPulse <= '1';
				clearSafe <= '1';
				speed <= speed + 1;
			
			elsif (restart_i = '1') then
				clearPulse <= '1';
				clearSafe <= '1';
					
			elsif(pClk = '1') then
				clearSafe <= '0';
			
			else 
				clearPulse <= '0';
			end if;
		end if;
	end process;

	process(clk_i, ps2ready)
	begin
		if (clk_i'event and clk_i = '1') then
		
			if (reset_i = '1') then
				direction <= "01";
			elsif (ps2ready = '1') then
				if (ps2data = "01110101") then 		-- up
					direction <= "01";
									
				elsif (ps2data = "01110010") then	-- down
					direction <= "11";
									
				elsif (ps2data = "01110100") then	-- right
					direction <= "00";
									
				elsif (ps2data = "01101011") then	-- left
					direction <= "10";
								
				end if;

			end if;
		end if;
	end process;
	
end Behavioral;

