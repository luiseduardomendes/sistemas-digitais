----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:38:55 02/04/2023 
-- Design Name: 
-- Module Name:    ffd - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ffd is
    Port ( D : in  STD_LOGIC;
           Q : out  STD_LOGIC;
           E : in  STD_LOGIC;
           R : in  STD_LOGIC;
           ck : in  STD_LOGIC);
end ffd;

architecture Behavioral of ffd is
signal reg : std_logic;
begin
	process(r, ck)
  	begin
		if R = '1' then
			reg <= '0';
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

