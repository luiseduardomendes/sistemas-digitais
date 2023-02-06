library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity half_adder is
    Port ( X        : in  STD_LOGIC;
           Y        : in  STD_LOGIC;
           S        : out  STD_LOGIC;
           C_OUT    : out  STD_LOGIC);
end half_adder;

architecture Behavioral of half_adder is
begin
    S <= X xor Y;
    C_OUT <= X and Y;
end Behavioral;

