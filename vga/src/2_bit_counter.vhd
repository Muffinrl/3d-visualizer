library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity 2-bit-counter is
    port (
        clk, reset      : in std_logic;
        count_out       : out std_logic_vector(1 downto 0);
    ) ;

end 2-bit-counter;

architecture rtl of 2_bit_counter is
    
    signal count, new_count     : unsigned(1 downto 0);
begin
 
    timebase : process( clk )
    begin
        if( clk'event and clk = '1' ) then
            if (reset = '1' ) then
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

end architecture rtl;
