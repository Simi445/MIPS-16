----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2024 10:22:32
-- Design Name: 
-- Module Name: EU - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity EX is
Port (PC_1: in std_logic_vector(15 downto 0);
      RD1:in std_logic_vector(15 downto 0);
      RD2:in std_logic_vector(15 downto 0);
      ALUSrc: in std_logic;
      EXT_Imm:in std_logic_vector(15 downto 0);
      sa: in std_logic;
      funct: in std_logic_vector(2 downto 0);
      ALUOp: in std_logic_vector(1 downto 0);
      Branch_Address:out std_logic_vector(15 downto 0);
      Zero: out std_logic;
      AluRes: out std_logic_vector(15 downto 0) );
end EX;

architecture Behavioral of EX is
signal OP2: std_logic_vector(15 downto 0);
begin

OP2<= EXT_Imm when ALUSrc = '1' else RD2;
Branch_Address<= PC_1 + EXT_Imm;


ALU_PM: entity Work.ALU port map
(
A=>RD1,
B=>OP2,
sa=>sa,
ALUOp=>ALUOp,
Funct=>funct,
ALUResult=>ALURes,
Zero=>Zero
);

end Behavioral;
