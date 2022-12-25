library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_tb is
end vga_tb;

architecture beh of vga_tb is

    signal clk, reset, hsync, vsync     : std_logic;
    signal r, g, b                      : std_logic_vector(7 downto 0);

    component vga is
        port (
            clk, reset      : in std_logic;
            vsync, hsync    : out std_logic;
            r,g,b           : out std_logic_vector(7 downto 0)
          ) ;
    end component vga;

begin
    
    lbl1: vga
    port map (
        clk     => clk,
        reset   => reset,
        vsync   => vsync,
        hsync   => hsync,
        r       => r,
        g       => g,
        b       => b
    );

    clk     <=  '0' after 0 ns,
                '1' after 20 ns when clk /= '1' else '0' after 20 ns;
    
    reset   <=  '1' after 0 ns,
                '0' after 30 ns;

end beh ; -- beh