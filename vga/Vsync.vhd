----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:59:46 12/01/2016 
-- Design Name: 
-- Module Name:    Vsync - Behavioral 
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

entity Vsync is
	Generic(
		BP : integer := 29;
		FP : integer := 10;
		SP : integer := 2;
		DT : integer := 480;
		ST : integer := 521
	);


    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rowclk : in  STD_LOGIC;
           vsync : out  STD_LOGIC;
           row : out  STD_LOGIC_VECTOR (9 downto 0);
           vvidon : out  STD_LOGIC);
end Vsync;

architecture Behavioral of Vsync is

	signal count:std_logic_vector(9 downto 0);

begin

---row
	row <= count;
	
	
---counter 
	process(clk)
		begin
			if clk'event and clk = '1' then
				if (rst= '1') then
					count <= (others => '0');
				
				else
					if rowclk = '1' then
						if count < ST then 
							count <= count + 1;
						else 
							count <= (others => '0');
						end if;
						
					else 
						count <= count;
					end if;
					
				end if;
				
			end if ;
		end process ;
		
		
---vsync
	process(count)
		begin
			if count >= (DT + FP) and count < (DT + FP + SP) then
				vsync <= '0';
			else
				vsync <= '1';
			end if;
		end process;
		
---hvidon
	process(count)
		begin
			if count < DT then
				vvidon <= '1';
			else
				vvidon <= '0';
			end if;
		end process;
		



end Behavioral;

