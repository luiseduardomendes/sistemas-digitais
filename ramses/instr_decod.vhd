library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_decod is
    Port ( instr : in  STD_LOGIC_VECTOR (7 downto 0);
           op_nop : out  STD_LOGIC;
           op_sta : out  STD_LOGIC;
           op_lda : out  STD_LOGIC;
           op_add : out  STD_LOGIC;
           op_or : out  STD_LOGIC;
           op_and : out  STD_LOGIC;
           op_not : out  STD_LOGIC;
           op_sub : out  STD_LOGIC;
           op_jmp : out  STD_LOGIC;
           op_jn : out  STD_LOGIC;
           op_jp : out  STD_LOGIC;
           op_jv : out  STD_LOGIC;
           op_jnv : out  STD_LOGIC;
           op_jz : out  STD_LOGIC;
           op_jnz : out  STD_LOGIC;
           op_jc : out  STD_LOGIC;
           op_jnc : out  STD_LOGIC;
           op_jb : out  STD_LOGIC;
           op_jnb : out  STD_LOGIC;
           op_shr : out  STD_LOGIC;
           op_shl : out  STD_LOGIC;
           op_ror : out  STD_LOGIC;
           op_rol : out  STD_LOGIC;
           op_hlt : out  STD_LOGIC);
end instr_decod;

architecture Behavioral of instr_decod is

begin
	process( instr )
	begin
		op_nop <= '0'; 
        op_sta <= '0';
        op_lda <= '0';
        op_add <= '0';
        op_or  <= '0';
        op_and <= '0';
        op_not <= '0';
        op_sub <= '0';
        op_jmp <= '0';
        op_shl <= '0';
        op_shr <= '0';
        op_rol <= '0';
        op_ror <= '0';
        op_hlt <= '0';
        op_jn  <= '0';
        op_jp  <= '0';
        op_jv  <= '0';
        op_jnv <= '0';
        op_jz  <= '0';
        op_jnz <= '0';
        op_jc  <= '0';
        op_jnc <= '0';
        op_jb  <= '0';
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
	end process;
end Behavioral;

