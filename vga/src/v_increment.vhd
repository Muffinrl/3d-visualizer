library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity v_incr is
  port (
    clk, reset, enable, loc_reset   : in std_logic;
    y_out                           : out std_logic_vector(9 downto 0)
  ) ;
end v_incr ; 

architecture rtl of v_incr is

    signal new_y, sy    : unsigned(9 downto 0);

begin

    main : process( clk, reset )
    begin
        if( clk'event and clk = '1' ) then
            if (reset = '1' or loc_reset = '1') then
                sy      <= (others => '0');
            else   
                if(enable = '1') then
                    sy  <= new_y;
                else
                    sy  <= sy;
                end if;
            end if;
        end if;
    end process ; -- main

    increment : process( new_y, sy )
    begin
        new_y  <= sy + 1;
    end process ; -- increment

    y_out       <= std_logic_vector(sy);
end architecture ;