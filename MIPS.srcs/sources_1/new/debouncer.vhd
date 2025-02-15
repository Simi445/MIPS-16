----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2023 07:22:23 PM
-- Design Name: 
-- Module Name: debouncer - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
entity debouncer is
Port 
(
signal clk:in std_logic;
signal btn:in std_logic;
signal en:out std_logic
 );
end debouncer;

architecture Behavioral of debouncer is

signal counter:std_logic_vector(15 downto 0):=(others=>'0');
signal Q1:std_logic;
signal Q2:std_logic;
signal Q3:std_logic;

begin

en<=not(Q3) and Q2;

process(clk)
begin

if clk'event and clk='1' then 
    counter<=counter+1;
    if counter="1111111111111111" then
        Q1<=btn;
    end if;
    Q2<=Q1;
    Q3<=Q2;
end if;
end process;
end Behavioral;
