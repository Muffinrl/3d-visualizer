-- ===========================================================
--                          IMPORTANT
-- Synchronization is based on a RESOLUTION of 640x480 AT 60Hz
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity synchronizer is
  port (
    clk, reset                      : in std_logic;
    count_in                        : in std_logic_vector(9 downto 0);  
    hsync, vsync, de, count_reset   : out std_logic
  ) ;
end entity synchronizer;

architecture rtl of synchronizer is
    type fsm_state_type is (reset, init, h_front, h_sync, h_back, v_front, v_sync, v_back, visible);
    signal state, new_state     : fsm_state_type;
    signal sy                   : unsigned(9 downto 0);

begin
    
    reg : process( clk, reset )
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                state   <= reset;
            else
                state   <= new_state;
            end if;
        end if;
    end process ; -- reg
    
    synchro : process( state, count_in )
    begin
        case state is

            -- (Re)Initialise FSM
            when reset =>
                hsync       <= '1';
                vsync       <= '1';
                de          <= '0';
                count_reset <= '1';

                sy          <= (others => '0');

                new_state   <= visible;
            
            -- Reset counter and prepare for new horizontal cycle
            when init =>
                hsync       <= '1';
                vsync       <= '1';
                de          <= '0';
                count_reset <= '1';

                sy          <= sy + 1; -- Increment y-coordinate on screen

                -- Transition to appropriate vertical region
                if(sy >= to_unsigned(525, 10)) then
                    new_state   <= reset;
                elsif(sy >= to_unsigned(492, 10)) then
                    new_state   <= v_back;
                elsif(sy >= to_unsigned(490, 10)) then
                    new_state   <= v_sync;
                elsif(sy >= to_unsigned(480, 10)) then
                    new_state   <= v_front;
                else
                    new_state   <= visible;
                end if;

            -- Render image on screen
            when visible =>
                hsync       <= '1';
                vsync       <= '1';
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
                vsync       <= '1';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(656, 10)) then
                    new_state   <= h_sync;
                else
                    new_state   <= h_front;
                end if;

            when h_sync =>
                hsync       <= '0';
                vsync       <= '1';
                de          <= '0';
                count_reset <= '0';

                sx          <= sx + 1;

                if(unsigned(count_in) >= to_unsigned(752, 10)) then
                    new_state   <= h_back;
                else
                    new_state   <= h_sync;
                end if;

            when h_back =>
                hsync       <= '1';
                vsync       <= '1';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(799, 10)) then
                    new_state   <= init;
                else
                    new_state   <= h_back;
                end if;

            -- ========================================
            -- Start of Vertical Sync Cycle
            -- ========================================

            when v_front =>
                hsync       <= '1';
                vsync       <= '1';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(799, 10)) then
                    new_state   <= init;
                else
                    new_state   <= v_front;
                end if;
                
            when v_sync =>
                hsync       <= '1';
                vsync       <= '0';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(799, 10)) then
                    new_state   <= init;
                else
                    new_state   <= v_sync;
                end if;

            when v_back =>
                hsync       <= '1';
                vsync       <= '1';
                de          <= '0';
                count_reset <= '0';

                if(unsigned(count_in) >= to_unsigned(799, 10)) then
                    new_state   <= init;
                else
                    new_state   <= v_back;
                end if;
        end case;
    end process ; -- synchro
    
end architecture rtl;