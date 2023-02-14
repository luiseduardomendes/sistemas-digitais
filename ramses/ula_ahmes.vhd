library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula_ahmes is
    port(
        ula_in_x : in STD_LOGIC_VECTOR(7 downto 0);
        ula_in_y : in STD_LOGIC_VECTOR(7 downto 0);
        ula_in_c : in STD_LOGIC;
        ula_inst : in STD_LOGIC_VECTOR(7 downto 0);

        ula_out   : out STD_LOGIC_VECTOR(7 downto 0); 
        ula_out_c : out  STD_LOGIC;
		ula_out_b : out  STD_LOGIC;
		ula_out_v : out  STD_LOGIC;
		ula_out_n : out  STD_LOGIC;
		ula_out_z : out  STD_LOGIC
    );
end ula_ahmes;

architecture Behavioral of ula_ahmes is
signal ula_out_temp : std_logic_vector(7 DOWNTO 0);
signal ula_temp : std_logic_vector(8 DOWNTO 0);
signal ula_out_c_temp, ula_out_b_temp, ula_out_v_temp : std_logic;
begin
    process(ula_inst, ula_in_x, ula_in_y, ula_in_c, ula_out_temp, ula_temp,
		ula_out_c_temp, ula_out_b_temp, ula_out_v_temp
	)
		
	begin
	
		ula_out_c_temp <= '0';
		ula_out_b_temp <= '0';
		ula_out_v_temp <= '0';
		
		ula_temp <= (others => '0');
	
		case ula_inst(7 downto 4) is
            when "0000" => -- NOP 
                ula_out_temp <= ula_in_x;
            when "0001" => -- STA
                ula_out_temp <= ula_in_x;
            when "0010" => -- LDA
                ula_out_temp <= ula_in_y;
            when "0011" => -- ADD
				ula_temp <= std_logic_vector(unsigned('0' & ula_in_x) + unsigned('0' & ula_in_y)); 
                ula_out_temp <= ula_temp(7 downto 0);
				ula_out_c_temp <= ula_temp(8);

				ula_out_v_temp <= (ula_in_x(7) xnor ula_in_y(7)) and (ula_out_temp(7) xor ula_in_x(7));	

            when "0100" => -- OR
                ula_out_temp <= ula_in_x or ula_in_y;
            when "0101" => -- AND
                ula_out_temp <= ula_in_x and ula_in_y;
            when "0110" => -- NOT
                ula_out_temp <= not ula_in_x;
            when "0111" => -- SUB
				ula_temp <= std_logic_vector(unsigned('0' & ula_in_x) + not(unsigned('0' & ula_in_y)) + 1); 
                ula_out_temp <= ula_temp(7 downto 0);

				ula_out_b_temp <= (ula_temp(8));
				ula_out_v_temp <= (ula_in_x(7) xor ula_in_y(7)) and (ula_out_temp(7) xnor ula_in_y(7));
            when "1101" => -- NEG
                ula_out_temp <= std_logic_vector( - signed(ula_in_x));
            when "1110" => -- SH and RO
				case ula_inst(1 downto 0) is
					when "01" => -- SHL
						ula_out_c_temp <= ula_in_x(7);
						ula_out_temp <= std_logic_vector(shift_left(unsigned(ula_in_x), 1));
					when "00" => -- SHR
						ula_out_c_temp <= ula_in_x(0);
						ula_out_temp <= std_logic_vector(shift_right(unsigned(ula_in_x), 1));
					when "11" => -- ROL
						ula_out_c_temp <= ula_in_x(7);
						if ula_in_c = '1' then
							ula_out_temp <= std_logic_vector(shift_left(unsigned(ula_in_x), 1) + 1);		
						else
							ula_out_temp <= std_logic_vector(shift_left(unsigned(ula_in_x), 1));		
						end if;
					when others => -- ROR
						ula_out_c_temp <= ula_in_x(0);
						if ula_in_c = '1' then 
							ula_out_temp <= std_logic_vector(shift_right(unsigned(ula_in_x), 1) + 128);		
						else
							ula_out_temp <= std_logic_vector(shift_right(unsigned(ula_in_x), 1));		
						end if;
				end case;
            when others =>	
                ula_out_temp <= ula_in_x;
        end case;
		
	end process;
	ula_out_c <= ula_out_c_temp;
	ula_out_b <= ula_out_b_temp;
	ula_out_v <= ula_out_v_temp;
	ula_out_n <= ula_out_temp(7);
	ula_out_z <= not(ula_out_temp(7) or ula_out_temp(6) or ula_out_temp(5) or ula_out_temp(4) or ula_out_temp(3) or ula_out_temp(2) or ula_out_temp(1) or ula_out_temp(0));
	ula_out <= ula_out_temp;
end Behavioral;