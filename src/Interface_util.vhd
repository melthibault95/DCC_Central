library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity Interface_util is
    port(Clk 			: in  STD_LOGIC; -- Création d'une horloge pour échantillonage
         Reset 			: in  STD_LOGIC;
	 SW			: in  std_logic_vector(14 downto 0);
	 Button_C, Button_L  	: in  std_logic;
	 
	 Valid			: out std_logic;
	 Vitesse		: out std_logic;
	 Lumiere		: out std_logic;
	 Alerte			: out std_logic;

         LED			: out std_logic_vector(15 downto 0));
end entity;

architecture behav of Interface_util is

signal Last_C, Last_L, Last_RC, Last_RL, Button_LR, Button_CR , startl, startc, c : std_logic;
signal cptl, cptc : std_logic_vector(22 downto 0);

begin

Valid <= c;
Vitesse <= SW(0);
Lumiere <= SW(1);
Alerte <= SW(2);

LED(0) <= SW(0);
LED(1) <= SW(1);
LED(2) <= SW(2);

	
	process(reset,Clk)

	begin

		-- Reset Asynchrone
		if reset ='0' then Last_L <= '0'; Last_C <= '0'; c <= '0';
		elsif rising_edge(Clk) then

		  -- Incrémentation Si on Appuie sur le Bouton Left
		  if (Button_LR = '1') and (Last_L = '0') then			
			 Last_L <= '1';
		  elsif (Button_LR = '0') and (Last_L = '1') then
		     	 Last_L <= '0';
		  end if;
		
		  -- Décrémentation Si on Appuie sur le Bouton Center
		  if (Button_CR = '1') and (Last_C = '0') then
			c <= '1';			
               		Last_C <= '1';
		  elsif (Button_CR = '0') and (Last_C = '1') then
                   	Last_C <= '0';
			c <= '0';	
		  else
			c <= '0';
          	  end if;
          
		end if;
	end process;
	
    
    process(reset,Clk)
    begin
    
        if reset = '0' then cptl <= (others => '0'); cptc <= (others => '0'); Last_RL <= '0'; Last_RC <= '0'; startl <= '0'; startc <= '0';
        elsif rising_edge(Clk) then
        
            if (cptl = 50) then
                cptl <= (others => '0');
                Button_LR <= '0';
                startl <= '0';
            elsif startl = '1' then
                cptl <= cptl + 1;   
            elsif (Button_L = '1') and (Last_RL = '0') then
                Last_RL <= '1';
                Button_LR <= '1';
            elsif (Button_L = '0') and (Last_RL = '1') then
                Last_RL <= '0';
                Button_LR <= '1';
                startl <= '1';
            end if;
            
            if (cptc = 50) then
                cptc <= (others => '0');
                Button_CR <= '0';
                startc <= '0';
            elsif startc = '1' then
                cptc <= cptc + 1;   
            elsif (Button_C = '1') and (Last_RC = '0') then
                Last_RC <= '1';
                Button_CR <= '1';
            elsif (Button_C = '0') and (Last_RC = '1') then
                Last_RC <= '0';
                Button_CR <= '1';
                startc <= '1';
            end if;   
        end if;  
     end process;     
    
end behav;
