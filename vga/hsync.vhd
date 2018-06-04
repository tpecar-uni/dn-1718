----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:01 11/24/2016 
-- Design Name: 
-- Module Name:    Hsync - Behavioral 
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

entity Hsync is
	Generic(
		BP : integer := 16;
		FP : integer := 48;
		SP : integer := 96;
		DT : integer := 640;
		ST : integer := 800
	);

    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           hsync : out  STD_LOGIC;
           hvidon : out  STD_LOGIC;
           column : out  STD_LOGIC_VECTOR (9 downto 0);
           rowclk : out  STD_LOGIC );
end Hsync;

architecture Behavioral of Hsync is

	signal count:std_logic_vector(9 downto 0);
	signal enable:std_logic;
	signal enable_count:std_logic_vector(1 downto 0);
	
begin 	
	
	column <= count;
	
---counter 
	process(clk)
		begin
			if clk'event and clk = '1' then
				if (rst= '1') then
					enable_count <= (others => '0');
					count <= (others => '0');
				else
					if enable = '1' then
						if count < ST then 
							count <= count + 1;
						else 
							count <= (others => '0');
						end if;
			
						enable_count <= (others => '0');
					
					else 
						enable_count <= enable_count + 1;
					end if;
				end if;
			end if ;
		end process ;

---prescaler
	process(enable_count)
		begin
			if enable_count = "01" then
				enable <= '1';
			else
				enable <= '0';
			end if;
		end process;
		
---hsync
	process(count)
		begin
			if count >= (DT + FP) and count < (DT + FP + SP) then
				hsync <= '0';
			else
				hsync <= '1';
			end if;
		end process;
		
---hvidon
	process(count)
		begin
			if count < DT then
				hvidon <= '1';
			else
				hvidon <= '0';
			end if;
		end process;
		


---rowclk
	process(count, enable_count)
		begin
			if count = (DT + FP + SP) and enable_count = "01" then 
				rowclk <= '1';
			else
				rowclk <= '0';
			end if;
		end process;
		
end Behavioral;

