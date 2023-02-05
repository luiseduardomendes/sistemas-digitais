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

 -- other wires
signal rdm_in : std_logic_vector(7 downto 0);
signal rma_in : std_logic_vector(7 downto 0);
signal sel_pc : std_logic_vector(1 downto 0); 

COMPONENT counter_8_bits
PORT(
	D : IN std_logic_vector(7 downto 0);
	R : IN std_logic;
	sel : IN std_logic_vector(1 downto 0);
	ck : IN std_logic;          
	Q : OUT std_logic_vector(7 downto 0)
	);
END COMPONENT;
COMPONENT register_8_bits
PORT(
	D : IN std_logic_vector(7 downto 0);
	E : IN std_logic;
	R : IN std_logic;
	ck : IN std_logic;          
	Q : OUT std_logic_vector(7 downto 0)
	);
END COMPONENT;
COMPONENT ffd
PORT(
	D : IN std_logic;
	E : IN std_logic;
	R : IN std_logic;
	ck : IN std_logic;          
	Q : OUT std_logic
	);
END COMPONENT;

	

	

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

	accumulator : register_8_bits PORT MAP(
		D => ula_out,
		Q => RA,
		E => cg_ra,
		R => rst,
		ck => ck
	);
	
	instr_register : register_8_bits PORT MAP(
		D => RDM,
		Q => RI,
		E => cg_ri,
		R => rst,
		ck => ck
	);


	sel_rdm_in : process(cg_read, cg_rdm)
	begin
		if cg_rdm = '1' then
			rdm_in <= RA;
		end if;
		if cg_read = '1' then 
			rdm_in <= mem_out;
		end if;
	end process;

	mem_data_reg : register_8_bits PORT MAP(
		D => rdm_in,
		Q => rdm,
		E => cg_rdm or cg_read,
		R => rst,
		ck => ck
	);
	
	sel_rma_in : process(sel_rem)
  	begin
		if sel_rem = '1' then
			RMA_in <= PC;
		else
			RMA_in <= RDM;
		end if;
	end process;

	mem_addr_reg : register_8_bits PORT MAP(
		D => rma_in,
		Q => RMA,
		E => cg_rem,
		R => rst,
		ck => ck
	);

	set_sel_pc : process(inc_pc, cg_pc)
  	begin
		if inc_pc = '1' then
			sel_pc <= "01";
		elsif cg_pc = '1' then
			sel_pc <= "10";
		else 
			sel_pc <= "00";
		end if;
	end process;

	prog_counter: counter_8_bits PORT MAP(
		D => RDM,
		Q => PC,
		R => Rst,
		sel => sel_pc,
		ck => ck
	);
			
	flag_neg: ffd PORT MAP(
		D => ula_out_n,
		Q => fl_n,
		E => cg_nz,
		R => rst,
		ck => ck
	);

	flag_zero: ffd PORT MAP(
		D => ula_out_z,
		Q => fl_z,
		E => cg_nz,
		R => rst,
		ck => ck
	);

	flag_carry: ffd PORT MAP(
		D => ula_out_c,
		Q => fl_c,
		E => cg_c,
		R => rst,
		ck => ck
	);

	flag_borrow : ffd PORT MAP(
		D => ula_out_b,
		Q => fl_b,
		E => cg_b,
		R => rst,
		ck => ck
	);

	flag_overflow : ffd PORT MAP(
		D => ula_out_v,
		Q => fl_v,
		E => cg_v,
		R => rst,
		ck => ck
	);

	ac_out <= ra;
	pc_out <= pc;

end Behavioral;

