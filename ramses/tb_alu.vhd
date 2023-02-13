LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_alu IS
END tb_alu;
 
ARCHITECTURE behavior OF tb_alu IS 
 
   -- Component Declaration for the Unit Under Test (UUT)

   COMPONENT ula_ahmes
   PORT(
      ula_in_x : IN  std_logic_vector(7 downto 0);
      ula_in_y : IN  std_logic_vector(7 downto 0);
      ula_in_c : IN  std_logic;
      ula_inst : IN  std_logic_vector(7 downto 0);
      ula_out : OUT  std_logic_vector(7 downto 0);
      ula_out_c : OUT  std_logic;
      ula_out_b : OUT  std_logic;
      ula_out_v : OUT  std_logic;
      ula_out_n : OUT  std_logic;
      ula_out_z : OUT  std_logic
   );
   END COMPONENT;
   

   --Inputs
   signal ula_in_x : std_logic_vector(7 downto 0) := (others => '0');
   signal ula_in_y : std_logic_vector(7 downto 0) := (others => '0');
   signal ula_in_c : std_logic := '0';
   signal ula_inst : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal ula_out : std_logic_vector(7 downto 0);
   signal ula_out_c : std_logic;
   signal ula_out_b : std_logic;
   signal ula_out_v : std_logic;
   signal ula_out_n : std_logic;
   signal ula_out_z : std_logic;
   
   -- ULA_Operations
	type ndarray is array (0 to 12) of std_logic_vector (7 downto 0);
	constant operations : ndarray := (
      "00000000", 
      "00010000", 
      "00100000", 
      "00110000", 
      "01000000", 
      "01010000", 
      "01100000", 
      "01110000", 
      "10000000", 
      "11100000", 
      "11100001", 
      "11100010", 
      "11100011"
   );
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ula_ahmes PORT MAP (
      ula_in_x => ula_in_x,
      ula_in_y => ula_in_y,
      ula_in_c => ula_in_c,
      ula_inst => ula_inst,
      ula_out => ula_out,
      ula_out_c => ula_out_c,
      ula_out_b => ula_out_b,
      ula_out_v => ula_out_v,
      ula_out_n => ula_out_n,
      ula_out_z => ula_out_z
   ); 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      ula_in_x <= "00101110";
	   ula_in_y <= "10000111";

		for i in operations'range loop
		   ula_inst <= operations(i);
         wait for clk_period;
      end loop;

      wait;
   end process;

END;
