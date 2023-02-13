LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_ahmes IS
END tb_ahmes;
 
ARCHITECTURE behavior OF tb_ahmes IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ahmes
    PORT(
         RST : IN  std_logic;
         CLK : IN  std_logic;
		 
		 IR : OUT std_logic_vector(7 downto 0);
		 AMR : OUT std_logic_vector(7 downto 0);
		 DMR : OUT std_logic_vector(7 downto 0);
		 
         AC : OUT  std_logic_vector(7 downto 0);
         PC : OUT  std_logic_vector(7 downto 0);
		 ST : OUT  std_logic_vector(3 downto 0);
         N : OUT  std_logic;
         Z : OUT  std_logic;
         C : OUT  std_logic;
         B : OUT  std_logic;
         V : OUT  std_logic;
		 sel_rma : out std_logic
        ); 
    END COMPONENT; 
    

   --Inputs
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal IR: std_logic_vector(7 downto 0);
   signal AMR : std_logic_vector(7 downto 0);
   signal DMR : std_logic_vector(7 downto 0);
   signal AC : std_logic_vector(7 downto 0);
   signal PC : std_logic_vector(7 downto 0);
   signal ST : std_logic_vector(3 downto 0);
   signal N : std_logic;
   signal Z : std_logic;
   signal C : std_logic;
   signal B : std_logic;
   signal V : std_logic;
   signal sel_rma : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ahmes PORT MAP (
		  RST => RST,
          CLK => CLK,
		  AMR => AMR,
		  DMR => DMR,
		  ST => ST,
		  IR => IR,
          AC => AC,
          PC => PC,
          N => N,
          Z => Z,
          C => C,
          B => B,
          V => V,
		  sel_rma => sel_rma
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process 
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <= '1';
      wait for CLK_period;
		rst <= '0';

      wait;
   end process;

END;
