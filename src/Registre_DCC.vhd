library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

ENTITY Registre_DCC IS
PORT (
  CLK100, RESET : IN std_logic;
  COM_REG : IN std_logic_vector(1 downto 0);
  TRAME_DCC : IN std_logic_vector(59 downto 0);
  S, FIN : OUT std_logic);
END Registre_DCC;


ARCHITECTURE Archi of Registre_DCC is

SIGNAL reg : std_logic_vector(59 downto 0);
SIGNAL reg_cpt : integer;
SIGNAL s_s : std_logic;

BEGIN

S <= s_s;
FIN <= '1' when reg_cpt = 0 else '0';

PROCESS(CLK100,RESET) 

BEGIN

	IF RESET='0' THEN
		reg <= (OTHERS=>'0');
		reg_cpt <= 0;
		s_s <= '0';
		

  	ELSIF CLK100'event and CLK100='1' THEN


		IF COM_REG = "01" THEN
			reg <= TRAME_DCC;
			IF reg(18) = '1' THEN
				reg_cpt <= 43;
	
			ELSIF reg(9) = '1' THEN
				reg_cpt <= 52;

			ELSIF reg(0) = '1' THEN
				reg_cpt <= 61;
			ELSE
				reg_cpt <= 0; 

			END IF;

		ELSIF COM_REG = "10" THEN
			s_s <= reg(59);
			reg(59 downto 1) <= reg(58 downto 0);
			reg_cpt <= reg_cpt - 1;
			
		ELSE
			reg(59 downto 0) <= reg(59 downto 0);
			reg_cpt <= reg_cpt;
		END IF;

	END IF;

END PROCESS;



END Archi;