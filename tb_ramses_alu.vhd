LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_ramses_alu IS
END tb_ramses_alu;
 
ARCHITECTURE behavior OF tb_ramses_alu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ramses_alu
    PORT(
         X : IN  std_logic_vector(7 downto 0);
         Y : IN  std_logic_vector(7 downto 0);
         S : OUT  std_logic_vector(7 downto 0);
         c_in : IN  std_logic;
         op_code : IN  std_logic_vector(7 downto 0);
         c_flag : OUT  std_logic;
         b_flag : OUT  std_logic;
         v_flag : OUT  std_logic;
         n_flag : OUT  std_logic;
         z_flag : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal X : std_logic_vector(7 downto 0) := (others => '0');
   signal Y : std_logic_vector(7 downto 0) := (others => '0');
   signal c_in : std_logic := '0';
   signal op_code : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(7 downto 0);
   signal c_flag : std_logic;
   signal b_flag : std_logic;
   signal v_flag : std_logic;
   signal n_flag : std_logic;
   signal z_flag : std_logic;
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 
 
   constant ck_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ramses_alu PORT MAP (
          X => X,
          Y => Y,
          S => S,
          c_in => c_in,
          op_code => op_code,
          c_flag => c_flag,
          b_flag => b_flag,
          v_flag => v_flag,
          n_flag => n_flag,
          z_flag => z_flag
        );
 
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for ck_period*10;
      for j in 0 to 1 loop
         for i in 0 to 16 loop
			
            X <= "10011010";
            Y <= "00101001";
            C_in <= std_logic(to_unsigned(j, 1)(0));
            op_code <= std_logic_vector(to_unsigned(16*i, 8));
            wait for ck_period;
         end loop;
      end loop;

      wait for ck_period*10;

      wait;
   end process;

END;
