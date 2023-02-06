library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity block_mult_top is
    Port ( 
        mk0 : in  STD_LOGIC;
        mk1 : in  STD_LOGIC;
        q0 : in  STD_LOGIC;
        q1 : in  STD_LOGIC;
        ci : in  STD_LOGIC;
        S : out  STD_LOGIC;
        co : out  STD_LOGIC
    );
end block_mult_top;


architecture Behavioral of block_mult_top is
COMPONENT full_adder
PORT(
    X       : IN  std_logic;
    Y       : IN  std_logic;    
    C_IN    : IN  std_logic;         
    S       : OUT std_logic;
    C_OUT   : OUT std_logic
);
END COMPONENT;
    
begin
    fa : full_adder port map(
        x => (mk1 and q0),
        y => (mk0 and q1),
        s => S,
        c_in => ci,
        c_out => co
    );


end Behavioral;

