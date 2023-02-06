library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_8_bits is
    Port ( D : in  STD_LOGIC_VECTOR (7 downto 0);
           Q : out  STD_LOGIC_VECTOR (7 downto 0);
           E : in  STD_LOGIC;
           R : in  STD_LOGIC;
           ck : in  STD_LOGIC);
end register_8_bits;

architecture Behavioral of register_8_bits is
signal reg : std_logic_vector(7 downto 0);
begin
	process(r, ck)
  	begin
		if R = '1' then
			reg <= (others => '0');
		elsif ck'event and ck = '1' then
			if E = '1' then
				REG <= D;
			else
				REG <= REG;
			end if;
		end if;
	end process;
	Q <= REG;
end Behavioral;

