
-- VHDL Instantiation Created from source file full_adder.vhd -- 12:15:24 01/26/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT full_adder
	PORT(
		X : IN std_logic;
		Y : IN std_logic;
		C_IN : IN std_logic;          
		S : OUT std_logic_vector(7 downto 0);
		C_OUT : OUT std_logic
		);
	END COMPONENT;

	Inst_full_adder: full_adder PORT MAP(
		X => ,
		Y => ,
		C_IN => ,
		S => ,
		C_OUT => 
	);


