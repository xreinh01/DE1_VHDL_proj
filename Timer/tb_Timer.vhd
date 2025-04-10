-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 28.2.2024 21:53:41 UTC

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity tb_counter is
end entity tb_counter;

-------------------------------------------------

architecture tb of tb_counter is

  component counter is
    generic (
      n_bits : integer
    );
    port (
      clk   : in    std_logic;
      rst   : in    std_logic;
      en    : in    std_logic;
      count : out   std_logic_vector(N_BITS - 1 downto 0)
    );
  end component counter;

  constant c_nbits : integer := 8;
  signal   clk     : std_logic;
  signal   rst     : std_logic;
  signal   en      : std_logic;
  signal   count   : std_logic_vector(c_nbits - 1 downto 0);

  constant tbperiod   : time      := 10 ns; -- EDIT Put right period here
  signal   tbclock    : std_logic := '0';
  signal   tbsimended : std_logic := '0';

begin

  dut : component counter
    generic map (
      n_bits => c_nbits
    )
    port map (
      clk   => clk,
      rst   => rst,
      en    => en,
      count => count
    );

  -- Clock generation
  tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else
             '0';

  -- EDIT: Check that clk is really your main clock signal
  clk <= tbclock;

  stimuli : process is
  begin

    -- EDIT Adapt initialization as needed
    en <= '1';

    -- Reset generation
    -- EDIT: Check that rst is really your reset signal
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    wait for 100 ns;

    -- EDIT Add stimuli here
    wait for 33 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    
    wait for 33 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    
    wait for 33 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;
    en <= '1';
    wait for 1 * tbperiod;
    en <= '0';
    wait for 6 * tbperiod;

    -- Stop the clock and hence terminate the simulation
    tbsimended <= '1';
    wait;

  end process stimuli;

end architecture tb;

-- Configuration block below is required by some simulators. Usually no need to edit.
