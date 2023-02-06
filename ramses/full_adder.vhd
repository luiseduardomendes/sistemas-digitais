library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity full_adder is
    Port ( X        : in  STD_LOGIC;
           Y        : in  STD_LOGIC;
           C_IN     : in  STD_LOGIC;
           S        : out  STD_LOGIC;
           C_OUT    : out  STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is
signal w1 : std_logic;
begin
    w1 <= (X xor Y);
    S <= w1 xor C_IN;
    C_OUT <= (w1 and C_IN) or (X and Y);
end Behavioral;

