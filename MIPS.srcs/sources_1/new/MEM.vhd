library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
    port (
        clk : in std_logic;
        MemWrite : in std_logic;
        ALURes : in std_logic_vector(15 downto 0); --address
        RD2 : in std_logic_vector(15 downto 0); --di
        MemData : out std_logic_vector(15 downto 0); --do
        ALURes_out: out std_logic_vector(15 downto 0)
    );
end MEM;

architecture syn of MEM is
    type ram_type is array (0 to 65535) of std_logic_vector (15 downto 0);
    signal RAM: ram_type:= (
        3 => x"111A",  
        5 => x"1214",  
        6 => x"2223", 
        others => (others => '0') 
    );
begin
  
    MEM:process (clk)
    begin
        if clk'event and clk='1' then
            if MemWrite = '1' then
                RAM(conv_integer(ALURes)) <= RD2;
            end if;
        end if;
    end process;

    MemData <= RAM(conv_integer(ALURes));
    ALURes_out<=ALURes;
end syn;