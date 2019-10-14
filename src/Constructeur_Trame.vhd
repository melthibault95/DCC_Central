library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.ALL;

ENTITY Constructeur_Trame IS
PORT (
 	 CLK100, RESET 				: IN std_logic;
 	 T_Valid, T_Vitesse, T_Lumiere, T_Alerte : IN std_logic;
 	 T_Adresse : IN std_logic_vector(7 downto 0);
	 Trame_DCC 				 : OUT std_logic_vector(59 downto 0));
END Constructeur_Trame;


ARCHITECTURE Archi of Constructeur_Trame is

SIGNAL dec : std_logic_vector(59 downto 0);
SIGNAL reg_S : std_logic_vector(59 downto 0);

BEGIN

Trame_DCC <= reg_S;

-- Decodage de la trame --

dec(59 downto 46) <= "11111111111111"; -- Preambule
 
dec(45) <= '0'; -- Start 1

dec(44 downto 37) <= T_Adresse; -- Adresse

dec(36) <= '0'; -- Start 2

-- Commande
dec(35 downto 28) <= "01100111" when T_Vitesse = '1' else
                     "10010001" when T_Lumiere = '1' and T_Alerte = '1' else
		             "10000001" when T_Lumiere = '1' and T_Alerte = '0' else
                     "10010000" when T_Lumiere = '0' and T_Alerte = '1' else 		    
                     "01100000" when T_Vitesse = '0' else
                     "10000000";
 		    

dec(27) <= '0';

-- Controle
dec(26 downto 19) <= (dec(44 downto 37)xor dec(35 downto 28));

dec(18) <= '1';

-- Reste
dec(17 downto 0) <= "000000000000000000";

-- Registre de Sortie -- 

PROCESS(CLK100, RESET)

BEGIN

IF RESET = '0' THEN reg_S <= (others => '0');

ELSIF RISING_EDGE(CLK100) THEN

	IF T_Valid = '1' THEN
		reg_S <= dec;
	ELSE
		reg_S <= reg_S;
	END IF;

END IF;

END PROCESS;

END Archi;