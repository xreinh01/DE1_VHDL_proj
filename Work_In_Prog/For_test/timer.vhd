library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
  generic (
    n_periods : integer :=  100000000  
  );
  port (
    clk           : in  std_logic;
    rst           : in  std_logic;
    load          : in  std_logic;               --! Load new start time
    start_minutes : in  unsigned(5 downto 0);    --! Input start value
    start_seconds : in  unsigned(5 downto 0);
    pulse         : out std_logic;
    seconds       : out unsigned(5 downto 0);
    minutes       : out unsigned(5 downto 0)
  );
end entity;

architecture behavioral of timer is

  signal sig_count : integer range 0 to n_periods - 1 := 0;
  signal sec       : unsigned(5 downto 0) := (others => '0');
  signal min       : unsigned(5 downto 0) := (others => '0');

begin

  seconds <= sec;
  minutes <= min;

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        sig_count <= 0;
        sec <= (others => '0');
        min <= (others => '0');

      elsif load = '1' then
        sec <= start_seconds;
        min <= start_minutes;

      else
        
        if sig_count < n_periods - 1 then
          sig_count <= sig_count + 1;
        else
          sig_count <= 0;

          
          if min = 0 and sec = 0 then
            
          elsif sec = 0 then
            sec <= to_unsigned(59, 6);
            min <= min - 1;
          else
            sec <= sec - 1;
          end if;

        end if;
      end if;
    end if;
  end process;

  pulse <= '1' when (sig_count = n_periods - 1) else '0';

end architecture;