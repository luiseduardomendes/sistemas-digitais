LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_ahmes_pc IS
END tb_ahmes_pc;
 
ARCHITECTURE behavior OF tb_ahmes_pc IS 
   COMPONENT ramses_cp
      PORT(
         rst : IN  std_logic;
         ck : IN  std_logic;
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
         cg_RDM : OUT  std_logic;
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

   signal rst : std_logic := '0';
   signal ck : std_logic := '0';
   signal fl_n : std_logic := '0';
   signal fl_z : std_logic := '0';
   signal fl_c : std_logic := '0';
   signal fl_b : std_logic := '0';
   signal fl_v : std_logic := '0';
   signal instr : std_logic_vector(7 downto 0) := (others => '0');

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
 
   constant ck_period : time := 10 ns;
 
BEGIN
   uut: ramses_cp PORT MAP (
      rst => rst,
      ck => ck,
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

   ck_process :process
   begin
		ck <= '0';
		wait for ck_period/2;
		ck <= '1';
		wait for ck_period/2;
   end process;
 

   stim_proc: process
   begin
      wait for 100 ns;	
      rst <= '1';
      wait for ck_period*1;
      rst <= '0';
      wait for ck_period*1;

      fl_n <= '0';
      fl_z <= '0';
      fl_c <= '0';
      fl_b <= '0';
      fl_v <= '0';
      
      instr <= "00000000";
      wait for ck_period*8;
      instr <= "00010000";
      wait for ck_period*8;
      instr <= "00100000";
      wait for ck_period*8;
      instr <= "00110000";
      wait for ck_period*8;
      instr <= "01000000";
      wait for ck_period*8;
      instr <= "01010000";
      wait for ck_period*8;
      instr <= "01100000";
      wait for ck_period*8;
      instr <= "01110000";
      wait for ck_period*8;
      instr <= "10000000";
      wait for ck_period*8;
      instr <= "10010000";
      wait for ck_period*8;
      instr <= "10010100";
      wait for ck_period*8;
      instr <= "10011000";
      wait for ck_period*8;
      instr <= "10011100";
      wait for ck_period*8;
      instr <= "10100000";
      wait for ck_period*8;
      instr <= "10100100";
      wait for ck_period*8;
      instr <= "10110000";
      wait for ck_period*8;
      instr <= "10110100";
      wait for ck_period*8;
      instr <= "10111000";
      wait for ck_period*8;
      instr <= "10111100";
      wait for ck_period*8;
      instr <= "11100000";
      wait for ck_period*8;
      instr <= "11100001";
      wait for ck_period*8;
      instr <= "11100010";
      wait for ck_period*8;
      instr <= "11100011";
      wait for ck_period*8;
      instr <= "11110000";
      wait for ck_period*8;


      wait;
   end process;

END;
