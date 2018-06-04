----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:01:15 02/07/2017 
-- Design Name: 
-- Module Name:    parity - Behavioral 
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

entity parity is
	Port (
		parity_i	: in STD_LOGIC;
		data_i	: in STD_LOGIC_VECTOR (7 downto 0);
		ok_o		: out STD_LOGIC
	);
end parity;

architecture Behavioral of parity is
	
	signal check : STD_LOGIC;

begin

	process (data_i, parity_i)
	begin
		check <= data_i(0) xor data_i(1) xor data_i(2) xor data_i(3) xor data_i(4) xor data_i(5) xor data_i(6) xor data_i(7) xor parity_i;
		if check = '1' then
			ok_o <= '1';
		else
			ok_o <= '0';
		end if;
	end process;

end Behavioral;

