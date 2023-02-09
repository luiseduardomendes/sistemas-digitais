library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ramses_cp is
    Port ( 
        rst : in  STD_LOGIC;
        ck : in  STD_LOGIC;
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
        inc_PC : out  STD_LOGIC
    );
end ramses_cp;

architecture Behavioral of ramses_cp is
type t_state is (t0, t1, t2, t3, t4, t5, t6, t7);
signal state, next_state : t_state;

signal operat, jmp_true, jmp_false, shifts : std_logic;
signal op_nop, op_sta, op_lda, op_add, op_or, op_and, op_not, op_sub, op_jmp, op_shl, op_shr, op_rol, op_ror, op_hlt : std_logic;
signal op_jn, op_jp, op_jv, op_jnv, op_jz, op_jnz, op_jc, op_jnc, op_jb, op_jnb : std_logic;

begin
	process( rst, ck )
	begin
        if rst = '1' then
            state <= t0;
        elsif ck'event and ck='1' then 
            state <= next_state;
		else
			state <= state;
        end if;
	end process;

    identifier : process( state, instr, fl_b, fl_c, fl_v, fl_n, fl_z )
    begin
        op_nop <= '0'; 
        op_sta <= '0';
        op_lda <= '0';
        op_add <= '0';
        op_or <= '0';
        op_and <= '0';
        op_not <= '0';
        op_sub <= '0';
        op_jmp <= '0';
        op_shl <= '0';
        op_shr <= '0';
        op_rol <= '0';
        op_ror <= '0';
        op_hlt <= '0';
        op_jn <= '0';
        op_jp <= '0';
        op_jv <= '0';
        op_jnv <= '0';
        op_jz <= '0';
        op_jnz <= '0';
        op_jc <= '0';
        op_jnc <= '0';
        op_jb <= '0';
        op_jnb <= '0';
        case instr(7 downto 4) is
            when "0000" =>
                op_nop <= '1';
            when "0001" =>
                op_sta <= '1';
            when "0010" =>
                op_lda <= '1';
            when "0011" =>
                op_add <= '1';
            when "0100" =>
                op_or <= '1';
            when "0101" =>
                op_and <= '1';
            when "0110" =>
                op_not <= '1';
            when "0111" =>
                op_sub <= '1';
            when "1000" =>
                op_jmp <= '1';
            when "1001" =>
                case instr(3 downto 2) is
                    when "00" =>
                        op_jn <= '1'; 
                    when "01" =>
                        op_jp <= '1';
                    when "10" =>
                        op_jv <= '1';
                    when others =>
                        op_jnv <= '1';
                end case;
            when "1010" =>
                case instr(2) is
                    when '0' =>
                        op_jz <= '1';
                    when others =>
                        op_jnz <= '1';
                end case;
            when "1011" =>
                case instr(3 downto 2) is
                    when "00" =>
                        op_jc <= '1'; 
                    when "01" =>
                        op_jnc <= '1';
                    when "10" =>
                        op_jb <= '1';
                    when others =>
                        op_jnb <= '1';
                end case;
            
            when "1110" =>
                case instr(1 downto 0) is
                    when "00" =>
                        op_shr <= '1'; 
                    when "01" =>
                        op_shl <= '1';
                    when "10" =>
                        op_ror <= '1';
                    when others =>
                        op_rol <= '1';
                end case;
            when others =>
                op_hlt <= '1';
        end case;

        shifts <= op_shl or op_shr or op_rol or op_ror;
        operat <= op_lda or op_add or op_sub or op_and or op_or or shifts;
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

		cg_AC <= '0';
        cg_RI <= '0';
        cg_PC <= '0';
        cg_REM <= '0';
        cg_RDM <= '0';
        cg_NZ <= '0';
        cg_C <= '0';
        cg_B <= '0';
        cg_V <= '0';
        cg_read <= '0';
        cg_write <= '0';
        sel_REM <= '0';
        inc_PC <= '0';

        case state is
            when t0 =>
                sel_REM <= '0';
                cg_REM <= '1';
                next_state <= t1;
            when t1 =>
                cg_read <= '1';
                inc_PC <= '1';
                next_state <= t2;
            when t2 =>
                cg_RI <= '1';
                next_state <= t3;
            when t3 =>
                if operat = '1' or jmp_true = '1' then
                    sel_REM <= '0';
                    cg_REM <= '1';
                    next_state <= t4;
                elsif jmp_false = '1' then
                    inc_PC <= '1';
                    next_state <= t0;
                elsif op_not = '1' then
                    cg_AC <= '1';
                    cg_NZ <= '1';
                    next_state <= t0;
                elsif op_nop = '1' then
                    next_state <= t0;
                elsif op_hlt = '1' then
                    next_state <= t0;
                else
                    next_state <= t0;
                end if;
            when t4 =>
                if operat = '1' then
                    cg_read <= '1';
                    inc_PC <= '1';
                    next_state <= t4;
                elsif jmp_true = '1' then
                    cg_read <= '1';
                    next_state <= t4;
                else
                    next_state <= t0;
                end if;
            when t5 =>
                if operat = '1' then
                    sel_REM <= '0';
                    cg_REM <= '1';
                    next_state <= t5;
                elsif jmp_true = '1' then
                    sel_REM <= '1';
					cg_PC <= '1';
                    next_state <= t0;
                else
                    next_state <= t0;
                end if;
            when t6 =>
                if operat = '1' then
                    if op_sta = '1' then
                        cg_RDM <= '1';
                    else
                        cg_read <= '1';
                    end if;
                    next_state <= t7;
                else
                    next_state <= t0;
                end if;
            when t7 =>
                if operat = '1' then
                    if op_sta = '1' then
                        cg_write <= '1';
                    else
                        cg_AC <= '1';
                        cg_NZ <= '1';
                        if op_add = '1' then
                            cg_C <= '1';
                            cg_V <= '1';
                        elsif op_sub = '1' then
                            cg_B <= '1';
                            cg_V <= '1';
                        elsif shifts = '1' then
                            cg_C <= '1';
                        end if;
                    end if;
                end if;
                next_state <= t0;
			when others =>
				next_state <= t0;
        end case;
    end process ; -- identifier
end Behavioral;

