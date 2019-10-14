library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

ENTITY Generateur_Trame IS
PORT (
 	 CLK100, RESET 				: IN std_logic;
	 R_Valid, R_Vitesse, R_lumiere, R_Alerte : IN std_logic;
	 	 R_Adresse : IN std_logic_vector (7 downto 0);
	 Trame_DCC 				: OUT std_logic_vector(59 downto 0));
END Generateur_Trame;


ARCHITECTURE Archi of Generateur_Trame is


BEGIN

 --Interf : entity work.Interface_util
  --     port map(CLK100, RESET, SW, Button_C, Button_L, Valid, Vitesse, Lumiere, Alerte, LED);

 --Reg : entity work.Reg
       --port map(CLK100, RESET,  Valid, Vitesse, Lumiere, Alerte, T_Valid, T_Vitesse, T_Lumiere, T_Alerte);

Constru : entity work.Constructeur_Trame
       port map(CLK100, RESET, R_Valid, R_Vitesse, R_Lumiere, R_Alerte, R_Adresse, Trame_DCC);


END Archi;