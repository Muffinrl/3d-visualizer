library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity game is
  port (
    clk, reset, w, a, s, d, set_size    : in std_logic; -- w, a, s, d active low
    vsync                               : in std_logic_vector(9 downto 0); -- not to be confused with 1-bit vsync signal, counts when new frame is rendered
    size_x, size_y, pos_x, pos_y        : out std_logic_vector(9 downto 0);
    r_qb, g_qb, b_qb                    : out std_logic_vector(3 downto 0);
  ) ;
end game ; 

architecture arch of game is

    type fsm_state_type is (stop, idle, input, update);

    signal state, new_state : fsm_state_type;

    signal current_xp, current_yp, current_xs, current_yp  : unsigned(9 downto 0);
    signal new_xp, new_yp, new_xs, new_ys                  : unsigned(9 downto 0);

begin

    reg : process( clk, reset )
    begin
        if(clk'event and clk = '1') then
            if(reset = '1') then
                state   <= stop;
            else
                state   <= new_state;
            end if;
        else
            state   <= state;
        end if;
    end process ; -- reg

    comb : process( state, new_state, w, a, s, d, set_size )
    begin
        case state is
            when stop =>
                size_x  <= (others => '0');
                size_y  <= (others => '0');
                pos_x   <= (others => '0');
                pos_y   <= (others => '0');

                r_qb    <= (others => '0');
                g_qb    <= (others => '0');
                b_qb    <= (others => '0');

                when input_pos =>
                size_x  <= (others => '0');
                size_y  <= (others => '0');
                pos_x   <= (others => '0');
                pos_y   <= (others => '0');

                r_qb    <= (others => '0');
                g_qb    <= (others => '0');
                b_qb    <= (others => '0');
                
                when input_size =>
                size_x  <= (others => '0');
                size_y  <= (others => '0');
                pos_x   <= (others => '0');
                pos_y   <= (others => '0');

                r_qb    <= (others => '0');
                g_qb    <= (others => '0');
                b_qb    <= (others => '0');
                
                when update =>
                size_x  <= (others => '0');
                size_y  <= (others => '0');
                pos_x   <= (others => '0');
                pos_y   <= (others => '0');

                r_qb    <= (others => '0');
                g_qb    <= (others => '0');
                b_qb    <= (others => '0');
                
                
        
        end case;
    end process ; -- comb
    
end architecture ;