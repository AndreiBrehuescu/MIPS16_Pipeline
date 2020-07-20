----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2020 03:32:18 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
        Port(   MemWrite : in STD_LOGIC;
                ALURes : in STD_LOGIC_VECTOR(15 downto 0);
                RD2 : in STD_LOGIC_VECTOR(15 downto 0);
                clk : in STD_LOGIC;   
                MemDATA : out STD_LOGIC_VECTOR(15 downto 0);
                ALUResult : out STD_LOGIC_VECTOR(15 downto 0)
            );
end RAM;

architecture Behavioral of RAM is

type ram_type is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM_Memory : ram_type := (
x"1",
x"2",
x"5",
x"4",
x"3",
others => x"0000" );

begin
    
    ALUResult <= ALURes;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                RAM_Memory(conv_integer(ALURes)) <= RD2;            
            end if;
        end if;
    end process;
    
    MemDATA <= RAM_Memory(conv_integer(ALURes));

end Behavioral;
