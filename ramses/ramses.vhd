library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ahmes_po is
    Port ( 
		ac_out: out  STD_LOGIC_VECTOR (7 downto 0);
		pc_out: out  STD_LOGIC_VECTOR (7 downto 0);
		
		mem_out : in  STD_LOGIC_VECTOR (7 downto 0);
		mem_in : out  STD_LOGIC_VECTOR (7 downto 0);
		mem_end : out STD_LOGIC_VECTOR (7 downto 0);

		sel_rem : in  STD_LOGIC;
		inc_pc : in  STD_LOGIC;

		cg_RA : in  STD_LOGIC;
		cg_ri : in  STD_LOGIC;
		cg_pc : in  STD_LOGIC;
		cg_rem : in  STD_LOGIC;
		cg_rdm : in  STD_LOGIC;
		cg_nz : in  STD_LOGIC;
		cg_c : in  STD_LOGIC;
		cg_b : in  STD_LOGIC;
		cg_v : in  STD_LOGIC;
		cg_read : in STD_LOGIC;

		n_out : out  STD_LOGIC;
		z_out : out  STD_LOGIC;
		c_out : out  STD_LOGIC;
		b_out : out  STD_LOGIC;
		v_out : out  STD_LOGIC;

		ck : in STD_LOGIC;
		rst : in STD_LOGIC
	);
end ahmes_po;

architecture Behavioral of ahmes_po is
 -- registers
signal PC  : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal RA  : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal RI  : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal RDM : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal RMA : STD_LOGIC_VECTOR(7 DOWNTO 0);
 -- flag registers
signal fl_n :  STD_LOGIC;
signal fl_z :  STD_LOGIC;
signal fl_c :  STD_LOGIC;
signal fl_b :  STD_LOGIC;
signal fl_v :  STD_LOGIC;

 -- ula wires
signal ula_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ula_in_x : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ula_in_y : STD_LOGIC_VECTOR(7 DOWNTO 0);
 -- ula flags
signal ula_out_c : STD_LOGIC;
signal ula_out_b : STD_LOGIC;
signal ula_out_v : STD_LOGIC;
signal ula_out_n : STD_LOGIC;
signal ula_out_z : STD_LOGIC;

begin
	
	ula_in_x <= RA;
	ula_in_y <= RDM;

	mem_end <= RMA;
	mem_in <= rdm;

	process(ck, rst, RI, ula_in_x, ula_in_y, ula_out)
		variable ula_temp : std_logic_vector(8 DOWNTO 0);
	begin
		case RI(7 downto 4) is
            when "0000" => -- NOP 
                ula_out <= ula_in_x;
            when "0001" => -- STA
                ula_out <= ula_in_x;
            when "0010" => -- LDA
                ula_out <= ula_in_y;
            when "0011" => -- ADD
				ula_temp := std_logic_vector(unsigned('0' & ula_in_x) + unsigned('0' & ula_in_y)); 
                ula_out <= ula_temp(7 downto 0);
				ula_out_c <= ula_temp(8);

				ula_out_v <= (ula_in_x(7) and ula_in_y(7) and not(ula_out(7))) or (not(ula_in_x(7)) and not(ula_in_y(7)) and ula_out(7));	

            when "0100" => -- OR
                ula_out <= ula_in_x or ula_in_y;
            when "0101" => -- AND
                ula_out <= ula_in_x and ula_in_y;
            when "0110" => -- NOT
                ula_out <= not ula_in_x;
            when "0111" => -- SUB
				ula_temp := std_logic_vector(unsigned('0' & ula_in_x) - unsigned('0' & ula_in_y)); 
                ula_out <= ula_temp(7 downto 0);

				ula_out_b <= not(ula_temp(8));
				ula_out_v <= (ula_in_x(7) and not(ula_in_y(7)) and not(ula_out(7))) or (not(ula_in_x(7)) and ula_in_y(7) and ula_out(7));
            when "1101" => -- NEG
                ula_out <= std_logic_vector( - signed(ula_in_x));
            when "1110" => -- SH and RO
				case RI(1 downto 0) is
					when "01" => -- SHL
						ula_out_c <= ula_in_x(0);
						ula_out <= std_logic_vector(shift_left(unsigned(ula_in_x), 1));
					when "00" => -- SHR
						ula_out_c <= ula_in_x(7);
						ula_out <= std_logic_vector(shift_right(unsigned(ula_in_x), 1));
					when "11" => -- ROL
						ula_out_c <= ula_in_x(7);
						if fl_c = '1' then
							ula_out <= std_logic_vector(shift_left(unsigned(ula_in_x), 1) + 128);		
						else
							ula_out <= std_logic_vector(shift_left(unsigned(ula_in_x), 1));		
						end if;
					when others => -- ROR
						ula_out_c <= ula_in_x(7);
						if fl_c = '1' then
							ula_out <= std_logic_vector(shift_right(unsigned(ula_in_x), 1) + 1);		
						else
							ula_out <= std_logic_vector(shift_right(unsigned(ula_in_x), 1));		
						end if;
				end case;
            when others =>
                ula_out <= ula_in_x;
        end case;
		ula_out_n <= ula_out(7);
		ula_out_z <= not(ula_out(7) or ula_out(6) or ula_out(5) or ula_out(4) or ula_out(3) or ula_out(2) or ula_out(1) or ula_out(0));

		n_out <= fl_n;
		z_out <= fl_z;
		c_out <= fl_c;
		v_out <= fl_v;
		b_out <= fl_b;
	end process;

	
	accumulator : process(rst, ck)
  	begin
		if rst = '1' then
			RA <= (others => '0');
		elsif ck'event and ck = '1' then
			if cg_ra = '1' then
				RA <= ula_out;
			end if;
		end if;
	end process;
	
	inst_register : process(rst, ck)
  	begin	 
		if rst = '1' then
			RI <= (others => '0');
		elsif ck'event and ck = '1' then
			if cg_ri = '1' then
				RI <= RDM;
			end if;
		end if;
	end process;

	mem_data_reg : process(rst, ck)
  	begin	 
		if rst = '1' then
			RDM <= (others => '0');
		elsif ck'event and ck = '1' then
			if cg_rdm = '1' then
				RDM <= RA;
			end if;
			if cg_read = '1' then 
				rdm <= mem_out;
			end if;
		end if;
	end process;

	mem_addr_reg : process(rst, ck)
  	begin	 
		if rst = '1' then
			RMA <= (others => '0');
		elsif ck'event and ck = '1' then
			if cg_rem = '1' then
				if sel_rem = '1' then
					RMA <= PC;
				else
					RMA <= RDM;
				end if;
			end if;
		end if;
	end process;

	prog_counter : process(rst, ck)
  	begin	 
		if rst = '1' then
			PC <= (others => '0');
		elsif ck'event and ck = '1' then
			if cg_pc = '1' then
				PC <= RDM;
			end if;
			if inc_pc = '1' then
				PC <= std_logic_vector(unsigned(PC) + 1);
			end if;
		end if;
	end process;
			
	flag_neg_zero : process(rst, ck)
	begin
		if rst = '1' then
			fl_z <= '0';
			fl_n <= '0';
		elsif ck'event and ck = '1' then
			if cg_nz = '1' then
				fl_n <= ula_out_n;
				fl_z <= ula_out_z;
			end if;
		end if;
	end process;

	flag_carry : process(rst, ck)
	begin
		if rst = '1' then
			fl_c <= '0';
		elsif ck'event and ck = '1' then
			if cg_c = '1' then
				fl_c <= ula_out_c;
			end if;
		end if;
	end process;

	flag_borrow : process(rst, ck)
	begin
		if rst = '1' then
			fl_b <= '0';
		elsif ck'event and ck = '1' then
			if cg_b = '1' then
				fl_b <= ula_out_b;
			end if;
		end if;
	end process;
	
	flag_overflow : process(rst, ck)
	begin
		if rst = '1' then
			fl_v <= '0';
		elsif ck'event and ck = '1' then
			if cg_v = '1' then
				fl_v <= ula_out_v;
			end if;
		end if;
	end process;

	ac_out <= ra;
	pc_out <= pc;

end Behavioral;

