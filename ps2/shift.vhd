----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:52:16 02/07/2017 
-- Design Name: 
-- Module Name:    shift - Behavioral 
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

entity shift is
	Port (
		clk_i			: in STD_LOGIC;
		reset_i		: in STD_LOGIC;
		we_i			: in STD_LOGIC;
		dataSync_i	: in STD_LOGIC;
		data_o		: out STD_LOGIC_VECTOR (7 downto 0);
		parity_o		: out STD_LOGIC
	);
end shift;

architecture Behavioral of shift is

	signal data	: STD_LOGIC_VECTOR (8 downto 0);

begin

	data_o <= data(7 downto 0);
	parity_o <= data(8);
	
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (reset_i = '1') then
				data <= (others => '0');
			elsif (we_i = '1') then
				data(0) <= data(1);
				data(1) <= data(2);
				data(2) <= data(3);
				data(3) <= data(4);
				data(4) <= data(5);
				data(5) <= data(6);
				data(6) <= data(7);
				data(7) <= data(8);
				data(8) <= dataSync_i;
			end if;
		end if;
	end process;

end Behavioral;

