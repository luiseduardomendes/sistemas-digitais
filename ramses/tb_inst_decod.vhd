LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_inst_decod IS
END tb_inst_decod;
 
ARCHITECTURE behavior OF tb_inst_decod IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT instr_decod
    PORT(
         instr : IN  std_logic_vector(7 downto 0);
         op_nop : OUT  std_logic;
         op_sta : OUT  std_logic;
         op_lda : OUT  std_logic;
         op_add : OUT  std_logic;
         op_or : OUT  std_logic;
         op_and : OUT  std_logic;
         op_not : OUT  std_logic;
         op_sub : OUT  std_logic;
         op_jmp : OUT  std_logic;
         op_jn : OUT  std_logic;
         op_jp : OUT  std_logic;
         op_jv : OUT  std_logic;
         op_jnv : OUT  std_logic;
         op_jz : OUT  std_logic;
         op_jnz : OUT  std_logic;
         op_jc : OUT  std_logic;
         op_jnc : OUT  std_logic;
         op_jb : OUT  std_logic;
         op_jnb : OUT  std_logic;
         op_shr : OUT  std_logic;
         op_shl : OUT  std_logic;
         op_ror : OUT  std_logic;
         op_rol : OUT  std_logic;
         op_hlt : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal instr : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal op_nop : std_logic;
   signal op_sta : std_logic;
   signal op_lda : std_logic;
   signal op_add : std_logic;
   signal op_or : std_logic;
   signal op_and : std_logic;
   signal op_not : std_logic;
   signal op_sub : std_logic;
   signal op_jmp : std_logic;
   signal op_jn : std_logic;
   signal op_jp : std_logic;
   signal op_jv : std_logic;
   signal op_jnv : std_logic;
   signal op_jz : std_logic;
   signal op_jnz : std_logic;
   signal op_jc : std_logic;
   signal op_jnc : std_logic;
   signal op_jb : std_logic;
   signal op_jnb : std_logic;
   signal op_shr : std_logic;
   signal op_shl : std_logic;
   signal op_ror : std_logic;
   signal op_rol : std_logic;
   signal op_hlt : std_logic;
 
   constant clock_period : time := 2 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: instr_decod PORT MAP (
          instr => instr,
          op_nop => op_nop,
          op_sta => op_sta,
          op_lda => op_lda,
          op_add => op_add,
          op_or => op_or,
          op_and => op_and,
          op_not => op_not,
          op_sub => op_sub,
          op_jmp => op_jmp,
          op_jn => op_jn,
          op_jp => op_jp,
          op_jv => op_jv,
          op_jnv => op_jnv,
          op_jz => op_jz,
          op_jnz => op_jnz,
          op_jc => op_jc,
          op_jnc => op_jnc,
          op_jb => op_jb,
          op_jnb => op_jnb,
          op_shr => op_shr,
          op_shl => op_shl,
          op_ror => op_ror,
          op_rol => op_rol,
          op_hlt => op_hlt
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period;
	  for i in 0 to 255 loop
		instr <= std_logic_vector(to_unsigned(i, 8));
		wait for clock_period;
	end loop;
      wait;
   end process;

END;
