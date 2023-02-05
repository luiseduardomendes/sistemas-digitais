
-- VHDL Instantiation Created from source file counter_8_bits.vhd -- 19:41:45 02/04/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT counter_8_bits
	PORT(
		D : IN std_logic_vector(7 downto 0);
		R : IN std_logic;
		sel : IN std_logic_vector(1 downto 0);
		ck : IN std_logic;          
		Q : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_counter_8_bits: counter_8_bits PORT MAP(
		D => ,
		Q => ,
		R => ,
		sel => ,
		ck => 
	);


