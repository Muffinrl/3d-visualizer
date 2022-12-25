library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity vga is
  port (
    clk, reset      : in std_logic;
    vsync, hsync    : out std_logic;
    r,g,b           : out std_logic_vector(7 downto 0);
  ) ;
end vga ; 

architecture structural of vga is

    component h_synchronizer is
        port (
            clk, reset                      : in std_logic;
            count_in                        : in std_logic_vector(9 downto 0);  
            hsync, de, count_reset          : out std_logic;
            y_out                           : out std_logic_vector(9 downto 0)
          ) ;
    end component h_synchronizer;

    component v_synchronizer is
        port (
            clk, reset                      : in std_logic;
            count_in, y                     : in std_logic_vector(9 downto 0);  
            vsync                           : out std_logic;
          ) ;
    end component v_synchronizer;

    component colour_logic is
        port (
            clk, reset                      : in std_logic;
            r, g, b                         : out std_logic_vector(7 downto 0); -- 3 x 8-bit representation of the color + brightness of every pixel.        
          ) ;
    end component colour_logic;

    component counter is
        port (
            clk, reset, de                  : in std_logic;
            count_out                       : out std_logic_vector(9 downto 0);
        ) ;        
    end component counter;

    signal s_y_interconnect, s_de, s_count_reset    : std_logic;
    signal s_count                                  : unsigned(9 downto 0);

begin

    lbl_h_sync: h_synchronizer
    port map (
        clk         => clk,
        reset       => reset,
        count_in    => s_count,
        hsync       => hsync,
        de          => s_de,
        count_reset => s_count_reset,
        y_out       => s_y_interconnect
    );

    lbl_v_sync: v_synchronizer
    port map (
        clk         => clk,
        reset       => reset,
        count_in    => s_count,
        y           => s_y_interconnect,
        vsync       => vsync
    );

    lbl_colour: colour_logic
    port map (
        clk         => clk,
        reset       => reset,
        de          => s_de,
        r           => r,
        g           => g,
        b           => b
    );

    lbl_counter: counter
    port map (
        clk         => clk,
        reset       => reset,
        count_out   => s_count
    );

end architecture ;