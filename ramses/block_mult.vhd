library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity block_mult is
    Port ( 
        mk : in  STD_LOGIC;
        qj : in  STD_LOGIC;
        ci : in  STD_LOGIC;
        s_1: in  STD_LOGIC;
        
        s : out  STD_LOGIC;
        co : out  STD_LOGIC
    );
end block_mult;


architecture Behavioral of block_mult is
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
    fa : entity work.full_adder port map (
        x => mk and qj,
        y => s_1,
        s => S,
        c_in => ci,
        c_out => co
    );


end Behavioral;

