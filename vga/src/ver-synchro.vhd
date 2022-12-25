-- ===========================================================
--                          IMPORTANT
-- Synchronization is based on a RESOLUTION of 640x480 AT 60Hz
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity v_synchronizer is
  port (
    clk, reset                      : in std_logic;
    count_in, y                     : in std_logic_vector(9 downto 0);  
    vsync, e_vi, r_vi               : out std_logic
  ) ;
end entity v_synchronizer;

architecture rtl of v_synchronizer is
    type fsm_state_type is (prime, idle, init, v_front, v_sync, v_back);
    signal state, new_state     : fsm_state_type;

begin
    
    reg : process( clk, reset )
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                state   <= prime;
            else
                state   <= new_state;
            end if;
        end if;
    end process ; -- reg
    
    -- Module relies on the horizontal synchronizer to reset the counter, as they should be perfectly synced

    synchro : process( state, count_in )
    begin
        case state is

            -- (Re)Initialise FSM
            when prime =>
                vsync       <= '1';
                e_vi        <= '0';
                r_vi        <= '1';

                new_state   <= idle;
                
            when idle =>
                vsync       <= '1';
                e_vi        <= '0';
                r_vi        <= '0';
            
            if (unsigned(count_in) >= to_unsigned(799, 10)) then
                new_state   <= init;
            else
                new_state   <= idle;
            end if;
                
            -- Reset counter and prepare for new horizontal cycle
            when init =>
                vsync       <= '1';
                e_vi        <= '1';
                r_vi        <= '0';

                -- Transition to appropriate vertical region
                if(unsigned(y) >= to_unsigned(525, 10)) then
                    new_state   <= prime;
                elsif(unsigned(y) >= to_unsigned(492, 10)) then
                    new_state   <= v_back;
                elsif(unsigned(y) >= to_unsigned(490, 10)) then
                    new_state   <= v_sync;
                elsif(unsigned(y) >= to_unsigned(480, 10)) then
                    new_state   <= v_front;
                else
                    new_state   <= idle;
                end if;
            
            -- ========================================
            -- Start of Vertical Sync Cycle
            -- ========================================

            when v_front =>
                vsync       <= '1';
                e_vi        <= '0';
                r_vi        <= '0';

                if(unsigned(count_in) >= to_unsigned(799, 10)) then
                    new_state   <= init;
                else
                    new_state   <= v_front;
                end if;
                
            when v_sync =>
                vsync       <= '0';
                e_vi        <= '0';
                r_vi        <= '0';

                if(unsigned(count_in) >= to_unsigned(799, 10)) then
                    new_state   <= init;
                else
                    new_state   <= v_sync;
                end if;

            when v_back =>
                vsync       <= '1';
                e_vi        <= '0';
                r_vi        <= '0';
                
                if(unsigned(count_in) >= to_unsigned(799, 10)) then
                    new_state   <= init;
                else
                    new_state   <= v_back;
                end if;
        end case;
    end process ; -- synchro
end architecture rtl;
