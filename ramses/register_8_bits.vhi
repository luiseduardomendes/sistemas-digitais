
-- VHDL Instantiation Created from source file register_8_bits.vhd -- 19:17:22 02/04/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT register_8_bits
	PORT(
		D : IN std_logic_vector(7 downto 0);
		E : IN std_logic;
		R : IN std_logic;
		ck : IN std_logic;          
		Q : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_register_8_bits: register_8_bits PORT MAP(
		D => ,
		Q => ,
		E => ,
		R => ,
		ck => 
	);


