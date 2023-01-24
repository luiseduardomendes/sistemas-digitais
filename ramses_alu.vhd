library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ramses_alu is
    Port ( X : in  STD_LOGIC_VECTOR (7 downto 0);
           Y : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0);
           c_in : in  STD_LOGIC;
           op_code : in  STD_LOGIC_VECTOR (7 downto 0);
           c_flag : out  STD_LOGIC;
           b_flag : out  STD_LOGIC;
           v_flag : out  STD_LOGIC;
           n_flag : out  STD_LOGIC;
           z_flag : out  STD_LOGIC);
end ramses_alu;

architecture Behavioral of ramses_alu is

signal output : std_logic_vector(7 downto 0);
begin
    process(op_code)
    begin
        case op_code(7 downto 4) is
            when "0000" => 
                output <= X;
            when "0001" =>
                output <= X;
            when "0010" =>
                output <= Y;
            when "0011" =>
                output <= std_logic_vector(signed(X) + signed(Y));
				v_flag <= (x(7) and y(7) and not(output(7))) or (not(x(7)) and not(y(7)) and output(7));
            when "0100" =>
                output <= X or Y;
            when "0101" =>
                output <= X and Y;
            when "0110" =>
                output <= not X;
            when "0111" =>
                output <= std_logic_vector(signed(X) - signed(Y));
				v_flag <= (x(7) and not(y(7)) and not(output(7))) or (not(x(7)) and y(7) and output(7));
            when "1101" =>
                output <= std_logic_vector( - signed(X));
            when "1110" =>
                output(0) <= output(1);
				output(1) <= output(2);
				output(2) <= output(3);
				output(3) <= output(4);
				output(4) <= output(5);
				output(5) <= output(6);
				output(6) <= output(7);
				output(7) <= c_in;
                c_flag <= x(0);
            when others =>
                output <= X;
        end case;
    end process;
    n_flag <= (output(7));
    z_flag <= '1' when output = "00000000" else '0';
	S <= output;


end Behavioral;

