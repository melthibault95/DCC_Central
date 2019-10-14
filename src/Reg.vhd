library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.ALL;

ENTITY Reg IS
PORT (
 	 CLK100, RESET 				: IN std_logic;
 	 Valid, Vitesse, Lumiere, Alerte	: IN std_logic;
 	 T_Valid, T_Vitesse, T_Lumiere, T_Alerte : OUT std_logic);
END Reg;


ARCHITECTURE Archi of Reg is

BEGIN

T_Valid <= Valid;
T_Vitesse <= Vitesse;
T_Lumiere <= Lumiere;
T_Alerte <= Alerte;

END Archi;


