
-- VHDL Instantiation Created from source file ahmes_po.vhd -- 02:09:29 02/06/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

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

	Inst_ahmes_po: ahmes_po PORT MAP(
		ac_out => ,
		pc_out => ,
		sel_rem => ,
		inc_pc => ,
		cg_RA => ,
		cg_ri => ,
		cg_pc => ,
		cg_rem => ,
		cg_rdm => ,
		cg_nz => ,
		cg_c => ,
		cg_b => ,
		cg_v => ,
		cg_read => ,
		cg_write => ,
		fl_n_out => ,
		fl_z_out => ,
		fl_c_out => ,
		fl_b_out => ,
		fl_v_out => ,
		ck => ,
		rst => 
	);


