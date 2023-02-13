library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ffd is
    Port ( D : in  STD_LOGIC;
           Q : out  STD_LOGIC;
           E : in  STD_LOGIC;
           R : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end ffd;

architecture Behavioral of ffd is
signal reg : std_logic;
begin
	process(r, clk)
  	begin
		if R = '1' then
			reg <= '0';
		elsif clk'event and clk = '1' then
			if E = '1' then
				REG <= D;
			else
				REG <= REG;
			end if;
		end if;
	end process;
	Q <= REG;
end Behavioral;

