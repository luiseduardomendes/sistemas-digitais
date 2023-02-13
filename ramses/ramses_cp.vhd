library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ramses_cp is
    Port ( 
        rst : in  STD_LOGIC;
        clk : in  STD_LOGIC;
        fl_n : in  STD_LOGIC;
        fl_z : in  STD_LOGIC;
        fl_c : in  STD_LOGIC;
        fl_b : in  STD_LOGIC;
        fl_v : in  STD_LOGIC;
        instr : in  STD_LOGIC_VECTOR (7 downto 0);

        cg_AC : out  STD_LOGIC;
        cg_RI : out  STD_LOGIC;
        cg_PC : out  STD_LOGIC;
        cg_REM : out  STD_LOGIC;        
        cg_RDM : out  STD_LOGIC;
        cg_NZ : out  STD_LOGIC;
        cg_C : out  STD_LOGIC;
        cg_B : out  STD_LOGIC;
        cg_V : out  STD_LOGIC;
        cg_read : out  STD_LOGIC;
        cg_write : out  STD_LOGIC;
        sel_REM : out  STD_LOGIC;
        inc_PC : out  STD_LOGIC;
		
		cur_state : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ramses_cp;

architecture Behavioral of ramses_cp is

type t_state is (t0, t1, t2, t3, t4, t5, t6, t7, t_wait1, t_wait2, t_wait3, t_wait4, t_hlt);
signal state, next_state : t_state;

COMPONENT instr_decod
	PORT(
		instr : IN std_logic_vector(7 downto 0);          
		op_nop : OUT std_logic;
		op_sta : OUT std_logic;
		op_lda : OUT std_logic;
		op_add : OUT std_logic;
		op_or : OUT std_logic;
		op_and : OUT std_logic;
		op_not : OUT std_logic;
		op_sub : OUT std_logic;
		op_jmp : OUT std_logic;
		op_jn : OUT std_logic;
		op_jp : OUT std_logic;
		op_jv : OUT std_logic;
		op_jnv : OUT std_logic;
		op_jz : OUT std_logic;
		op_jnz : OUT std_logic;
		op_jc : OUT std_logic;
		op_jnc : OUT std_logic;
		op_jb : OUT std_logic;
		op_jnb : OUT std_logic;
		op_shr : OUT std_logic;
		op_shl : OUT std_logic;
		op_ror : OUT std_logic;
		op_rol : OUT std_logic;
		op_hlt : OUT std_logic
		);
	END COMPONENT;

signal operat, jmp_true, jmp_false, shifts : std_logic;
signal op_nop, op_sta, op_lda, op_add, op_or, op_and, op_not, op_sub, op_jmp, op_shl, op_shr, op_rol, op_ror, op_hlt : std_logic;
signal op_jn, op_jp, op_jv, op_jnv, op_jz, op_jnz, op_jc, op_jnc, op_jb, op_jnb : std_logic;

begin
	process( rst, clk, state )
	begin
        if rst = '1' then
            state <= t0;
        elsif clk'event and clk='1' then 
            state <= next_state;
		else
			state <= state;
        end if;
	end process;
	inst_instr_decod: instr_decod PORT MAP(
		instr  => instr,op_nop => op_nop,op_sta => op_sta,op_lda => op_lda,op_add => op_add,
		op_or  => op_or,op_and => op_and,op_not => op_not,op_sub => op_sub,op_jmp => op_jmp,
		op_jn  => op_jn,op_jp  => op_jp,op_jv  => op_jv,op_jnv => op_jnv,op_jz  => op_jz,
		op_jnz => op_jnz,op_jc  => op_jc,op_jnc => op_jnc,op_jb  => op_jb,op_jnb => op_jnb,
		op_shr => op_shr,op_shl => op_shl,op_ror => op_ror,op_rol => op_rol,op_hlt => op_hlt
	);
	shifts <= op_shl or op_shr or op_rol or op_ror;
	operat <= op_lda or op_sta or op_add or op_sub or op_and or op_or;
	jmp_true <= (
		op_jmp or
		(op_jn and fl_n) or (op_jp  and not fl_n) or
		(op_jv and fl_v) or (op_jnv and not fl_v) or
		(op_jz and fl_z) or (op_jnz and not fl_z) or
		(op_jc and fl_c) or (op_jnc and not fl_c) or
		(op_jb and fl_b) or (op_jnb and not fl_b)
	);
	jmp_false <= (
		(op_jn and not fl_n) or (op_jp  and fl_n) or
		(op_jv and not fl_v) or (op_jnv and fl_v) or
		(op_jz and not fl_z) or (op_jnz and fl_z) or
		(op_jc and not fl_c) or (op_jnc and fl_c) or
		(op_jb and not fl_b) or (op_jnb and fl_b)
	);

    identifier : process( state, instr, fl_b, fl_c, fl_v, fl_n, fl_z,
		operat, jmp_true, jmp_false, shifts,
		op_nop, op_sta, op_lda, op_add, op_or, op_and, op_not, op_sub, op_jmp, op_shl, op_shr, op_rol, op_ror, op_hlt,
		op_jn, op_jp, op_jv, op_jnv, op_jz, op_jnz, op_jc, op_jnc, op_jb, op_jnb
	)
    begin
        cg_AC 	 <= '0';
        cg_RI 	 <= '0';
        cg_PC 	 <= '0';
        cg_REM 	 <= '0';
		cg_RDM 	 <= '0';
        cg_NZ 	 <= '0';
        cg_C 	 <= '0';
        cg_B 	 <= '0';
        cg_V 	 <= '0';
        cg_read  <= '0';
        cg_write <= '0';
        sel_REM  <= '0';
        inc_PC 	 <= '0';
	
		cur_state <= "0000";
        case state is
            when t0 =>
                sel_REM <= '0';
                cg_REM <= '1';
                next_state <= t_wait1;
				cur_state <= "0000";
			when t_wait1 =>
				cg_read <= '1';
				next_state <= t1;
            when t1 =>
				cg_read <= '1';
				inc_PC <= '1';
				next_state <= t2;
				cur_state <= "0001";
            when t2 =>
                cg_RI <= '1';
                next_state <= t3;
				cur_state <= "0010";
            when t3 =>
				cur_state <= "0011";
                if operat = '1' or jmp_true = '1' then
                    sel_REM <= '0';
                    cg_REM <= '1';
                    next_state <= t_wait2;
										
                elsif shifts = '1' then
                    cg_ac <= '1';
                    cg_nz <= '1';
                    cg_c <= '1';
                    next_state <= t0;

                elsif jmp_false = '1' then
                    inc_PC <= '1';
                    next_state <= t0;

                elsif op_not = '1' then
                    cg_AC <= '1';
                    cg_NZ <= '1';
                    next_state <= t0;
                elsif op_hlt = '1' then
					next_state <= t_hlt;
				else
                    next_state <= t0;
                end if;
            when t_wait2 =>
				cg_read <= '1';
				next_state <= t4;
			when t4 =>
                cg_read <= '1';
                next_state <= t5;
				cur_state <= "0100";
                if operat = '1' then
                    inc_PC <= '1';
                end if;
            when t5 =>
                if operat = '1' then
                    sel_REM <= '1';
                    cg_REM <= '1';
                    next_state <= t_wait3;
                else
					cg_PC <= '1';
                    next_state <= t0;
                end if;
				cur_state <= "0101";
			when t_wait3 =>
				if op_sta = '0' then
					cg_read <= '1';
				end if;
				next_state <= t6;
            when t6 =>
				cur_state <= "0110";
                if op_sta = '1' then
                    cg_rdm <= '1';
				else
					cg_read <= '1';
                end if;
				
                next_state <= t_wait4;
                
			when t_wait4 =>
				next_state <= t7;
				if op_sta = '1' then
					cg_write <= '1';
				end if;
            when t7 =>
				cur_state <= "0111";
                if op_sta = '0' then
                    cg_AC <= '1';
                    cg_NZ <= '1';
                    if op_add = '1' then
                        cg_C <= '1';
                        cg_V <= '1';
                    else
                        cg_B <= '1';
                        cg_V <= '1';
                    end if;
				else
					cg_write <= '1';
                end if;
                next_state <= t0;
			when t_hlt =>
				next_state <= t_hlt;
			when others =>
				next_state <= t0;
        end case; 
    end process ; -- identifier
end Behavioral;

