library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity draw_logic is
  port (
    clk, reset                  : in  std_logic; 
    hsync, vsync, de            : out std_logic
  ) ;
end entity draw_logic;

architecture rtl of draw_logic is
    type fsm_state_type is (reset, idle, h_sync, v_sync);
    signal state, new_state     : fsm_state_type;
    signal sx, sy               : std_logic_vector(9 downto 0);

begin
    
    setup : process( clk, reset )
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                state   <= reset;
            else
                state   <= new_state;
            end if;
        end if;
    end process ; -- setup
    
    synchro : process( state )
    begin
        case state is
            when reset =>
                hsync       <= '1';
                vsync       <= '1';
                de          <= '0';
                sx          <= (others => '0');
                sy          <= (others => '0');

                new_state   <= init;

            when idle =>
                hsync       <= '1';
                vsync       <= '1';
                de          <= '0';
                
            -- TODO: Conditional v_sync
            when h_sync =>
                hsync       <= '0';

            -- TODO: Conditional h_sync
            when v_sync =>
                vsync       <= '0';

        end case;
    end process ; -- synchro
    
end architecture rtl;