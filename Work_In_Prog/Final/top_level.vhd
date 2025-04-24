library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level is
    Port ( 
        CA, CB, CC, CD, CE, CF, CG : out std_logic;             --! Cathodes for segments A-G
        SW                         : in std_logic_vector(15 downto 0); -- time set
        DP                         : out std_logic;             --! Decimal point
        AN                         : out std_logic_vector(7 downto 0); --! Anodes for displays
        BTNC                       : in  std_logic;             --! Reset
        BTND                       : in  std_logic;             --! Load/start timer
        BTNR                       : in  std_logic;             --! Increment Score A
        BTNU                       : in  std_logic;             --! Increment Score B
        CLK100MHZ                  : in  std_logic;
        LED16_B                    : out std_logic             --! System clock
    );
end top_level;

architecture Behavioral of top_level is

    -- Timer component
    component timer
        generic (
            n_periods : integer := 100000000
        );
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            load          : in  std_logic;
            start_minutes : in  unsigned(5 downto 0);
            start_seconds : in  unsigned(5 downto 0);
            pulse         : out std_logic;
            seconds       : out unsigned(5 downto 0);
            minutes       : out unsigned(5 downto 0)
        );
    end component;

    -- Score component
    component Score
        generic (
            n_bits : integer := 8
        );
        port (
            clk   : in  std_logic;
            sc_up : in  std_logic;
            rst   : in  std_logic;
            count : out std_logic_vector(n_bits - 1 downto 0)
        );
    end component;
    
 component debounce is
        port (
            clk      : in    std_logic;
            rst      : in    std_logic;
            en       : in    std_logic;
            bouncey  : in    std_logic;
            clean    : out   std_logic;
            pos_edge : out   std_logic;
            neg_edge : out   std_logic
        );
    end component;

    -- Multiplexed display component
    component seg_mult
        port (
            clk     : in  std_logic;
            scoreA  : in  std_logic_vector(7 downto 0);
            scoreB  : in  std_logic_vector(7 downto 0);
            minutes : in  unsigned(5 downto 0);
            seconds : in  unsigned(5 downto 0);
            seg     : out std_logic_vector(6 downto 0);
            an      : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Clock enable (optional if unused)
    component clock_en
        generic (
            n_periods : integer := 3
        );
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            pulse : out std_logic
        );
    end component;

    -- Internal signals
    signal timer_seg           : std_logic_vector(6 downto 0);
    signal timer_anode         : std_logic_vector(7 downto 0);
    signal minutes, seconds    : unsigned(5 downto 0);
    signal pulse_timer         : std_logic;
    signal score_A_count       : std_logic_vector(7 downto 0);
    signal score_B_count       : std_logic_vector(7 downto 0);
    signal timer_start_minutes : unsigned(5 downto 0) := (others => '0');
    signal timer_start_seconds : unsigned(5 downto 0) := (others => '0');
    signal sig_event :  std_logic;
    signal sig_en_2ms          : std_logic;


begin
    timer_start_minutes <= unsigned(SW(11 downto 6));
    timer_start_seconds <= unsigned(SW(5 downto 0));


    -- Instantiate Score A
    score_A : Score
        port map (
            clk   => CLK100MHZ,
            sc_up => BTNR,
            rst   => BTNC,
            count => score_A_count
        );

    -- Instantiate Score B
    score_B : Score
        port map (
            clk   => CLK100MHZ,
            sc_up => BTNU,
            rst   => BTNC,
            count => score_B_count
        );

    -- Display multiplexer
    display : seg_mult
        port map (
            clk     => CLK100MHZ,
            scoreA  => score_A_count,
            scoreB  => score_B_count,
            minutes => minutes,
            seconds => seconds,
            seg     => timer_seg,
            an      => timer_anode
        );

    -- Timer
    timer_inst : timer
        port map (
            clk           => CLK100MHZ,
            rst           => BTNC,
            load          => BTND,
            start_minutes => timer_start_minutes,
            start_seconds => timer_start_seconds,
            pulse         => pulse_timer,
            seconds       => seconds,
            minutes       => minutes
        );

    -- Clock enable (if needed)
    clk_en1 : clock_en
        generic map (
            n_periods => 500_000_000
        )
        port map (
            clk   => CLK100MHZ,
            rst   => BTNC,
            pulse => pulse_timer
        );
   
   debounce_inst_a : component debounce
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            en       => sig_en_2ms,
            bouncey  => BTNR,
            clean => LED16_B,
            pos_edge => sig_event,
            neg_edge => open
        );
        
debounce_inst_b : component debounce
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            en       => sig_en_2ms,
            bouncey  => BTNU,
            clean => LED16_B,
            pos_edge => sig_event,
            neg_edge => open
        );        


    -- 7-segment cathode mappings
    CA <= timer_seg(6);
    CB <= timer_seg(5);
    CC <= timer_seg(4);
    CD <= timer_seg(3);
    CE <= timer_seg(2);
    CF <= timer_seg(1);
    CG <= timer_seg(0);
    DP <= '1'; -- Decimal point disabled

    -- Anode control
    AN <= timer_anode;

end Behavioral;