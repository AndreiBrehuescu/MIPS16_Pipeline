----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 01:00:24 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Instruction DECODER
entity ID is
    Port (  RegWrite : in STD_LOGIC;
            Instr : in STD_LOGIC_VECTOR( 15 downto 0);
            RegDst : in STD_LOGIC;
            WD : in STD_LOGIC_VECTOR(15 downto 0);
            WA : in STD_LOGIC_VECTOR(2 downto 0);
            clk : in STD_LOGIC;
            ExtOp : in STD_LOGIC;
            RD1 : out STD_LOGIC_VECTOR(15 downto 0);
            RD2 : out STD_LOGIC_VECTOR(15 downto 0);
            Ext_Imm : out STD_LOGIC_VECTOR(15 downto 0);
            funct : out STD_LOGIC_VECTOR(2 downto 0);
            sa : out STD_LOGIC );
end ID;

architecture Behavioral of ID is
component reg_file is
    Port (  clk : in STD_LOGIC;
            ra1 : in STD_LOGIC_VECTOR(2 downto 0);
            ra2 : in STD_LOGIC_VECTOR(2 downto 0);
            wa : in STD_LOGIC_VECTOR(2 downto 0);
            wd : in STD_LOGIC_VECTOR(15 downto 0);
            rd1 : out STD_LOGIC_VECTOR(15 downto 0);
            rd2 : out STD_LOGIC_VECTOR(15 downto 0);
            wen : in STD_LOGIC
            );
end component;

signal muxRegDst : STD_LOGIC_VECTOR(2 downto 0);
begin

    C1: reg_file port map(clk, Instr(12 downto 10), Instr(9 downto 7), muxRegDst, WD, RD1, RD2, RegWrite);
    
    muxRegDst <= WA;
    
    funct <= Instr(2 downto 0);
    sa <= Instr(3);
    
    Ext_Imm <= "000000000" & Instr(6 downto 0) when ( ExtOp = '0' ) else
               "000000000" & Instr(6 downto 0) when ( ExtOp = '1' and Instr(6) = '0' ) else
               "111111111" & Instr(6 downto 0) when ( ExtOp = '1' and Instr(6) = '1' );
   

end Behavioral;
