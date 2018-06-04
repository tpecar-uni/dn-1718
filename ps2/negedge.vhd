----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:52:58 02/06/2017 
-- Design Name: 
-- Module Name:    negedge - Behavioral 
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

entity negedge is
    Port ( clk_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
           clksync_i : in  STD_LOGIC;
           pulse_o : out  STD_LOGIC);
end negedge;

--- MEALYJEV AVTOMAT
architecture Behavioral of negedge is
	type state_type is ( ST_idle, ST_pulse ); -- možna stanja
	signal state , next_state : state_type;
	
	signal output : STD_LOGIC;
	
begin

	pulse_o <= output;
	
	SYNC_PROC: process ( clk_i ) -- delovanje registra stanj
	begin
		if (clk_i'event and clk_i = '1') then
			if ( reset_i = '1') then
				state <= ST_idle;
			else
				state <= next_state;
			end if;
		end if;
	end process;


   NEXT_STATE_DECODE: process (state, clksync_i)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      
      case (state) is
         when ST_idle =>
            if clksync_i = '0' then
               next_state <= state;
				else
					next_state <= ST_pulse;
            end if;
				
         when ST_pulse =>
            if clksync_i = '1' then
               next_state <= state;
				else
					next_state <= ST_idle;
            end if;

         when others =>
            next_state <= state;
      end case;
   end process;


--MEALY State-Machine - Outputs based on state and inputs
   OUTPUT_DECODE: process (clk_i)
   begin
      --insert statements to decode internal output signals
      --below is simple example
		if (clk_i'event and clk_i = '1') then
			if (state = ST_pulse and clksync_i = '0' and output = '0') then
				output <= '1';
			else 
				output <= '0';
			end if;
		end if;
		
   end process;


end Behavioral;

