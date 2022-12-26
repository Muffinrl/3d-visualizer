library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity vga is
  port (
    clk, reset      : in std_logic;
    vsync, hsync    : out std_logic;
    r,g,b           : out std_logic_vector(3 downto 0)
  ) ;
end vga ; 

architecture structural of vga is

    component h_synchronizer is
        port (
            clk, reset                      : in std_logic;
            count_in, y_in                  : in std_logic_vector(9 downto 0);  
            hsync, de, count_reset          : out std_logic
          ) ;
    end component h_synchronizer;

    component v_synchronizer is
        port (
            clk, reset                      : in std_logic;
            x_in, y                         : in std_logic_vector(9 downto 0);  
            vsync, r_yc                     : out std_logic
          ) ;
    end component v_synchronizer;

    component colour_logic is
        port (
            clk, reset, de                  : in std_logic;
            x, y                            : in std_logic_vector(9 downto 0);
            r, g, b                         : out std_logic_vector(3 downto 0) -- 12-bit representation of the color + brightness of every pixel.        
          ) ;
    end component colour_logic;

    component x_counter is
        port (
            clk, reset, loc_reset           : in std_logic;
            x_out                           : out std_logic_vector(9 downto 0)
        ) ;        
    end component x_counter;

    component y_counter is
        port (
            clk, reset, loc_reset           : in std_logic;
            x_in                            : in std_logic_vector(9 downto 0);
            y_out                           : out std_logic_vector(9 downto 0)
          ) ;
    end component y_counter;

    signal s_de, s_xc_reset, s_yc_reset     : std_logic;
    signal s_x, s_y                         : std_logic_vector(9 downto 0);

begin

    lbl_h_sync: h_synchronizer
    port map (
        clk         => clk,
        reset       => reset,
        count_in    => s_x,
        hsync       => hsync,
        de          => s_de,
        count_reset => s_xc_reset,
        y_in        => s_y
    );

    lbl_v_sync: v_synchronizer
    port map (
        clk         => clk,
        reset       => reset,
        r_yc        => s_yc_reset,
        x_in        => s_x,
        y           => s_y,
        vsync       => vsync
    );

    lbl_colour: colour_logic
    port map (
        clk         => clk,
        reset       => reset,
        de          => s_de,
        x           => s_x,
        y           => s_y,
        r           => r,
        g           => g,
        b           => b
    );

    lbl_x_counter: x_counter
    port map (
        clk         => clk,
        reset       => reset,
        loc_reset   => s_xc_reset,
        x_out       => s_x
    );

    lbl_y_counter: y_counter
    port map (
        clk         => clk,
        reset       => reset,
        loc_reset   => s_yc_reset,
        y_out       => s_y,
        x_in        => s_x
    );

end architecture ;