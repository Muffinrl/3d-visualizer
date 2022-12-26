library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity y_counter is
    port (
        clk, reset, loc_reset       : in std_logic;
        x_in                        : in std_logic_vector(9 downto 0);
        y_out                       : out std_logic_vector(9 downto 0)
    ) ;

end y_counter;

architecture rtl of y_counter is
    
    signal prev_x, y, new_y     : unsigned(9 downto 0);
begin
 
    timebase : process( clk, reset )
    begin
        if( clk'event and clk = '1' ) then
            if (reset = '1' or loc_reset = '1') then
                y       <= (others => '0');
            else
                y       <= new_y;
                prev_x  <= unsigned(x_in);
            end if;
        end if;
    end process ; -- timebase

    increment : process( prev_x, x_in, y, new_y )
    begin
        if(prev_x >= unsigned(x_in)) then
            new_y   <= y + 1;
        else
            new_y   <= y;
        end if;
    end process ; -- increment

    y_out   <= std_logic_vector(y);
    
end architecture rtl;
