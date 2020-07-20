----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2020 12:47:36 PM
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionFetch is
    Port(   en : in STD_LOGIC;
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            JmpA: in STD_LOGIC_VECTOR(15 downto 0);
            BrnA: in STD_LOGIC_VECTOR(15 downto 0);
            PcSrc: in STD_LOGIC;
            Jmp : in STD_LOGIC;
            pc_1: out STD_LOGIC_VECTOR(15 downto 0);
            Instr: out STD_LOGIC_VECTOR(15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is
signal pc: STD_LOGIC_VECTOR (15 downto 0);
signal suma: STD_LOGIC_VECTOR(15 downto 0);
signal mux1: STD_LOGIC_VECTOR(15 downto 0);
signal mux2: STD_LOGIC_VECTOR(15 downto 0);


type ROM is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal Ins_Memory : ROM := (
B"000_000_000_001_0_000",   --0010  --add $1, $0, $0    
B"000_000_000_010_0_000",   --0020  --add $2, $0, $0
B"001_000_011_0000001",     --2181  --addi $3, $0, 1
B"001_000_100_0000001",     --2201  --addi $4, $0, 1
B"001_000_101_0000001",     --2281  --addi $5, $0, 1
B"001_000_010_0001101",     --210d  --addi $2, $0, 13
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0 
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"100_001_010_0001110",     --850E  --beq $1, $2, 14   (bucla)  , beq end
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0 
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"000_011_100_101_0_000",   --0E50  --add $5, $3, $4
B"000_000_100_011_0_000",   --0230  --add $3, $0, $4
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0 
B"000_000_101_100_0_000",   --02C0  --add $4, $0, $5
B"000_001_000_001_0_100",   --0414  --and $1, $1, $0
B"000_000_101_001_0_000",   --0290  --add $1, $0, $5
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0 
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"111_0000000001001",       --E009  --j bucla(9)
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"011_000_001_0000001",     --6081  --sw $1, 1($0)
B"010_000_111_0000001",     --4381  --lw $7, 1($0)
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0 
B"000_000_000_000_0_000",   --0000      NOOP        --add $0, $0, $0
B"000_000_111_101_0_000",   --03d0  --add $6, $0, $7
others => x"0000");
begin

    process(clk,rst)
    begin
        if rst = '1' then
            pc <= "0000000000000000";
        end if;
        
        if rising_edge(clk) then
            if en = '1' then
                pc <= mux2;
            end if;
        end if;
    end process;
    
    suma <= pc + 1;
    
    process(PcSrc)
    begin
        if PcSrc = '1' then
            mux1 <= BrnA;
        else
            mux1 <= suma;
        end if;
    end process;
    
    process(Jmp)
    begin
        if Jmp = '0' then
            mux2 <= mux1;
        else
            mux2 <= JmpA;
        end if;
    end process;
    
    Instr <= Ins_Memory( conv_integer(pc(8 downto 0)));
    pc_1 <= suma;
    
end Behavioral;