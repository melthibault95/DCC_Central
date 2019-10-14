library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_DCC_TB is
end Top_DCC_TB;

architecture Behavioral of Top_DCC_TB is
    signal clk: std_logic := '0';
    signal reset: std_logic;
    signal bitDcc: std_logic;

begin
    Top_DCC_0: entity work.Top_DCC
               port map(clk, reset, bitDcc);
    
    process(clk)
    begin
       clk <= not clk after 5 ns;
    end process;
    
    process
    begin
        reset <= '0';
        
        reset <= '1' after 2 ns;
        wait for 400 ns;
        wait;
    end process;

end Behavioral;
