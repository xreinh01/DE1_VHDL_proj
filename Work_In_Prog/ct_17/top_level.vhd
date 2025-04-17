library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port ( 
        CA    : out   std_logic;                    --! Cathode of segment A
        CB    : out   std_logic;                    --! Cathode of segment B
        CC    : out   std_logic;                    --! Cathode of segment C
        CD    : out   std_logic;                    --! Cathode of segment D
        CE    : out   std_logic;                    --! Cathode of segment E
        CF    : out   std_logic;                    --! Cathode of segment F
        CG    : out   std_logic;                    --! Cathode of segment G
        DP    : out   std_logic;                    --! Decimal point
        AN    : out   std_logic_vector(7 downto 0); --! Common anodes of all on-board displays
        BTNC  : in    std_logic;                    --! Clear the display
        BTND  : in    std_logic;                    --start clock 
        BTNL  : in    std_logic;                    --add score L 
        BTNR  : in    std_logic;                    --add score R 
        BTNU  : in    std_logic;                    --stop clock 
        CLK100MHZ : in    std_logic                     --! Main clock
    );
    
end top_level;

architecture Behavioral of top_level is

    component bin2seg is
        port (
            clear : in    std_logic;
            bin   : in    std_logic_vector(3 downto 0);
            seg   : out   std_logic_vector(6 downto 0)
        );
    end component;
    
    component Score is
    generic (
    n_bits : integer := 4 --! Number of bits
  );
  port (
    clk   : in    std_logic;                            --! Main clock
    sc_up : in    std_logic;                            --! score up 1
    rst   : in    std_logic;                            --! High-active synchronous reset
    --en    : in    std_logic;                            --! Clock enable input
    count : out   std_logic_vector(n_bits - 1 downto 0) --! Counter value
  );
end component;

component seg_mult is
    Port (
        clk     : in std_logic;
        score   : in std_logic_vector (7 downto 0);
        seg     : out std_logic_vector (6 downto 0);
        anode   : out std_logic_vector (1 downto 0)
     );
     
end component;

    component clock_en is
  generic (
    n_periods : integer := 3 --! Default number of clk periodes to generate one pulse
  );
  port (
    clk   : in    std_logic; --! Main clock
    rst   : in    std_logic; --! High-active synchronous reset
    pulse : out   std_logic  --! Clock enable pulse signal
  );
end component;


signal sig_tmp : std_logic_vector(3 downto 0);
begin

    display : component bin2seg
        port map (
            clear  => BTNC,
            bin    => sig_tmp,
            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG
        );

    score_A : component Score
        port map (
            rst => BTNC,
            sc_up => BTNR,
            clk => CLK100MHZ
        );

    DP <= '1'; --of dec point
    
    clk_en1 : component clock_en
    generic map (
      n_periods => 200_000
    )
    port map (
      clk   => CLK100MHZ,
      rst   => BTNC
      --pulse => sig_en_2ms
    );

    

end Behavioral;
