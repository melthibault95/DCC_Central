library IEEE;
use IEEE.std_logic_1164.all;

entity MAE is
    port (
          bitDCC      : in std_logic;
          clk      : in std_logic;
          reset    : in std_logic;
          
          -- Données de la machine a etats
          finT     : in std_logic;
          finTemp  : in std_logic;
          fin_1    : in std_logic;
          fin_0    : in std_logic;
          go_0     : out std_logic;
          go_1     : out std_logic;
          cmdTemp  : out std_logic;
          cmdReg   : out std_logic_vector(1 downto 0)
          );
end entity;

architecture Behav of MAE is
    type Etat is (NOTRAME, START, SEND, WAITBIT, WAITTRAME);
    signal EP, EF : Etat;
begin
    trans: process(clk, reset) is
    begin
        if reset = '0' then
            EP <= NOTRAME;
        elsif rising_edge(clk) then
            EP <= EF;
        end if;
    end process;
    
    nextstate: process(bitDCC, finT, finTemp, fin_1, fin_0, EP) is
    begin
        case EP is
            when NOTRAME =>
                cmdReg <= "01";
                go_0 <= '0';
                go_1 <= '0';
                cmdTemp <= '0';
                if finT = '1' then
                    EF <= NOTRAME;
                else
                    EF <= START;
                end if;
            when START =>
                cmdReg <= "10";
                go_0 <= '0';
                go_1 <= '0';
                cmdTemp <= '0';
                EF <= SEND;
            when SEND =>
                cmdReg <= "10";
                go_0 <= not bitDCC;
                go_1 <= bitDCC;
                cmdTemp <= '0';
                EF <= WAITBIT;
            when WAITBIT =>
                cmdReg <= "00";
                go_0 <= '0';
                go_1 <= '0';
                cmdTemp <= '0';
                if fin_0 = '0' and fin_1 = '0' then
                    EF <= WAITBIT;
                elsif (fin_0 = '1' or fin_1 = '1') and finT = '0' then
                    EF <= SEND;
                else
                    EF <= WAITTRAME;
                end if;
            when WAITTRAME =>
                cmdReg <= "00";
                go_0 <= '0';
                go_1 <= '0';
                cmdTemp <= '1';
                if finTemp = '1' then
                    EF <= NOTRAME;
                else
                    EF <= WAITTRAME;
                end if;
        end case;
    end process;
    
end Behav;