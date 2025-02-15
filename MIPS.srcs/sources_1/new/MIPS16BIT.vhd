----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.04.2024 18:25:37
-- Design Name: 
-- Module Name: MIPS16BIT - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 


entity MIPS16BIT is
 Port ( sw: in std_logic_vector(15 downto 0);
        led: out std_logic_vector(15 downto 0);
        btn: in std_logic_vector(4 downto 0);
        clk: in std_logic;
        cat:out std_logic_vector(6 downto 0);
        an:out std_logic_vector(7 downto 0));
end MIPS16BIT;

architecture Behavioral of MIPS16BIT is

signal clk_used: std_logic;

---------------------------------------------------- IF
signal instruction: std_logic_vector(15 downto 0);
signal PC_1: std_logic_vector(15 downto 0);
signal Jump: std_logic;
signal PCSrc: std_logic;
signal jump_address: std_logic_vector(15 downto 0);
signal branch_address: std_logic_vector(15 downto 0);
----------------------------------------------------- IF


--------------------------------------------------------DECODE UNIT
signal WD : std_logic_vector(15 downto 0);
signal RegWrite : std_logic;
signal RegDst : std_logic;
signal ExtOp : std_logic;
signal RD1 : std_logic_vector(15 downto 0);
signal RD2 : std_logic_vector(15 downto 0);
signal Ext_Imm : std_logic_vector(15 downto 0);
signal func : std_logic_vector(2 downto 0);
signal sa : std_logic;
--------------------------------------------------------DECODE UNIT


--------------------------------------------------------EX
signal ALUSrc: std_logic;
signal Zero: std_logic;
signal ALUOp: std_logic_vector(1 downto 0);
signal AluRes: std_logic_vector(15 downto 0);
--------------------------------------------------------EX


--------------------------------------------------------MEM
signal MemWrite : std_logic;
signal MemData : std_logic_vector(15 downto 0); --do
signal ALURes_out: std_logic_vector(15 downto 0);
--------------------------------------------------------MEM


--------------------------------------------------------ADDITIONAL LOGIC
signal Branch: std_logic;
signal MemToReg: std_logic;
--------------------------------------------------------ADDITIONAL LOGIC


--------------------------------------------------------FOR TESTING
signal ssd_data: std_logic_vector(15 downto 0);
signal control_signals : std_logic_vector(7 downto 0); 
signal display_signal : std_logic_vector(15 downto 0);
--------------------------------------------------------FOR TESTING

begin

IF_PORTMAP: entity Work.IF_UNIT port map
(
instruction => instruction,
PC_1 => PC_1,
clk => clk_used, -- the one from the debouncer
Jump => Jump,
PCSrc => PCSrc,
jump_address => jump_address,
branch_address => branch_address
);

DECODE_UNIT_PORTMAP: entity Work.DECODE_UNIT
port map (
    clk => clk_used,  -- the one from the debouncer         
    Instr => instruction,       
    WD => WD,             
    RegWrite => RegWrite,
    RegDst => RegDst,    
    ExtOp => ExtOp,      
    RD1 => RD1,           
    RD2 => RD2,           
    Ext_Imm => Ext_Imm,   
    func => func,         
    sa => sa              
);

EX_PORTMAP: entity Work.EX
port map (
    PC_1 => PC_1,         
    RD1 => RD1,             
    RD2 => RD2,         
    ALUSrc => ALUSrc,         
    EXT_Imm => EXT_Imm,       
    sa => sa,                
    funct => func,           
    ALUOp => ALUOp,           
    Branch_Address => branch_address, 
    Zero => Zero,             
    AluRes => AluRes          
);

MEM: entity Work.MEM
port map (
    clk => clk_used,   -- the one from the debouncer  
    MemWrite => MemWrite,   
    ALURes => ALURes, 
    RD2 => RD2,   
    MemData => MemData, 
    ALURes_out => ALURes_out 
);

control_instance: entity Work.MAIN_CONTROL
port map (
    opcode => instruction(15 downto 13),      
    RegDest => RegDst,     
    ExtOp => ExtOp,          
    AluSrc => AluSrc,         
    Branch => Branch,         
    Jump => Jump,           
    AluOp => AluOp,          
    MemWrite => MemWrite, 
    MemToReg => MemToReg, 
    RegWrite => RegWrite
);


PCSrc <= Zero and Branch;
WD <= ALURes_Out when MemToReg = '0' else MemData;
jump_address <= PC_1(15 downto 13) & instruction(12 downto 0);


------------------------------------------------------------------TESTING
with sw(7 downto 5) select
        ssd_data <=
            instruction when "000",
            PC_1 when "001",
            RD1 when "010",
            RD2 when "011",
            Ext_Imm when "100",
            ALURes when "101",
            MemData when "110",
            WD when "111",
            (others => '0') when others;
            
MPG: entity Work.debouncer port map
(
    clk=>clk,
    btn=>btn(0),
    en=>clk_used
);

SSD: entity Work.SSD port map
(
    clk=>clk,
    data=>ssd_data,
    cat=>cat,
    an=>an
);

control_signals(0) <= RegWrite; 
control_signals(1) <= MemWrite;
control_signals(2) <= Jump;
control_signals(3) <= Branch;
control_signals(4) <= ALUSrc;
control_signals(5) <= PCSrc;
control_signals(6) <= MemToReg;
control_signals(7) <= Zero; 

process(sw, ALUOp, control_signals)
begin
    if sw(0) = '0' then
        display_signal(7 downto 0) <= control_signals;
        display_signal(15 downto 8) <= (others => '0');
    else
        display_signal(1 downto 0) <= ALUOp;
        display_signal(15 downto 2) <= (others => '0');
    end if;
end process;

led <= display_signal;

end Behavioral;
