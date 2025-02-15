----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2024 10:40:07
-- Design Name: 
-- Module Name: IF - Behavioral
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity IF_UNIT is
Port (instruction: OUT std_logic_vector(15 downto 0);
      PC_1: out std_logic_vector(15 downto 0);
      clk: in std_logic;
      Jump: in std_logic;
      PCSrc: in std_logic;
      jump_address: in std_logic_vector(15 downto 0);
      branch_address: in std_logic_vector(15 downto 0));
end IF_UNIT;

architecture Behavioral of IF_UNIT is

signal PC: std_logic_vector(15 downto 0):=(others=>'0');
signal MUX1:std_logic_vector(15 downto 0);
signal MUX2:std_logic_vector(15 downto 0);
type MEM is array(0 to 255) of std_logic_vector(15 downto 0);
signal ROM: MEM := (
    B"001_000_001_0000010", -- addi $1, $0, 2 (initialize $1 to 2) --0
    B"001_000_100_0001010", -- addi $4, $0, 10 (initialize $4 to 10) --1
    B"100_001_100_0000100", -- beq $1, $4, 4 (if $1 == $4, jump to instruction 7) --2
    B"001_101_101_0000010", -- addi $5, $5, 2 (increment $5 by 2) --3
    B"000_011_101_011_0_000", -- add $3, $3, $5 (add $5 to $3) --4
    B"001_001_001_0000010", -- addi $1, $1, 2 (increment $1 by 2) --5
    B"111_0000000000010", -- j 2 (jump back to instruction 2) --6
    B"011_011_001_0000000", -- sw $1, 0($3) (store $1 at memory address $3) --7
    B"010_011_001_0000000", -- lw $1, 0($3) (load $1 from memory address $3) --8
    others => B"000_001_001_001_0_111" -- noop (default operation) --9
);

begin
instruction<=ROM(conv_integer(PC(7 downto 0)));
PC_1<= PC+1;
MUX1<= PC+1 when PCsrc = '0' else branch_address;
MUX2<= MUX1 when JUMP = '0' else jump_address;

COUNTING: process(clk) is
begin
    if clk'event and clk='1' then
        PC<=MUX2;
    end if;
end process;

end Behavioral;
