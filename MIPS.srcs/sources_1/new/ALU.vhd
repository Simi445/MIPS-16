library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ALU is
    Port (
        A         : in  std_logic_vector(15 downto 0); --rs
        B         : in  std_logic_vector(15 downto 0); --rt
        sa        : in  std_logic;
        ALUOp     : in  std_logic_vector(1 downto 0);
        Funct     : in  std_logic_vector(2 downto 0);
        ALUResult : out std_logic_vector(15 downto 0);
        Zero      : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
    signal aluControl : std_logic_vector(2 downto 0); 
begin

    -- Control Logic Process
    control_logic: process(ALUOp, Funct)
    begin
        if ALUOp = "10" then
            aluControl <= Funct; -- For R-type instructions
        elsif ALUOp = "00" then
            aluControl <= "000"; -- addition for I-type instructions
        elsif ALUOp = "01" then
            aluControl <= "001"; -- subtraction for I-type instructions
        else
            aluControl <= "111"; -- Default or undefined operation
        end if;
    end process control_logic;


    -- Main ALU Computation Process
    alu_operation: process(A, B, aluControl, sa)
    variable tempResult : std_logic_vector(15 downto 0);
    begin
        tempResult := (others => '0');

        case aluControl is
            when "000" => tempResult := A + B;         -- ADD
            when "001" => tempResult := A - B;         -- SUB
            when "010" =>
                    if sa = '1' then
                        tempResult := B(14 downto 0) & "0"; -- Shift left
                    else 
                        tempResult:= B;
                    end if;
            when "011" =>
                    if sa = '1' then
                        tempResult:= "0" & B(15 downto 1); -- Shift right
                    else
                        tempResult:= B;
                    end if;
            when "100" => tempResult := A and B;       -- AND
            when "101" => tempResult := A or B;        -- OR
            when "111" => tempResult := A xor B;       -- XOR
            when "110" =>
                    if A < B then 
                        tempResult := "0000000000000001"; -- SLT
                    else
                        tempResult:= x"0000";
                    end if;
            when others => null;  -- NOP or handle undefined operations
        end case;

        ALUResult <= tempResult;

        if tempResult = x"0000" then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process alu_operation;

end Behavioral;
