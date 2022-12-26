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
    x_in, y                         : in std_logic_vector(9 downto 0);  
    vsync, r_yc                     : out std_logic
  ) ;
end entity v_synchronizer;

architecture rtl of v_synchronizer is
    type fsm_state_type is (prime, idle, v_front, v_sync, v_back);
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

    synchro : process( state, x_in, y )
    begin
        case state is

            -- (Re)Initialise FSM
            when prime =>
                vsync       <= '1';
                r_yc        <= '1';

                new_state   <= idle;
                
            when idle =>
                vsync       <= '1';
                r_yc        <= '0';
            
            if (unsigned(x_in) >= to_unsigned(799, 10)) then
                if(unsigned(y) >= to_unsigned(479, 10)) then
                    new_state   <= v_front;
                else
                    new_state   <= idle;
                end if;
            else
                new_state   <= idle;
            end if;
            
            -- ========================================
            -- Start of Vertical Sync Cycle
            -- ========================================

            when v_front =>
                vsync       <= '1';
                r_yc        <= '0';

                if(unsigned(x_in) >= to_unsigned(799, 10)) then
                    if(unsigned(y) >= to_unsigned(489, 10)) then
                        new_state   <= v_sync;
                    else
                        new_state   <= v_front;
                    end if;
                else
                    new_state   <= v_front;
                end if;
                
            when v_sync =>
                vsync       <= '0';
                r_yc        <= '0';

                if(unsigned(x_in) >= to_unsigned(799, 10)) then
                    if(unsigned(y) >= to_unsigned(491, 10)) then
                        new_state   <= v_back;
                    else
                        new_state   <= v_sync;
                    end if;
                else
                    new_state   <= v_sync;
                end if;

            when v_back =>
                vsync       <= '1';
                r_yc        <= '0';
                
                if(unsigned(x_in) >= to_unsigned(799, 10)) then
                    if(unsigned(y) >= to_unsigned(524, 10)) then
                        new_state   <= prime;
                    else
                        new_state   <= v_back;
                    end if;
                else
                    new_state   <= v_back;
                end if;
        end case;
    end process ; -- synchro
end architecture rtl;
