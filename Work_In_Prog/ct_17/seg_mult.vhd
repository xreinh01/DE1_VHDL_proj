----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2025 11:51:00 AM
-- Design Name: 
-- Module Name: seg_mult - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seg_mult is
    Port (
        clk     : in std_logic;
        score   : in std_logic_vector (7 downto 0);
        seg     : out std_logic_vector (6 downto 0);
        anode   : out std_logic_vector (1 downto 0)
     );
     
end seg_mult;

architecture Behavioral of seg_mult is

    signal display_select : std_logic := '0';
    signal num_disp : std_logic_vector(3 downto 0);
    
    component bin2seg
        Port ( clear : in  std_logic;
               bin   : in  std_logic_vector(3 downto 0);
               seg   : out std_logic_vector(6 downto 0)
               );
    end component;
    
begin

      process(clk)
    begin
        if rising_edge(clk) then
            display_select <= NOT display_select;  -- Toggle between '0' and '1'
        end if;
        end process;
    
    process(display_select, score)
    begin
        case display_select is
            when '0' =>
                num_disp <= score(7 downto 4);  -- Tens digit
                anode <= "10";  -- Enable AN0 (Tens display)
            when '1' =>
                num_disp <= score(3 downto 0);  -- Ones digit
                anode <= "01";  -- Enable AN1 (Ones display)
            when others =>
                num_disp <= "0000";  -- Default to 0
                anode <= "00";      -- Disable both displays
        end case;
    end process;
    
end Behavioral;
