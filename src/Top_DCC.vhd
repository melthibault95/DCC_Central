library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_DCC is
    port(clk, reset : in std_logic;
        R_Valid, R_Vitesse, R_lumiere, R_Alerte : in std_logic;
         bitDcc : out std_logic);
end Top_DCC;

architecture Behavioral of Top_DCC is

    signal finT, clkDiv, cmdTemp, bitRegDcc, bitDcc_0,
    bitDcc_1 ,finTemp, go_0, go_1, fin_0, fin_1: std_logic;
    signal cmdReg : std_logic_vector(1 downto 0);
    signal trame_dcc : std_logic_vector(59 downto 0);
    

begin
    MAE_0: entity work.MAE 
    port map
    (bitRegDcc, clk, reset, finT, finTemp, fin_1, fin_0, go_0, go_1, cmdTemp, cmdReg);
    
    DCC_Bit_0: entity work.DCC_Bit
    port map
    (go_0, clk, clkDiv, reset, fin_0, bitDcc_0);
    
    DCC_Bit_1: entity work.DCC_Bit
    generic map (58)
    port map
    (go_1, clk, clkDiv, reset, fin_1, bitDcc_1);
    
    DivClock_0: entity work.DivClock
    port map
    (clk, reset, clkDiv);
    
    Registre_DCC_0: entity work.Registre_DCC
    port map
    (clk, reset, cmdReg, trame_dcc, bitRegDcc, finT);
    
    Tempo_0: entity work.Tempo
    port map
    (clkDiv, reset, cmdTemp, finTemp);
    
    GenTrame_0: entity work.Generateur_Trame
    port map
    (clk, reset, R_Valid, R_Vitesse, R_lumiere, R_Alerte, trame_dcc);
    
    bitDcc <= bitDcc_0 or bitDcc_1;   

end Behavioral;
