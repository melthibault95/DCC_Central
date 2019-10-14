library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Module permettant de generer des bits DCC
entity DCC_Bit is
    Generic ( pulse : integer := 100); -- Duree d'impulsion en us
    Port ( go : in STD_LOGIC;
           clk100 : in STD_LOGIC;
           clk1 : in STD_LOGIC;
           reset : in STD_LOGIC;
           fin : out STD_LOGIC;
           bitDcc : out STD_LOGIC);
end DCC_Bit;

architecture Behavioral of DCC_Bit is
    type Etat is (DISABLED, BAS, HAUT, LAST, RESET_CPT);
    signal EP, EF : Etat;
    signal front : std_logic := '0';
    signal resetCpt : std_logic := '0';
begin
    trans: process(clk100, reset)
    begin
        if (reset = '0') then
            EP <= DISABLED;
        else
            if (rising_edge(clk100)) then
                EP <= EF;
            end if;
        end if;
    end process;
    
    nextstate: process(go, front, EP)
    begin
        case EP is
            when DISABLED => 
                fin <= '0';
                bitDcc <= '0';
                resetCpt <= '0';
                
                if go = '1' then
                    EF <= BAS;
                else
                    EF <= EP;
                end if;
                
            when BAS =>
                fin <= '0';
                bitDcc <= '0';
                resetCpt <= '1';
                
                if front = '1' then
                    EF <= RESET_CPT;
                else
                    EF <= EP;
                end if;
                
            when RESET_CPT =>
                fin <= '0';
                bitDcc <= '0';
                resetCpt <= '0';
                
                EF <= HAUT;
            when HAUT =>
                fin <= '0';
                bitDcc <= '1';
                resetCpt <= '1';
                
                if front = '1' then
                    EF <= LAST;
                else
                    EF <= EP;
                end if;
                
            when LAST =>
                fin <= '1';
                bitDcc <= '0';
                resetCpt <= '0';
                
                if go = '1' then
                    EF <= BAS;
                else 
                    EF <= DISABLED;
                end if;
        end case;
    end process;
    
    cpt: process(clk1, resetCpt)
        variable cpt : integer := pulse;
    begin
        if (resetCpt = '0') then
            cpt := pulse;
            front <= '0';
        else
            if (rising_edge(clk1)) then
                cpt := cpt - 1;
                if (cpt = 0) then
                    cpt := pulse;
                    front <= '1';
                end if;
            end if;
        end if;
    end process;    

end Behavioral;
