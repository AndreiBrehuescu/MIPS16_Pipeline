----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2020 04:59:32 PM
-- Design Name: 
-- Module Name: reg_file - Behavioral
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


entity reg_file is
    Port (  clk : in STD_LOGIC;
            ra1 : in STD_LOGIC_VECTOR(2 downto 0);
            ra2 : in STD_LOGIC_VECTOR(2 downto 0);
            wa : in STD_LOGIC_VECTOR(2 downto 0);
            wd : in STD_LOGIC_VECTOR(15 downto 0);
            rd1 : out STD_LOGIC_VECTOR(15 downto 0);
            rd2 : out STD_LOGIC_VECTOR(15 downto 0);
            wen : in STD_LOGIC
            );
end reg_file;

architecture Behavioral of reg_file is
type reg_file is array( 0 to 7) of std_logic_vector(15 downto 0);
signal reg : reg_file ;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if wen = '1' then
                reg(conv_integer(wa)) <= wd;
            end if;
        end if;
    end process;
    
    rd1 <= reg(conv_integer(ra1));
    rd2 <= reg(conv_integer(ra2));

end Behavioral;
