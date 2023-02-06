library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ahmes is
    Port ( 
		   RST: in   STD_LOGIC;
		   CLK: in   STD_LOGIC;
		   AC : out  STD_LOGIC_VECTOR (7 downto 0);
           PC : out  STD_LOGIC_VECTOR (7 downto 0);
           N : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC;
           B : out  STD_LOGIC;
           V : out  STD_LOGIC);
end ahmes;

architecture Behavioral of ahmes is
COMPONENT ramses_cp
	PORT(
		rst : IN std_logic;
		ck : IN std_logic;
		fl_n : IN std_logic;
		fl_z : IN std_logic;
		fl_c : IN std_logic;
		fl_b : IN std_logic;
		fl_v : IN std_logic;
		instr : IN std_logic_vector(7 downto 0);          
		cg_AC : OUT std_logic;
		cg_RI : OUT std_logic;
		cg_PC : OUT std_logic;
		cg_REM : OUT std_logic;
		cg_RDM : OUT std_logic;
		cg_NZ : OUT std_logic;
		cg_C : OUT std_logic;
		cg_B : OUT std_logic;
		cg_V : OUT std_logic;
		cg_read : OUT std_logic;
		cg_write : OUT std_logic;
		sel_REM : OUT std_logic;
		inc_PC : OUT std_logic
		);
		
	END COMPONENT;
	COMPONENT ahmes_po
	PORT(
		sel_rem : IN std_logic;
		inc_pc : IN std_logic;
		cg_RA : IN std_logic;
		cg_ri : IN std_logic;
		cg_pc : IN std_logic;
		cg_rem : IN std_logic;
		cg_rdm : IN std_logic;
		cg_nz : IN std_logic;
		cg_c : IN std_logic;
		cg_b : IN std_logic;
		cg_v : IN std_logic;
		cg_read : IN std_logic;
		cg_write : IN std_logic;
		ck : IN std_logic;
		rst : IN std_logic;          
		ac_out : OUT std_logic_vector(7 downto 0);
		pc_out : OUT std_logic_vector(7 downto 0);
		fl_n_out : OUT std_logic;
		fl_z_out : OUT std_logic;
		fl_c_out : OUT std_logic;
		fl_b_out : OUT std_logic;
		fl_v_out : OUT std_logic
		);
	END COMPONENT;

	
	signal fl_n : std_logic;
	signal fl_z : std_logic;
	signal fl_c : std_logic;
	signal fl_b : std_logic;
	signal fl_v : std_logic;
	signal instr : std_logic_vector(7 downto 0);
	signal cg_AC : std_logic;
	signal cg_RI : std_logic;
	signal cg_PC : std_logic;
	signal cg_REM : std_logic;
	signal cg_RDM : std_logic;
	signal cg_NZ : std_logic;
	signal cg_C : std_logic;
	signal cg_B : std_logic;
	signal cg_V : std_logic;
	signal cg_read : std_logic;
	signal cg_write : std_logic;
	signal sel_REM : std_logic;
	signal inc_PC : std_logic; 
	
begin
	Inst_ramses_cp: ramses_cp PORT MAP(
		rst => RST,
		ck => CLK,
		fl_n => fl_n,
		fl_z => fl_z,
		fl_c => fl_c,
		fl_b => fl_b,
		fl_v => fl_v,
		instr => instr,
		cg_AC => cg_AC,
		cg_RI => cg_RI,
		cg_PC => cg_PC,
		cg_REM => cg_REM,
		cg_RDM => cg_RDM,
		cg_NZ => cg_NZ,
		cg_C => cg_C,
		cg_B => cg_B,
		cg_V => cg_V,
		cg_read => cg_read,
		cg_write => cg_write,
		sel_REM => sel_REM,
		inc_PC => inc_PC
	);
	
	Inst_ahmes_po: ahmes_po PORT MAP(
		ac_out => AC,
		pc_out => PC,
		sel_rem => sel_REM,
		inc_pc => inc_pc,
		cg_RA => cg_AC,
		cg_ri => cg_ri,
		cg_pc => cg_pc,
		cg_rem => cg_rem,
		cg_rdm => cg_rdm,
		cg_nz => cg_nz,
		cg_c => cg_c,
		cg_b => cg_b,
		cg_v => cg_v,
		cg_read => cg_read,
		cg_write => cg_write,
		fl_n_out => fl_n,
		fl_z_out => fl_z,
		fl_c_out => fl_c,
		fl_b_out => fl_b,
		fl_v_out => fl_v,
		ck => CLK,
		rst => RST
	);
	n <= fl_n;
	z <= fl_z;
	c <= fl_c;
	b <= fl_b;
	v <= fl_v;

end Behavioral;

