----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:33:01 02/17/2017 
-- Design Name: 
-- Module Name:    seg7 - Behavioral 
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

entity seg7 is
    Port ( clk_i : in  STD_LOGIC;
			  score_i : in  STD_LOGIC_VECTOR (7 downto 0);
			  clear_i : in  STD_LOGIC_VECTOR (7 downto 0);
           anode_o : out  STD_LOGIC_VECTOR (3 downto 0);
           cathode_o : out  STD_LOGIC_VECTOR (6 downto 0)
		);
end seg7;

architecture Behavioral of seg7 is

	signal number:std_logic_vector(3 downto 0);
	signal cathode:std_logic_vector(6 downto 0);
	signal anode:std_logic_vector(3 downto 0);
	
	signal anode_enable:std_logic;
	signal anode_enable_counter:std_logic_vector(7 downto 0);
	
begin
	anode_o <= anode;
	cathode_o <= cathode;

	
	process(clk_i)
		begin
			if clk_i'event and clk_i = '1' then
				if anode_enable = '1' then
					case anode is
						when "1110" => anode <= "1101";
						when "1101" => anode <= "1011";
						when "1011" => anode <= "0111";
						when "0111" => anode <= "1110";
						when others => anode <= "1110";
					end case;
					
					anode_enable_counter <= (others => '0');
				else 
					anode_enable_counter <= anode_enable_counter + 1;
				end if;
			end if;
		end process;

	process(anode_enable_counter) 
		begin
			if anode_enable_counter = "11001000" then
				anode_enable <= '1';
			else
				anode_enable <= '0';
			end if;
		end process;

	process(number)
		begin
			case number is
				when "0000" => cathode <= "1000000";
				when "0001" => cathode <= "1111001";
				when "0010" => cathode <= "0100100";
				when "0011" => cathode <= "0110000";
				when "0100" => cathode <= "0011001";
				when "0101" => cathode <= "0010010";
				when "0110" => cathode <= "0000010";
				when "0111" => cathode <= "1111000";
				when "1000" => cathode <= "0000000";
				when "1001" => cathode <= "0010000";
				when "1010" => cathode <= "0001000";
				when "1011" => cathode <= "0000011";
				when "1100" => cathode <= "1000110";
				when "1101" => cathode <= "0100001";
				when "1110" => cathode <= "0000110";
				when "1111" => cathode <= "0001110";
				when others => cathode <= "0000000";
			end case;
		end process;
		
	process(anode)	--izbira 4 bitov iz counta, ki se bo preslikal na prikazovalnik
		begin
			case anode is
				when "1110" => number <= score_i(3 downto 0);
				when "1101" => number <= score_i(7 downto 4);
				when "1011" => number <= clear_i(3 downto 0);
				when "0111" => number <= clear_i(7 downto 4);
				when others => number <= "0000";
			end case;
		end process;
		
end Behavioral;

