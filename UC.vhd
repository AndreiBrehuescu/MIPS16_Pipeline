----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 02:05:17 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port (  Instr : in STD_LOGIC_VECTOR(15 downto 0) ;
            RegDst : out STD_LOGIC;
            ExtOp : out STD_LOGIC;
            ALUSrc : out STD_LOGIC;
            Branch : out STD_LOGIC;
            Jump : out STD_LOGIC;
            ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
            MemWrite : out STD_LOGIC;
            MemtoReg : out STD_LOGIC;
            RegWrite : out STD_LOGIC;
            BranchGEZ : out STD_LOGIC;
            BranchNE : out STD_LOGIC  );
end UC;

architecture Behavioral of UC is

begin

    process( Instr(15 downto 13) )
    begin
        RegDst <= '0';
        ExtOp <= '0';
        ALUsrc <= '0';
        Branch <= '0';
        Jump <= '0';
        ALUop <= "00";
        MemWrite <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        BranchGEZ <= '0';
        BranchNE <= '0';
        -- ALUOP  111 -tip R   00(+) 001(-)
        case Instr(15 downto 13) is
            when "000" => RegWrite <= '1'; RegDst <= '1'; ALUop <= "11";    --Instructiuni de tip R
            when "001" => RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; ALUop <= "00";  --addi
            when "010" => RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; MemtoReg <='1'; ALUop <= "00";   --lw
            when "011" => ALUSrc <= '1'; ExtOp <= '1'; MemWrite <='1'; ALUop <= "00";  --sw
            when "100" => ExtOp <= '1'; Branch <= '1'; ALUop <= "01";          --beq 
            when "101" => ExtOp <= '1'; BranchNE <= '1'; ALUop <= "01";          --bne
            when "110" => ExtOp <= '1'; BranchGEZ <= '1'; ALUop <= "01";          --bgez
            when "111" => Jump <= '1';    --jump
            
            
        end case;
    end process;

end Behavioral;
