----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2024 10:02:55
-- Design Name: 
-- Module Name: test_env - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
Port (sw: in std_logic_vector(15 downto 0);
        led: out std_logic_vector(15 downto 0);
        btn: in std_logic_vector(4 downto 0);
        clk: in std_logic;
        cat:out std_logic_vector(6 downto 0);
        an:out std_logic_vector(7 downto 0) );
end test_env;

architecture Behavioral of test_env is
signal ssd_data: std_logic_vector(15 downto 0);
signal control_signals : std_logic_vector(7 downto 0); 
signal display_signal : std_logic_vector(15 downto 0);
begin

PROCESSOR: entity Work.MIPS16BIT port map
(
    sw=>sw,
    led=>led,
    btn=>btn,
    clk=>clk,
    cat=>cat,
    an=>an
);

end Behavioral;
