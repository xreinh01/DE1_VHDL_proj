----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 11:29:16 AM
-- Design Name: 
-- Module Name: Score - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Score is
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
end Score;

architecture Behavioral of Score is
  
  --! Local counter
  --signal sig_count : integer range 0 to (2 ** n_bits - 1);
    
   signal sig_count : integer range 0 to (2 ** n_bits - 1);
  signal sc_up_prev : std_logic := '0';  -- Previous state of sc_up
  signal  unit, tens : integer range 0 to 9 := 0;
  
begin

  --! Clocked process with synchronous reset which implements
  --! N-bit up counter.

   p_counter : process (clk)  
    begin
    if (rising_edge(clk)) then
      -- Synchronous, active-high reset
      if (rst = '1') then
        sig_count   <= 0;
        sc_up_prev  <= '0';
        unit <= 0;
        tens <= 0;
        
      else
        -- Rising edge detection for sc_up
        if (sc_up = '1' and sc_up_prev = '0') then
            if unit = 9 then
                unit <=0;
                if tens = 9 then
                    tens <= 0; else 
                        tens <= tens + 1;
                        end if;
                else unit <= unit + 1;
                end if;        
          if (sig_count < (2 ** n_bits - 1)) then
            sig_count <= sig_count + 1;
          end if;
        end if;

        -- Update previous state of sc_up
        sc_up_prev <= sc_up;
      end if;
    end if;
  end process p_counter;

  -- Assign internal register to output
  count <= std_logic_vector(to_unsigned(sig_count, n_bits));
end Behavioral;