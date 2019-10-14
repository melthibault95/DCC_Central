library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

ENTITY Tempo IS
PORT (
  CLK,RESET,COM_TEMPO :IN std_logic;
  FIN : OUT std_logic);
END Tempo;


ARCHITECTURE Archi of Tempo is

SIGNAL cpt : std_logic_vector(12 downto 0);

BEGIN

-- Mise a 1 de FIN si cpt = 6000
FIN <= '1' WHEN cpt = "1011101110000" else '0';

-- Incrementation si COM_TEMPO = 1 et raz si COM_TEMPO = 0
PROCESS(CLK,RESET) 

BEGIN

	IF RESET='0' THEN
		cpt <= (OTHERS=>'0');

  	ELSIF CLK'event and CLK='1' THEN

		IF cpt = "1011101110000" THEN
			cpt <= (OTHERS=>'0');

		ELSIF COM_TEMPO='1' THEN
			cpt <= cpt + 1;

		ELSE
			cpt <= (OTHERS=>'0');

		END IF;
 	 END IF;

END PROCESS;

END Archi;