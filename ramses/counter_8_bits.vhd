library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_8_bits is
    Port ( D : in  STD_LOGIC_VECTOR (7 downto 0);
           Q : out  STD_LOGIC_VECTOR (7 downto 0);
           R : in  STD_LOGIC;
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC);
end counter_8_bits;

architecture Behavioral of counter_8_bits is
signal reg : std_logic_vector(7 downto 0);
begin
	process(r, clk)
  	begin
		if R = '1' then
			reg <= (others => '0');
		elsif clk'event and clk = '1' then
			case sel is
				when "00" => 
					REG <= REG;
				when "01" =>
					REG <= std_logic_vector(unsigned(reg) + 1);
				when "10" =>
					REG <= D;
				when others =>
					REG <= REG;
			end case;
		end if;
	end process;
	Q <= REG;
end Behavioral;

