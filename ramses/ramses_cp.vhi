
-- VHDL Instantiation Created from source file ramses_cp.vhd -- 02:08:49 02/06/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

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

	Inst_ramses_cp: ramses_cp PORT MAP(
		rst => ,
		ck => ,
		fl_n => ,
		fl_z => ,
		fl_c => ,
		fl_b => ,
		fl_v => ,
		instr => ,
		cg_AC => ,
		cg_RI => ,
		cg_PC => ,
		cg_REM => ,
		cg_RDM => ,
		cg_NZ => ,
		cg_C => ,
		cg_B => ,
		cg_V => ,
		cg_read => ,
		cg_write => ,
		sel_REM => ,
		inc_PC => 
	);


