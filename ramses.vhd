library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ramses_po is
    Port ( 
		mem_out : in  STD_LOGIC_VECTOR (7 downto 0);
		mem_in : out  STD_LOGIC_VECTOR (7 downto 0);
		mem_end : out STD_LOGIC_VECTOR (7 downto 0);

		cg_RA : in  STD_LOGIC;
		cg_ri : in  STD_LOGIC;

		sel_rem : in  STD_LOGIC;

		inc_pc : in  STD_LOGIC;

		cg_pc : in  STD_LOGIC;
		cg_rem : in  STD_LOGIC;
		cg_rdm : in  STD_LOGIC;
		cg_nz : in  STD_LOGIC;
		cg_c : in  STD_LOGIC;
		cg_b : in  STD_LOGIC;
		cg_v : in  STD_LOGIC;
		cg_read : in STD_LOGIC;
		cg_write : in STD_LOGIC;

		n_out : out  STD_LOGIC;
		z_out : out  STD_LOGIC;
		c_out : out  STD_LOGIC;
		b_out : out  STD_LOGIC;
		v_out : out  STD_LOGIC;

		ck : in STD_LOGIC;
		rst : in STD_LOGIC
	);
end ramses_po;

architecture Behavioral of ramses_po is
 -- registers
signal PC  : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal RA  : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal RI  : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal RDM : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal REM_ : STD_LOGIC_VECTOR(7 DOWNTO 0);
 -- flag registers
signal fl_n :  STD_LOGIC;
signal fl_z :  STD_LOGIC;
signal fl_c :  STD_LOGIC;
signal fl_b :  STD_LOGIC;
signal fl_v :  STD_LOGIC;

 -- ula wires
signal ula_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ula_in_x : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ula_in_y : STD_LOGIC_VECTOR(7 DOWNTO 0);
 -- ula flags
signal ula_out_c : STD_LOGIC;
signal ula_out_b : STD_LOGIC;
signal ula_out_v : STD_LOGIC;
signal ula_out_n : STD_LOGIC;
signal ula_out_z : STD_LOGIC;

begin
	process(ck, rst)
	begin

		case RI(7 downto 4) is
            when "0000" => -- NOP 
                ula_out <= ula_in_x;
            when "0001" => -- STA
                ula_out <= ula_in_x;
            when "0010" => -- LDA
                ula_out <= ula_in_y;
            when "0011" => -- ADD
                ula_out <= std_logic_vector(signed(ula_in_x) + signed(ula_in_y));
				ula_out_v <= (ula_in_x(7) and ula_in_y(7) and not(ula_out(7))) or (not(ula_in_x(7)) and not(ula_in_y(7)) and ula_out(7));
            when "0100" => -- OR
                ula_out <= ula_in_x or ula_in_y;
            when "0101" => -- AND
                ula_out <= ula_in_x and ula_in_y;
            when "0110" => -- NOT
                ula_out <= not ula_in_x;
            when "0111" => -- SUB
                ula_out <= std_logic_vector(signed(ula_in_x) - signed(ula_in_y));
				ula_out_v <= (ula_in_x(7) and not(ula_in_y(7)) and not(ula_out(7))) or (not(ula_in_x(7)) and ula_in_y(7) and ula_out(7));
            when "1101" => -- NEG
                ula_out <= std_logic_vector( - signed(ula_in_x));
            when "1110" => -- SHL
                ula_out(0) <= ula_out(1);
				ula_out(1) <= ula_out(2);
				ula_out(2) <= ula_out(3);
				ula_out(3) <= ula_out(4);
				ula_out(4) <= ula_out(5);
				ula_out(5) <= ula_out(6);
				ula_out(6) <= ula_out(7);
				ula_out(7) <= '0';
                ula_out_z <= ula_in_x(0);
            when others =>
                ula_out <= ula_in_x;
        end case;
		ula_out_n <= ula_out(7);
		ula_out_z <= not(ula_out(7) or ula_out(6) or ula_out(5) or ula_out(4) or ula_out(3) or ula_out(2) or ula_out(1) or ula_out(0));

		n_out <= fl_n;
		z_out <= fl_z;
		c_out <= fl_c;
		v_out <= fl_v;
		b_out <= fl_b;

		if rst = '1' then
			RA <= (others => 0);
			RI <= (others => 0);
			RDM <= (others => 0);
			REM_ <= (others => 0);
			
		elsif ck'event and ck = '1' then
			ula_in_x <= RA;
			ula_in_y <= rdm;
		
			if cg_ra then
				RA <= ula_out;
			end if;
			
			if cg_ri then
				RI <= RDM;
			end if;
			
			if cg_pc then
				PC <= RDM;
			end if;
			
			if inc_pc then
				PC <= std_logic_vector(unsigned(PC) + 1);
			end if;
			
			if cg_rem then
				if sel_rem = '1' then
					REM_ <= PC;
				else
					REM_ <= RDM;
				end if;
			end if;

			if cg_rdm then
				rdm <= RA;
      		end if;
			
			if cg_nz then
				fl_n <= ula_out_n;
				fl_z <= ula_out_z;
			end if;
			
			if cg_c then
				fl_c <= ula_out_c;
			end if;
			
			if cg_b then
				fl_b <= ula_out_b;
			end if;
			
			if cg_v then
				fl_v <= ula_out_v;
			end if;
			
			if cg_read then 
				rdm <= mem_out;
				mem_end <= rem_;
			end if;
			
			if cg_write then 
				mem_in <= rdm;
				mem_end <= rem_;
			end if;
		end if;
	end process;


end Behavioral;

