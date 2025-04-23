library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg_mult is 
    port ( 
        clk     : in std_logic; 
        scoreA  : in std_logic_vector(7 downto 0);  
        scoreB  : in std_logic_vector(7 downto 0); 
        minutes : in unsigned(5 downto 0); 
        seconds : in unsigned(5 downto 0); 
        seg     : out std_logic_vector(6 downto 0); 
        an      : out std_logic_vector(7 downto 0) 
    ); 
end seg_mult;

architecture Behavioral of seg_mult is

    signal refresh_counter : unsigned(15 downto 0) := (others => '0');
    signal digit_select    : unsigned(2 downto 0) := (others => '0');
    signal current_digit   : std_logic_vector(3 downto 0) := (others => '0');

    component bin2seg
        Port (
            clear : in  std_logic;
            bin   : in  std_logic_vector(3 downto 0);
            seg   : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    -- Refresh digit select on clock
    process(clk)
    begin
        if rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
            if refresh_counter = 0 then
                digit_select <= digit_select + 1;
            end if;
        end if;
    end process;

    -- Handle which digit to show and what value to display
    process(digit_select, scoreA, scoreB, minutes, seconds)
    begin
    -- Default: no colon
  
-- Optional: turn colon ON during timer digits (AN4-AN7)
    

        case digit_select is
            when "000" => -- AN0: Score A ones
                current_digit <= scoreA(3 downto 0);
                an <= "11111110";
            when "001" => -- AN1: Score A tens
                current_digit <= scoreA(7 downto 4);
                an <= "11111101";
            when "010" => -- AN2: Score B ones
                current_digit <= scoreB(3 downto 0);
                an <= "11111011";
            when "011" => -- AN3: Score B tens
                current_digit <= scoreB(7 downto 4);
                an <= "11110111";
                
            when "100" => -- AN4: Timer seconds ones
                current_digit <= std_logic_vector(to_unsigned(to_integer(seconds) mod 10, 4));
                an <= "11101111";

            when "101" => -- AN5: Timer seconds tens
                current_digit <= std_logic_vector(to_unsigned(to_integer(seconds) / 10, 4));
                an <= "11011111";
     
            when "110" => -- AN6: Timer minutes ones
                current_digit <= std_logic_vector(to_unsigned(to_integer(minutes) mod 10, 4));
                an <= "10111111";
        
            when others => -- AN7: Timer minutes tens
                current_digit <= std_logic_vector(to_unsigned(to_integer(minutes) / 10, 4));
                an <= "01111111";
             
        end case;
    end process;

    -- Decode binary digit to 7-segment
    digit_to_segment : bin2seg
        port map (
            clear => '0',
            bin   => current_digit,
            seg   => seg
        );

end Behavioral;