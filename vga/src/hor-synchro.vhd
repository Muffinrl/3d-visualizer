-- ===========================================================
--                          IMPORTANT
-- Synchronization is based on a RESOLUTION of 640x480 AT 60Hz
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity h_synchronizer is
  port (
    clk, reset                      : in std_logic;
    count_in                        : in std_logic_vector(9 downto 0);  
    hsync, de, count_reset          : out std_logic;
    y_out                           : out std_logic_vector(9 downto 0)
  ) ;
end entity h_synchronizer;

architecture rtl of h_synchronizer is
    type fsm_state_type is (prime, idle, init, h_front, h_sync, h_back, visible);
    signal state, new_state     : fsm_state_type;
    signal sy                   : unsigned(9 downto 0);

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
    
    synchro : process( state, count_in )
    begin
        case state is

            -- (Re)Initialise FSM
            when prime =>
                hsync       <= '1';
                de          <= '0';
                count_reset <= '1';

                sy          <= (others => '0');

                new_state   <= visible;
            
            -- Reset counter and prepare for new horizontal cycle
            when init =>
                hsync       <= '1';
                de          <= '0';
                count_reset <= '1';

                sy          <= sy + 1; -- Increment on-screen y-coordinate

                if (sy >= to_unsigned(480, 10)) then
                    new_state   <= idle;
                else
                    new_state   <= visible;
                end if;

            -- Is active in place of VISIBLE during vsync region
            when idle =>
                hsync       <= '1';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(640, 10)) then
                    new_state   <= h_front;
                else
                    new_state   <= idle;
                end if;

            -- Render image on screen
            when visible =>
                hsync       <= '1';
                de          <= '1';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(640, 10)) then
                    new_state   <= h_front;
                else
                    new_state   <= visible;
                end if;

            -- ========================================
            -- Start of Horizontal Sync Cycle
            -- ========================================

            when h_front =>
                hsync       <= '1';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(656, 10)) then
                    new_state   <= h_sync;
                else
                    new_state   <= h_front;
                end if;

            when h_sync =>
                hsync       <= '0';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(752, 10)) then
                    new_state   <= h_back;
                else
                    new_state   <= h_sync;
                end if;

            when h_back =>
                hsync       <= '1';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(799, 10)) then
                    new_state   <= init;
                else
                    new_state   <= h_back;
                end if;
        end case;
    end process ; -- horizontal synchro

end architecture rtl;
