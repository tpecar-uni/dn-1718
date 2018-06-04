----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:04:32 02/06/2017 
-- Design Name: 
-- Module Name:    kbdDataSync - Behavioral 
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

entity kbdDataSync is
    Port ( clk_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
           kbddata_i : in  STD_LOGIC;
           dataSync_o : out  STD_LOGIC);
end kbdDataSync;

architecture Behavioral of kbdDataSync is

begin

process(clk_i) is
	begin
		if clk_i'event and clk_i = '1' then
			
			if reset_i = '1' then
				dataSync_o <= '1';
			
			else	
				if kbddata_i = '0' then
					dataSync_o <= '0';
				else 
					dataSync_o <= kbddata_i;
				end if;
				
			end if;
			
		end if;
	
	end process;

end Behavioral;

