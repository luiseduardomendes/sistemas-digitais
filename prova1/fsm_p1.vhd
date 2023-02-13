library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           E : in  STD_LOGIC;
           Z : out STD_LOGIC_VECTOR (1 downto 0);
		   S : out STD_LOGIC_VECTOR (1 downto 0));
		   
end fsm;

architecture Behavioral of fsm is
type t_state is (s1,s2,s3);

signal state, next_state : t_state;
begin
	state_register : process(clk, rst)
	begin
		if rst = '1' then
			state <= s1;
		elsif clk='1' and clk'event then
			state <= next_state;
		else
			state <= state;
		end if;
	end process;
	
	new_state : process(e)
	begin
		case state is
			when s1 =>
				if e = '1' then
					z <= "01";
					next_state <= s2;
				else
					z <= "00";
					next_state <= s3;
				end if;
				S <= "01";
			when s2 =>
				if e = '1' then
					z <= "11";
					next_state <= s1;
				else
					z <= "11";
					next_state <= s3;
				end if;
				S <= "10";
			when others =>
				if e = '1' then
					z <= "10";
					next_state <= s3;
				else
					z <= "00";
					next_state <= s2;
				end if;
				S <= "11";
				
		end case;
	end process;

end Behavioral;

