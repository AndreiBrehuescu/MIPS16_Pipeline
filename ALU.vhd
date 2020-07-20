----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2020 02:11:55 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
        Port(   RD1 : in STD_LOGIC_VECTOR(15 downto 0);
                RD2 : in STD_LOGIC_VECTOR(15 downto 0);
                Ext_Imm : in STD_LOGIC_VECTOR(15 downto 0);
                ALUSrc : in STD_LOGIC;
                sa : in STD_LOGIC;
                func : in STD_LOGIC_VECTOR(2 downto 0);
                ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
                ALURes : out STD_LOGIC_VECTOR(15 downto 0);
                Zero : out STD_LOGIC;
                GRZero : out STD_LOGIC;
                NotEqual : out STD_LOGIC
              );   
end ALU;

architecture Behavioral of ALU is
signal muxOut : STD_LOGIC_VECTOR(15 downto 0);
signal sum : STD_LOGIC_VECTOR(15 downto 0);
signal sub : STD_LOGIC_VECTOR(15 downto 0);
signal RshiftL : STD_LOGIC_VECTOR(15 downto 0);
signal RshiftV : STD_LOGIC_VECTOR(15 downto 0);
signal LshiftL : STD_LOGIC_VECTOR(15 downto 0);
signal LshiftV : STD_LOGIC_VECTOR(15 downto 0);
signal andOp : STD_LOGIC_VECTOR(15 downto 0);
signal orOp : STD_LOGIC_VECTOR(15 downto 0);

signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);
begin
    
    muxOut <= RD2 when ALUSrc = '0' else
              Ext_Imm when ALUSrc = '1';
              
    sum <= RD1 + muxOut;
    sub <= RD1 - muxOut;
    
    RshiftL <= "00" & RD1(15 downto 2) when sa = '1' else
               '0' & RD1(15 downto 1) when sa = '0' ;
    LshiftL <= RD1(13 downto 0) & "00" when sa = '1' else
               RD1(14 downto 0) & '0' when sa = '0' ;
               
    RshiftV <= SHR(RD1, muxOut);
    LshiftV <= SHL(RD1, muxOut);
    
    andOp <= RD1 and muxOut;
    orOp <= RD1 or muxOut;
    
    process(ALUOp)
    begin
        case ALUOp is
            when "00" => ALUCtrl <= "000";   --   +
            when "01" => ALUCtrl <= "001";   --   -
            when "11" => case (func) is -- R type
                            when "000" => ALUCtrl <= "000";  -- add
                            when "001" => ALUCtrl <= "001";  -- sub
                            when "010" => ALUCtrl <= "101";  --sll
                            when "011" => ALUCtrl <= "100";  --srl
                            when "100" => ALUCtrl <= "010";  --and
                            when "101" => ALUCtrl <= "011";  --or
                            when "110" => ALUCtrl <= "111";  --sllv
                            when "111" => ALUCtrl <= "110";  --srlv
                         end case;
            when others => ALUCtrl <= "000";
        end case;
    end process;
              
    process(ALUCtrl)
    begin
        case ALUCtrl is
            when "000" => ALURes <= sum;
            when "001" => ALURes <= sub;
            when "010" => ALURes <= andOp;
            when "011" => ALURes <= orOp;
            when "100" => ALURes <= RshiftL;
            when "101" => ALURes <= LshiftL;
            when "110" => ALURes <= RshiftV;
            when "111" => ALURes <= LshiftV;
        end case;
    end process;
    
    Zero <= '1' when sub = "0000000000000000" else '0';
    GRZero <= '1' when RD1 >= "0000000000000000" else '0';
    NotEqual <= '1' when sub /= "0000000000000000" else '0';
    
end Behavioral;
