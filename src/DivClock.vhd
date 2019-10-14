library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- DivClock divise la frequence d'entree par DIV
entity DivClock is
    Generic ( DIV : integer := 100);
    Port ( Clk100 : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clk1 : out STD_LOGIC);
end DivClock;

architecture Behavioral of DivClock is
    signal Clk1_sig : STD_LOGIC := '0';
begin
    process(Clk100, reset)
        variable cpt : integer := 1;
    begin
        if reset = '0' then
            cpt := 1;
        else
            if rising_edge(Clk100) then
                if cpt = DIV / 2 then -- Changement d'etat <=> front d'horloge
                    cpt := 1;
                    Clk1_sig <= not Clk1_sig;
                else -- Comptage
                    cpt := cpt + 1;
                end if;
            end if;
        end if;
    end process;
    
    Clk1 <= Clk1_sig;

end Behavioral;
