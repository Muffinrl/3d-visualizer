library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity vga is
  port (
    clk, reset      : in std_logic;
    vsync, hsync    : out std_logic;
    r,g,b           : out std_logic_vector(7 downto 0)
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
            count_in, y                     : in std_logic_vector(9 downto 0);  
            vsync, e_vi, r_vi               : out std_logic
          ) ;
    end component v_synchronizer;

    component colour_logic is
        port (
            clk, reset, de                  : in std_logic;
            r, g, b                         : out std_logic_vector(7 downto 0) -- 3 x 8-bit representation of the color + brightness of every pixel.        
          ) ;
    end component colour_logic;

    component counter is
        port (
            clk, reset, loc_reset           : in std_logic;
            count_out                       : out std_logic_vector(9 downto 0)
        ) ;        
    end component counter;

    component v_incr is
        port (
            clk, reset, enable, loc_reset   : in std_logic;
            y_out                           : out std_logic_vector(9 downto 0)
          ) ;
    end component v_incr;

    signal s_de, s_count_reset, s_vi_reset  : std_logic;
    signal s_enable_vi                      : std_logic;
    signal s_count, s_y_interconnect        : std_logic_vector(9 downto 0);

begin

    lbl_h_sync: h_synchronizer
    port map (
        clk         => clk,
        reset       => reset,
        count_in    => s_count,
        hsync       => hsync,
        de          => s_de,
        count_reset => s_count_reset,
        y_in        => s_y_interconnect
    );

    lbl_v_sync: v_synchronizer
    port map (
        clk         => clk,
        reset       => reset,
        r_vi        => s_vi_reset,
        e_vi        => s_enable_vi,
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
        loc_reset   => s_count_reset,
        count_out   => s_count
    );

    lbl_v_incr: v_incr
    port map (
        clk         => clk,
        reset       => reset,
        loc_reset   => s_vi_reset,
        enable      => s_enable_vi,
        y_out       => s_y_interconnect
    );

end architecture ;