----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2020 12:10:27 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

--use UNISIM.VComponents.all;

entity SSD is
    Port(   digits : in STD_LOGIC_VECTOR(15 downto 0);
            cat : out STD_LOGIC_VECTOR(6 downto 0);
            anod : out STD_LOGIC_VECTOR(3 downto 0);
            clk : in STD_LOGIC
            );
end SSD;

architecture Behavioral of SSD is
signal hex: STD_LOGIC_VECTOR(3 downto 0);
signal counter: STD_LOGIC_VECTOR(15 downto 0);
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;
    
    process(counter(15 downto 14) )
    begin
        case counter(15 downto 14) is
            when "00" =>anod <= "1110";
                        hex <= digits(3 downto 0);        
            when "01" =>anod <= "1101";
                        hex <= digits(7 downto 4);
            when "10" =>anod <= "1011";
                        hex <= digits(11 downto 8);
            when others =>anod <= "0111";
                        hex <= digits(15 downto 12);
        end case;
    end process;
    
    
    process(hex)
    begin
    case hex is
        when "0001" => cat<= "1111001" ;  --1
        when "0010"=> cat<="0100100" ;   --2
        when "0011"=> cat<="0110000" ;  --3
        when "0100" => cat<="0011001" ;   --4
        when "0101"=> cat<="0010010" ;   --5
        when "0110"=> cat<="0000010" ;   --6
        when "0111" => cat<="1111000";   --7
        when "1000" =>cat<="0000000" ;  --8
        when "1001" =>cat<= "0010000" ;   --9
        when "1010" => cat<= "0001000" ;   --A
        when "1011"=> cat<= "0000011";   --b
        when "1100"=>cat<= "1000110" ;  --C
        when "1101" =>cat<= "0100001" ; --d
        when "1110"=> cat<="0000110" ;   --E
        when "1111"=> cat<= "0001110" ;   --F
        when others=> cat<= "1000000";  --0
        end case;
    end process;


end Behavioral;
