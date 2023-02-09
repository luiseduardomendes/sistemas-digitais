library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ahmes_po is
    Port ( 
		ac_out: out  STD_LOGIC_VECTOR (7 downto 0);
		pc_out: out  STD_LOGIC_VECTOR (7 downto 0);
		
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
		cg_write: in STD_LOGIC;

		fl_n_out : out std_logic;
		fl_z_out : out std_logic;
		fl_c_out : out std_logic;
		fl_b_out : out std_logic;
		fl_v_out : out std_logic;

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
signal fl_z : std_logic;
signal fl_n : std_logic;
signal fl_c : std_logic;
signal fl_b : std_logic;
signal fl_v : std_logic;


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
signal EN_RDM : STD_LOGIC;

signal mem_out : STD_LOGIC_VECTOR (7 downto 0);
signal mem_in :  STD_LOGIC_VECTOR (7 downto 0);
signal mem_end : STD_LOGIC_VECTOR (7 downto 0);
signal mem_sel : STD_LOGIC_VECTOR (0 downto 0);

COMPONENT mem
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

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
COMPONENT ULA_AHMES
PORT(
	ula_in_x : in STD_LOGIC_VECTOR(7 downto 0);
	ula_in_y : in STD_LOGIC_VECTOR(7 downto 0);
	ula_in_c : in STD_LOGIC;
	ula_inst : in STD_LOGIC_VECTOR(7 downto 0);

	ula_out : out STD_LOGIC_VECTOR(7 downto 0); 
	ula_out_c : out  STD_LOGIC;
	ula_out_b : out  STD_LOGIC;
	ula_out_v : out  STD_LOGIC;
	ula_out_n : out  STD_LOGIC;
	ula_out_z : out  STD_LOGIC
	);
END COMPONENT;
	

begin
	mem_sel(0) <= cg_write;
	ram : mem PORT MAP (
		clka => ck,
		wea => mem_sel,
		addra => mem_end,
		dina => mem_in,
		douta => mem_out
	);
	
	ULA : ULA_AHMES port MAP(
		ula_in_x => ula_in_x,
		ula_in_y => ula_in_y,
		ula_in_c => fl_c, 
		ula_inst => RI, 

		ula_out   => ula_out,
		ula_out_c => ula_out_c,
		ula_out_b => ula_out_b,
		ula_out_v => ula_out_v,
		ula_out_n => ula_out_n,
		ula_out_z => ula_out_z
	);

	ula_in_x <= RA;
	ula_in_y <= RDM;

	mem_end <= RMA;
	mem_in <= rdm;

	
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


	sel_rdm_in : process(cg_read, cg_rdm, ra, mem_out)
	begin
		if cg_rdm = '1' then
			rdm_in <= RA;
		elsif cg_read = '1' then 
			rdm_in <= mem_out;
		else
			rdm_in <= (others => '0');
		end if;
	end process;

	en_rdm <= cg_rdm or cg_read;
	mem_data_reg : register_8_bits PORT MAP(
		D => rdm_in,
		Q => rdm,
		E => en_rdm,
		R => rst,
		ck => ck
	);
	
	sel_rma_in : process(sel_rem, pc, rdm)
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

	fl_z_out <= fl_z;
	fl_n_out <= fl_n;
	fl_c_out <= fl_c;
	fl_b_out <= fl_b;
	fl_v_out <= fl_v;

end Behavioral;

