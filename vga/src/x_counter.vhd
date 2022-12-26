library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity x_counter is
    port (
        clk, reset, loc_reset       : in std_logic;
        x_out                       : out std_logic_vector(9 downto 0)
    ) ;

end x_counter;

architecture rtl of x_counter is
    
    signal count, new_count     : unsigned(9 downto 0);
begin
 
    timebase : process( clk, reset )
    begin
        if( clk'event and clk = '1' ) then
            if (reset = '1' or loc_reset = '1') then
                count   <= (others => '0');
            else
                count   <= new_count;
            end if;
        end if;
    end process ; -- timebase

    increment : process( count, new_count )
    begin
        new_count   <= count + 1;
    end process ; -- increment

    x_out   <= std_logic_vector(count);
    
end architecture rtl;
