LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_ramses_po IS
END tb_ramses_po;
 
ARCHITECTURE behavior OF tb_ramses_po IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ramses_po
    PORT(
		 ac_out : OUT  std_logic_vector(7 downto 0);
		 pc_out : OUT  std_logic_vector(7 downto 0);		 
         mem_out : IN  std_logic_vector(7 downto 0);
         mem_in : OUT  std_logic_vector(7 downto 0);
         mem_end : OUT  std_logic_vector(7 downto 0);
         cg_RA : IN  std_logic;
         cg_ri : IN  std_logic;
         sel_rem : IN  std_logic;
         inc_pc : IN  std_logic;
         cg_pc : IN  std_logic;
         cg_rem : IN  std_logic;
         cg_rdm : IN  std_logic;
         cg_nz : IN  std_logic;
         cg_c : IN  std_logic;
         cg_b : IN  std_logic;
         cg_v : IN  std_logic;
         cg_read : IN  std_logic;
         n_out : OUT  std_logic;
         z_out : OUT  std_logic;
         c_out : OUT  std_logic;
         b_out : OUT  std_logic;
         v_out : OUT  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal mem_out : std_logic_vector(7 downto 0) := (others => '0');
   signal cg_RA : std_logic := '0';
   signal cg_ri : std_logic := '0';
   signal sel_rem : std_logic := '0';
   signal inc_pc : std_logic := '0';
   signal cg_pc : std_logic := '0';
   signal cg_rem : std_logic := '0';
   signal cg_rdm : std_logic := '0';
   signal cg_nz : std_logic := '0';
   signal cg_c : std_logic := '0';
   signal cg_b : std_logic := '0';
   signal cg_v : std_logic := '0';
   signal cg_read : std_logic := '0';
   signal cg_write : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal ac_out : std_logic_vector(7 downto 0) := (others => '0');
   signal pc_out : std_logic_vector(7 downto 0) := (others => '0');
   signal mem_in : std_logic_vector(7 downto 0);
   signal mem_end : std_logic_vector(7 downto 0);
   signal n_out : std_logic;
   signal z_out : std_logic;
   signal c_out : std_logic;
   signal b_out : std_logic;
   signal v_out : std_logic;
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 
 
   constant ck_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ramses_po PORT MAP (
		  ac_out => ac_out,
		  pc_out => pc_out,
          mem_out => mem_out,
          mem_in => mem_in,
          mem_end => mem_end,
          cg_RA => cg_RA,
          cg_ri => cg_ri,
          sel_rem => sel_rem,
          inc_pc => inc_pc,
          cg_pc => cg_pc,
          cg_rem => cg_rem,
          cg_rdm => cg_rdm,
          cg_nz => cg_nz,
          cg_c => cg_c,
          cg_b => cg_b,
          cg_v => cg_v,
          cg_read => cg_read,
          n_out => n_out,
          z_out => z_out,
          c_out => c_out,
          b_out => b_out,
          v_out => v_out,
          clk => clk,
          rst => rst
        );

   -- Clock process definitions
   ck_process :process
   begin
		clk <= '0';
		wait for ck_period/2;
		clk <= '1';
		wait for ck_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      Rst <= '1';
      wait for ck_period*10;     -- T0
      rst <= '0';

      sel_rem <= '0';
      cg_rem <= '1';
      
      wait for ck_period*10;     -- T1
      cg_rem <= '0';

      mem_out <= "00110101";
      cg_read <= '1';
      inc_pc <= '1';

      wait for ck_period*10;     -- T2
      cg_read <= '0';
      inc_pc <= '0';

      cg_ri <= '1';

      wait for ck_period*10;     -- T3
      cg_ri <= '0';

      sel_rem <= '0';
      cg_rem <= '1';

      wait for ck_period*10;     -- T4
      cg_rem <= '0';

      mem_out <= "00001101";
      cg_read <= '1';
      inc_pc <= '1';

      wait for ck_period*10;     -- T5
      cg_read <= '0';
      inc_pc <= '0';

      sel_rem <= '1';
      cg_rem <= '1';

      wait for ck_period*10;     -- T6
      cg_rem <= '0';

      cg_read <= '1';

      wait for ck_period*10;     -- T7
      cg_read <= '0';

      cg_RA <= '1';
      cg_NZ <= '1';
      cg_c <= '1';

      wait for ck_period*10;     -- T0
      cg_RA <= '0';
      cg_NZ <= '0';
      cg_c <= '0';

      wait;
   end process;

END;
