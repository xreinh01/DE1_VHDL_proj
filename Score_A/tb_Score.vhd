library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_score is
end tb_score;

architecture sim of tb_score is

  -- Constants
  constant CLK_PERIOD : time := 10 ns;

  -- Signals
  signal clk     : std_logic := '0';
  signal rst     : std_logic := '0';
  signal sc_up   : std_logic := '0';
  signal count   : std_logic_vector(3 downto 0);

  -- DUT
  component Score
    generic (
      n_bits : integer := 4
    );
    port (
      clk   : in  std_logic;
      sc_up : in  std_logic;
      rst   : in  std_logic;
      count : out std_logic_vector(n_bits - 1 downto 0)
    );
  end component;

begin

  -- Instantiate DUT
  uut: Score
    port map (
      clk   => clk,
      sc_up => sc_up,
      rst   => rst,
      count => count
    );

  -- Clock generation
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Reset the DUT
    rst <= '1';
    wait for 2 * CLK_PERIOD;
    rst <= '0';

    -- Wait a bit before button presses
    wait for 3 * CLK_PERIOD;

    -- Simulate 5 button presses
    for i in 0 to 4 loop
      sc_up <= '1';
      wait for CLK_PERIOD;
      sc_up <= '0';
      wait for 2 * CLK_PERIOD;
    end loop;

    -- Final wait and stop simulation
    wait for 10 * CLK_PERIOD;
    assert false report "Simulation ended" severity note;
    wait;
  end process;

end sim;
