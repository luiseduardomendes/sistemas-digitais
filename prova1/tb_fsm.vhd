LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_fsm IS
END tb_fsm;
 
ARCHITECTURE behavior OF tb_fsm IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fsm
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         E : IN  std_logic;
         Z : OUT  std_logic_vector(1 downto 0);
		 S : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal E : std_logic := '0';

 	--Outputs
   signal Z : std_logic_vector(1 downto 0);
   signal S : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fsm PORT MAP (
          clk => clk,
          rst => rst,
          E => E,
          Z => Z,
		  S => S
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
      wait for clk_period*10;
	  rst <= '0';

      -- insert stimulus here
	  E <= '1';
	  wait for clk_period*10;
	  E <= '0';
	  wait for clk_period*10;
	  E <= '1';
	  wait for clk_period*20;
	  E <= '0';
	  wait for clk_period*10;

      wait;
   end process;

END;
