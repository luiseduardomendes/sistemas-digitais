LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_ahmes_pc IS
END tb_ahmes_pc;
 
ARCHITECTURE behavior OF tb_ahmes_pc IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ramses_cp
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         fl_n : IN  std_logic;
         fl_z : IN  std_logic;
         fl_c : IN  std_logic;
         fl_b : IN  std_logic;
         fl_v : IN  std_logic;
         instr : IN  std_logic_vector(7 downto 0);
         cg_AC : OUT  std_logic;
         cg_RI : OUT  std_logic;
         cg_PC : OUT  std_logic;
         cg_REM : OUT  std_logic;
         cg_NZ : OUT  std_logic;
         cg_C : OUT  std_logic;
         cg_B : OUT  std_logic;
         cg_V : OUT  std_logic;
         cg_read : OUT  std_logic;
         cg_write : OUT  std_logic;
         sel_REM : OUT  std_logic;
         inc_PC : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal fl_n : std_logic := '0';
   signal fl_z : std_logic := '0';
   signal fl_c : std_logic := '0';
   signal fl_b : std_logic := '0';
   signal fl_v : std_logic := '0';
   signal instr : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal cg_AC : std_logic;
   signal cg_RI : std_logic;
   signal cg_PC : std_logic;
   signal cg_REM : std_logic;
   signal cg_NZ : std_logic;
   signal cg_C : std_logic;
   signal cg_B : std_logic;
   signal cg_V : std_logic;
   signal cg_read : std_logic;
   signal cg_write : std_logic;
   signal sel_REM : std_logic;
   signal inc_PC : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
   -- Operations
   type ndarray is array (0 to 23) of std_logic_vector (7 downto 0);
   constant operations : ndarray := (
      "00000000", -- nop 
      "00010000", -- sta
	  "00100000", -- lda
	  
      "00110000", -- add
      "01000000", -- or
      "01010000", -- and
      "01100000", -- not
      "01110000", -- sub
	  
      "10000000", -- jmp
	  
	  "10010000", -- jn
	  "10010100", -- jp
	  "10011000", -- jv
	  "10011100", -- jnv
	  
	  "10100000", -- jz
	  "10100100", -- jnz
	  
	  "10110000", -- jc
	  "10110100", -- jnc
	  "10111000", -- jb
	  "10111100", -- jnb
	  
      "11100000", -- shr
      "11100001", -- shl
      "11100010", -- ror
      "11100011", -- rol
	  
	  "11110000"  -- hlt
   );
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ramses_cp PORT MAP (
          rst => rst,
          clk => clk,
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
          cg_NZ => cg_NZ,
          cg_C => cg_C,
          cg_B => cg_B,
          cg_V => cg_V,
          cg_read => cg_read,
          cg_write => cg_write,
          sel_REM => sel_REM,
          inc_PC => inc_PC
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
	  rst <= '1';
	  
	  fl_n <= '0';	   
	  fl_z <= '0';	   
	  fl_c <= '0';
	  fl_b <= '0';
	  fl_v <= '0';
	  wait for clk_period;
	  rst <= '0';
	  
      -- insert stimulus here 
	  for i in operations'range loop
		 instr <= operations(i);
         wait for clk_period*8;
	  end loop;

      wait;
   end process;

END;
