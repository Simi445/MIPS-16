library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Main_Control IS
Port( opcode: in std_logic_vector(2 downto 0);
	  RegDest: out std_logic;
      ExtOp: out std_logic;
      AluSrc: out std_logic;
      Branch: out std_logic;
      Jump: out std_logic;
      AluOp: out std_logic_vector(1 downto 0);
      MemWrite: out std_logic;
      MemToReg: out std_logic;
      RegWrite: out std_logic);
end Main_Control;

architecture Behavioral of Main_Control is


begin

CONTROL:process(opcode) is
begin
    RegDest <= '0';
    ExtOp <= '0';
    AluSrc <= '0';
    Branch <= '0';
    Jump <= '0';
    AluOp <= "00";
    MemWrite <= '0';
    MemToReg <= '0';
    RegWrite <= '0';

    case opcode is
        when "000" => -- R-type (ADD, SUB, SLL, SRL, AND, OR, SLT, XOR)
            RegDest <= '1';        -- Destination register is RD
            ExtOp <= 'X';          -- Don't care (no immediate)
            AluSrc <= '0';         -- Second operand is from a register
            Branch <= '0';         -- R-type is not a branch
            Jump <= '0';           -- R-type does not cause a jump
            AluOp <= "10";         -- ALU operation for R-type (to be decoded further by funct field)
            MemWrite <= '0';       -- No memory write
            MemToReg <= '0';       -- Data comes from ALU, not memory
            RegWrite <= '1';       -- R-type writes to register
        
        when "001" => -- ADDI
            RegDest <= '0';        -- Destination register is RT, not RD
            ExtOp <= '1';          -- Sign-extend the immediate value
            AluSrc <= '1';         -- ALU takes the second operand from the immediate field
            Branch <= '0';         -- ADDI is not a branch instruction
            Jump <= '0';           -- ADDI does not cause a jump
            AluOp <= "00";         -- ALU operation for addition (assuming '00' for ADD)
            MemWrite <= '0';       -- No memory write
            MemToReg <= '0';       -- Data comes from ALU, not memory
            RegWrite <= '1';       -- ADDI writes to a register

        when "010" => -- LW
            RegDest <= '0';        -- Destination register is RT, not RD
            ExtOp <= '1';          -- Sign-extend the offset
            AluSrc <= '1';         -- ALU takes the second operand from the immediate field (offset)
            Branch <= '0';         -- LW is not a branch instruction
            Jump <= '0';           -- LW does not cause a jump
            AluOp <= "00";         -- ALU operation for addition (offset computation)
            MemWrite <= '0';       -- No memory write for LW
            MemToReg <= '1';       -- Data to register comes from memory
            RegWrite <= '1';       -- LW writes to a register

        when "011" => -- SW
            RegDest <= 'X';        -- Don't care (no destination register)
            ExtOp <= '1';          -- Sign-extend the offset
            AluSrc <= '1';         -- ALU takes the second operand from the immediate field (offset)
            Branch <= '0';         -- SW is not a branch instruction
            Jump <= '0';           -- SW does not cause a jump
            AluOp <= "00";         -- ALU operation for addition (offset computation)
            MemWrite <= '1';       -- Memory write for SW
            MemToReg <= 'X';       -- Don't care (no data written to registers)
            RegWrite <= '0';       -- SW does not write to a register

        when "100" => -- BEQ
            RegDest <= 'X';        -- Don't care (no destination register)
            ExtOp <= '1';          -- Sign-extend the immediate value for branch offset
            AluSrc <= '0';         -- ALU takes the second operand from the register file
            Branch <= '1';         -- BEQ is a branch instruction
            Jump <= '0';           -- BEQ does not cause a jump
            AluOp <= "01";         -- ALU operation for subtraction (assuming '01' for subtraction)
            MemWrite <= '0';       -- No memory write
            MemToReg <= 'X';       -- Don't care (no data written to registers)
            RegWrite <= '0';       -- BEQ does not write to a register

         when "101" => -- BNE
            ExtOp <= '1';          -- BNE uses sign-extended offset
            AluSrc <= '0';         -- ALU second operand is from register file (to compare with Rs)
            Branch <= '1';         -- BNE is a branch instruction
            Jump <= '0';           -- BNE is not a jump
            AluOp <= "01";         -- ALU operation for branch comparison (this assumes '01' is for subtraction)
            MemWrite <= '0';       -- No memory write
            MemToReg <= 'X';       -- Don't care (no data written to registers)

        when "110" => -- LUI
            RegDest <= '0';        -- LUI writes to RT, not RD
            ExtOp <= '0';          -- LUI does not use sign-extension, immediate is shifted left
            AluSrc <= '1';         -- ALU second operand is immediate value (upper bits of it)
            Branch <= '0';         -- LUI is not a branch instruction
            Jump <= '0';           -- LUI is not a jump
            AluOp <= "00";         -- ALU operation for LUI (this assumes '00' is an operation that can handle the load-upper-immediate functionality)
            MemWrite <= '0';       -- LUI does not involve memory writing
            MemToReg <= '0';       -- For LUI, data to register does not come from memory
            RegWrite <= '1';       -- LUI writes to a register

        when "111" => -- J
            RegDest <= 'X';        -- Don't care (no destination register)
            ExtOp <= 'X';          -- Don't care (immediate value not used)
            AluSrc <= 'X';         -- Don't care (ALU not used)
            Branch <= '0';         -- J is not a branch instruction
            Jump <= '1';           -- J causes a jump
            AluOp <= "XX";         -- Don't care (ALU not used)
            MemWrite <= '0';       -- No memory write
            MemToReg <= 'X';       -- Don't care (no data written to registers)
            RegWrite <= '0';       -- J does not write to a register

        when others =>
    end case;
end process;


  
end Behavioral;