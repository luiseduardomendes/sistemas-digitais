library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplication is
    Port ( X : in  STD_LOGIC_VECTOR (7 downto 0);
           Y : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (15 downto 0);
           v : out  STD_LOGIC);
end multiplication;

architecture Behavioral of multiplication is
    COMPONENT block_mult_top
	PORT(
		mk0 : IN std_logic;
		mk1 : IN std_logic;
        q0  : IN std_logic;
	    q1  : IN std_logic;
		ci  : IN std_logic;
        
        s   : OUT std_logic;
		co  : OUT std_logic
    );
	END COMPONENT;
    COMPONENT block_mult
	PORT(
		mk  : IN std_logic;
        qj  : IN std_logic;
		ci  : IN std_logic;
        s_1 : IN std_logic;
        s   : OUT std_logic;
		co  : OUT std_logic
    );
	END COMPONENT;
    type array2D is array (natural range <>, natural range <>) of std_logic;
    signal c : array2D(7 downto 0, 7 downto 0);
    signal q : array2D(7 downto 0, 15 downto 0);

begin
    S(0) <= X(0) and Y(0);
    a : for i in 0 to 6 generate 
        top : block_mult_top port map (
            mk0 => X(i),
            mk1 => X(i + 1),
            q0 => Y(0),
            q1 => Y(1),
            ci => '0',
            
            s  => q(i, 0),
            co => c(i, 0)
        );
    end generate;
    b : for i in 1 to 7 generate 
        c : for j in 1 to 7 generate 
            top : block_mult port map (
                mk => X(i),
                qj => Y(j),
                ci => c(i, j-1),
                s_1=> q(i-1, j),

                s  => q(i, j),
                co => c(i, j)
            );
        end generate;
    end generate;
    
end architecture;

