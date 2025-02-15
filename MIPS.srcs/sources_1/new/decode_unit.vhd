library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DECODE_UNIT IS
    Port (
        clk : in std_logic;
        Instr : in std_logic_vector(15 downto 0);
        WD : in std_logic_vector(15 downto 0);
        RegWrite : in std_logic;
        RegDst : in std_logic;
        ExtOp : in std_logic;
        RD1 : out std_logic_vector(15 downto 0);
        RD2 : out std_logic_vector(15 downto 0);
        Ext_Imm : out std_logic_vector(15 downto 0);
        func : out std_logic_vector(2 downto 0);
        sa : out std_logic
    );
end DECODE_UNIT;

architecture Behavioral of DECODE_UNIT is
    signal write_address: std_logic_vector(2 downto 0);
begin
    write_address <= Instr(9 downto 7) when RegDst = '0' else Instr(6 downto 4);
 
    process(Instr, ExtOp)
    begin
        if ExtOp = '1' then
            Ext_Imm(15 downto 7) <= (others => Instr(6));
            Ext_Imm(6 downto 0) <= Instr(6 downto 0);
        else
            Ext_Imm(15 downto 7) <= (others => '0');
            Ext_Imm(6 downto 0) <= Instr(6 downto 0);
        end if;
    end process;

    func <= Instr(2 downto 0);
    sa <= Instr(3);

    RF_PROCESS: entity WORK.reg_file port map
    (
        clk => clk,
        ra1 => Instr(12 downto 10),
        ra2 => Instr(9 downto 7),
        wa => write_address,
        wd => WD, 
        wen => RegWrite,
        rd1 => RD1,
        rd2 => RD2
    );

end Behavioral;