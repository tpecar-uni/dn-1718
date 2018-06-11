----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    11:28:36 02/10/2017
-- Design Name:
-- Module Name:    prescaler - Behavioral
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

entity prescaler is

    Port ( clk_i 		: in  STD_LOGIC;
           reset_i	: in  STD_LOGIC;
           clk_o 		: out  STD_LOGIC;
			  hz_i   	: integer range 0 to 63
		);

end prescaler;


architecture Behavioral of prescaler is

	 signal max : integer range 0 to 9999999;
    signal counter : integer range 0 to 9999999 := 0;
	 signal newClk :  STD_LOGIC;

begin

	max <= 9999999 - (hz_i*900000);
	clk_o <= newClk;

	process (reset_i, clk_i)
	begin
		if (reset_i = '1') then
			counter <= 0;
			elsif rising_edge(clk_i) then
				if (counter = max) then
					 newClk <= '1';
					 counter <= 0;
				else
					newClk <= '0';
					 counter <= counter + 1;
				end if;
		end if;
	end process;

end Behavioral;
