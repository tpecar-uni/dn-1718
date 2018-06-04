----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2016 03:52:42 PM
-- Design Name: 
-- Module Name: ps2cu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ps2cu is
    Port ( clk_i        : in STD_LOGIC;
           rst_i        : in STD_LOGIC;
           pulse_i      : in STD_LOGIC;
           skbddata_i   : in STD_LOGIC;
           we_o         : out STD_LOGIC;
			  ready_o		: out STD_LOGIC
           );
           
end ps2cu;

architecture Behavioral of ps2cu is

   --Use descriptive names for the states, like st1_reset, st2_search
   type state_type is (st_IDLE, st_START, st_B0, st_B1, st_B2, st_B3, 
   st_B4, st_B5, st_B6, st_B7, st_PAR);
   signal state, next_state : state_type;
   --Declare internal signals for all outputs of the state-machine
   signal we : std_logic;  -- example output signal
	signal ready : std_logic;
   
begin

    -- IO assignments:
   we_o <= we; 
	ready_o <= ready;
	
   -- register stanj:
   SYNC_PROC: process (clk_i)
   begin
      if (clk_i'event and clk_i = '1') then
         if (rst_i = '1') then
            state <= st_IDLE;
         else
            state <= next_state;
         -- assign other outputs to internal signals
         end if;
      end if;
   end process;
   
   
   -- racunanje izhodov:
  OUTPUT_DECODE: process (state, pulse_i, skbddata_i)
  begin
     --declare default value for all outputs to avoid latches
     we <= '0';  --default 
     ready <= '0';
     case (state) is
        when st_IDLE =>
           if (pulse_i = '1' and skbddata_i = '0') then
              we <= '0';
				  ready <= '0';
           end if;
        when st_START =>
           if pulse_i = '1' then
              we <= '1';
           end if;
        when st_B0 =>
           if pulse_i = '1' then
              we <= '1';
           end if;
        when st_B1 =>
           if pulse_i = '1' then
              we <= '1';
           end if;
        when st_B2 =>
           if pulse_i = '1' then
              we <= '1';
           end if;
        when st_B3 =>
           if pulse_i = '1' then
              we <= '1';
           end if;    
         when st_B4 =>
             if pulse_i = '1' then
                we <= '1';
             end if;
          when st_B5 =>
             if pulse_i = '1' then
                we <= '1';
             end if;
          when st_B6 =>
             if pulse_i = '1' then
                we <= '1';
             end if;
          when st_B7 =>
             if pulse_i = '1' then
                we <= '1';
             end if; 
          when st_PAR =>
                if (pulse_i = '1' and skbddata_i = '1') then
                   we <= '0';
						 ready <= '1';
                end if;
        when others =>
           we <= '0';
			  --ready <= '0';
     end case;
  end process;
   
   
-- racunanje novega stanja:
     NEXT_STATE_DECODE: process (state, pulse_i, skbddata_i)
        begin
           --declare default state for next_state to avoid latches
           next_state <= state;  --default is to stay in current state
           --insert statements to decode next_state
           --below is a simple example
           case (state) is
              when st_IDLE =>
                 if (pulse_i = '1' and skbddata_i = '0') then
                    next_state <= st_START;
                 end if;
              when st_START =>
                 if pulse_i = '1' then
                    next_state <= st_B0;
                 end if;
              when st_B0 =>
                 if pulse_i = '1' then
                    next_state <= st_B1;
                 end if;
              when st_B1 =>
                 if pulse_i = '1' then
                    next_state <= st_B2;
                 end if;
              when st_B2 =>
                 if pulse_i = '1' then
                    next_state <= st_B3;
                 end if;
              when st_B3 =>
                 if pulse_i = '1' then
                    next_state <= st_B4;
                 end if;    
               when st_B4 =>
                   if pulse_i = '1' then
                      next_state <= st_B5;
                   end if;
                when st_B5 =>
                   if pulse_i = '1' then
                      next_state <= st_B6;
                   end if;
                when st_B6 =>
                   if pulse_i = '1' then
                      next_state <= st_B7;
                   end if;
                when st_B7 =>
                   if pulse_i = '1' then
                      next_state <= st_PAR;
                   end if; 
                when st_PAR =>
                      if (pulse_i = '1' and skbddata_i = '1') then
                         next_state <= st_IDLE;
                      end if;
              when others =>
                 next_state <= st_IDLE;
           end case;
        end process;
         
   

end Behavioral;