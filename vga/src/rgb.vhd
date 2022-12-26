library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity colour_logic is
  port (
    clk, reset, de  : in std_logic;
    r, g, b         : out std_logic_vector(3 downto 0) -- 12-bit representation of the color + brightness of every pixel.        
  ) ;
end colour_logic ; 

architecture rtl of colour_logic is

begin

    update : process( clk, reset )
    begin
        if(clk'event and clk = '1') then
            if (reset = '1') then
                r   <= (others => '0');
                g   <= (others => '0');
                b   <= (others => '0');
            else        
                -- RGB(139, 172, 15) is #8BAC0F - 12-bit representation: #8A0
                if(de = '1') then
                    r   <= x"8";
                    g   <= x"A";
                    b   <= x"0";
                else
                    r   <= (others => '0');
                    g   <= (others => '0');
                    b   <= (others => '0');
                end if;
            end if;
        end if;
    end process ; -- update

end architecture ;
