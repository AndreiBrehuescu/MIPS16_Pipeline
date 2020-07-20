----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 09:54:42 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port (  input : in STD_LOGIC;
            clk : in STD_LOGIC;
            output : out STD_LOGIC );
end component;

component SSD is
    Port(   digits : in STD_LOGIC_VECTOR(15 downto 0);
            cat : out STD_LOGIC_VECTOR(6 downto 0);
            anod : out STD_LOGIC_VECTOR(3 downto 0);
            clk : in STD_LOGIC
            );
end component;

component InstructionFetch is
    Port(   en : in STD_LOGIC;
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            JmpA: in STD_LOGIC_VECTOR(15 downto 0);
            BrnA: in STD_LOGIC_VECTOR(15 downto 0);
            PcSrc: in STD_LOGIC;
            Jmp : in STD_LOGIC;
            pc_1: out STD_LOGIC_VECTOR(15 downto 0);
            Instr: out STD_LOGIC_VECTOR(15 downto 0));
end component;

component UC is
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
end component;

component ID is
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
end component;

component ALU is
        Port(   RD1 : in STD_LOGIC_VECTOR(15 downto 0);
                RD2 : in STD_LOGIC_VECTOR(15 downto 0);
                Ext_Imm : in STD_LOGIC_VECTOR(15 downto 0);
                ALUSrc : in STD_LOGIC;
                sa : in STD_LOGIC;
                func : STD_LOGIC_VECTOR(2 downto 0);
                ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
                ALURes : out STD_LOGIC_VECTOR(15 downto 0);
                Zero : out STD_LOGIC;
                GRZero : out STD_LOGIC;
                NotEqual : out STD_LOGIC
              );   
end component;

component RAM is
        Port(   MemWrite : in STD_LOGIC;
                ALURes : in STD_LOGIC_VECTOR(15 downto 0);
                RD2 : in STD_LOGIC_VECTOR(15 downto 0);
                clk : in STD_LOGIC;   
                MemDATA : out STD_LOGIC_VECTOR(15 downto 0);
                ALUResult : out STD_LOGIC_VECTOR(15 downto 0)
            );
end component;

-- adresele de jump si branch
signal jAdd : STD_LOGIC_VECTOR(15 downto 0) ;
signal bAdd : STD_LOGIC_VECTOR(15 downto 0) ;

--butoanele pentru pc, reset si memWrite
signal bt1_mpg : STD_LOGIC ; -- reset
signal bt2_mpg : STD_LOGIC ; -- pc
signal btn3_mpg : STD_LOGIC; -- memWrite

signal pc_next : STD_LOGIC_VECTOR(15 downto 0); -- Adresa instructiunii urmatoare
signal Instr : STD_LOGIC_VECTOR(15 downto 0); -- Instructiunea codificate in cod masina

-- Semnal intermediar, asigura scrierea in RAM doar in cazul in care
-- semalul MemWrite din UC este activat si se apasa pe btn3_mpg
signal andRegWrite : STD_LOGIC;

-- Semanlele generate de UC in functie de instructiunea in cod masina
signal RegDst : STD_LOGIC;
signal ExtOp  : STD_LOGIC;
signal ALUSrc  : STD_LOGIC;
signal Branch  : STD_LOGIC;
signal Jump : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal MemWrite  : STD_LOGIC;
signal MemtoReg  : STD_LOGIC;
signal RegWrite  : STD_LOGIC;
signal BranchGEZ : STD_LOGIC;
signal BranchNE : STD_LOGIC;

-- Semnal ce comanda adresa instructiunii
-- Cat timp este pe 0, pc <= pc + 1
-- Altfel pc <= Adresa de jump sau adresa de branch
signal PcSrc : STD_LOGIC;

--  Ce se va scrie inapoi in registru
signal WData : STD_LOGIC_VECTOR(15 downto 0);

--  Registrii cititi 
signal RD1 : STD_LOGIC_VECTOR(15 downto 0);
signal RD2 : STD_LOGIC_VECTOR(15 downto 0);

--  Imediatul extins
signal Ex_Imm : STD_LOGIC_VECTOR(15 downto 0);

--  Codul function, ultimii 3 biti din instructiune
signal fun : STD_LOGIC_VECTOR (2 downto 0);

-- Shift amount 1 -> 2 biti, 0 -> 1 bit
signal sa : STD_LOGIC;

-- Afisarea rezultatelor pe SSD
signal output : STD_LOGIC_VECTOR (15 downto 0);

--  Rezultatul ALUR
signal ALURes : STD_LOGIC_VECTOR(15 downto 0);

-- Semnalele generate de ALU pentru beq bneq bgrz
signal ZeroF : STD_LOGIC;
signal GEZF : STD_LOGIC;
signal NotEF : STD_LOGIC;

--  Semnal ce comanda scriere in RAM , actionate de UC si bt3_mpg
signal MemWriteRam : STD_LOGIC;

--  Datele citite din RAM
signal RamData : STD_LOGIC_VECTOR(15 downto 0);

-- Rezultatul ALU transmis printr-o componenta
signal finalALU : STD_LOGIC_VECTOR(15 downto 0);

--Semnal ce contine semnalele din UC si sunt afisate pe led-uri
signal forLed : STD_LOGIC_VECTOR(15 downto 0);


--Pipeline Registers
signal IF_ID_Reg : STD_LOGIC_VECTOR(31 downto 0); -- PC+1 & Instruction   

signal ID_EX_Reg : STD_LOGIC_VECTOR(82 downto 0); -- WB & M & Ex & PC+1 & RD1 & RD2 & ImmEX & rt & rd

signal EX_MEM_Reg : STD_LOGIC_VECTOR(59 downto 0); -- WB & M & BranchAddress & FlagsBranch & ALURes & RD2 & WriteAddress 

signal MEM_WB_Reg : STD_LOGIC_VECTOR(36 downto 0); -- WB & ReadDataRam & RD2 & WriteData

begin

    --  debouncer pentru 3 butoane 
    --  bt1 - reset    bt2 - counter increment 
    C1: MPG port map(btn(1),clk,bt1_mpg);
    C2: MPG port map(btn(0),clk,bt2_mpg);
    
    --  Obtinerea instructiunii din memoria rom
    C3: InstructionFetch port map ( bt2_mpg, clk, bt1_mpg, jAdd, bAdd, PcSrc, Jump, pc_next, Instr);
    
    --  Calculul adreselor de branch si jump, acestea vor fi folosite doar cand semnalele de control 
    --  pentru branch si jump vor permite acest lucru
    PcSrc <= (EX_MEM_Reg(56) and EX_MEM_Reg(37)) or (EX_MEM_Reg(55) and EX_MEM_Reg(36)) or (EX_MEM_Reg(54) and EX_MEM_Reg(35));
    jAdd <= "000" & IF_ID_Reg(12 downto 0);
    bAdd <=  EX_MEM_Reg(53 downto 38); 
    
    process(clk, bt2_mpg, pc_next, Instr)
    begin
        if rising_edge(clk) then
            if bt2_mpg = '1' then
                IF_ID_Reg(31 downto 16) <= pc_next;
                IF_ID_Reg(15 downto 0) <= Instr;
            end if;
        end if;
    end process;
    
    
    --  Generarea semnalelor de control
    C4: UC port map( IF_ID_Reg(15 downto 0), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite, BranchGEZ, BranchNE);
    
    --  Folosirea unui semnal intermediar pentru scrierea in registru doar cand se va apasa butonul pentru
    --  trecerea la instructiunea urmatoare
    andRegWrite <= MEM_WB_Reg(35) and bt2_mpg;
    
    --  Componenta responsabila pentru decodificarea instructiunii si gestionarea registrilor
    --  Efectueaza citirea si scrierea registrilor
    C5: ID port map( andRegWrite, IF_ID_Reg(15 downto 0), RegDst, WData, MEM_WB_Reg(2 downto 0), clk, ExtOp, RD1, RD2, Ex_Imm, fun, sa);
    WData <= MEM_WB_Reg(34 downto 19) when MEM_WB_Reg(36) = '1' else MEM_WB_Reg(18 downto 3);
    
    process(clk, bt2_mpg, MemToReg, RegWrite, MemWrite, Branch, BranchGEZ, BranchNE, ALUOp, ALUSrc, RegDst, IF_ID_Reg(31 downto 16), RD1, RD2, EX_Imm, fun, IF_ID_Reg(9 downto 7), IF_ID_Reg(6 downto 4))
    begin
        if rising_edge(clk) then
            if bt2_mpg = '1' then
                ID_EX_Reg(82 downto 81) <= MemToReg & RegWrite; --WB
                ID_EX_Reg(80 downto 77) <= MemWrite & Branch & BranchGEZ & BranchNE; -- M
                ID_EX_Reg(76 downto 73) <= ALUOp & ALUSrc & RegDst;
                ID_EX_Reg(72 downto 57) <= IF_ID_Reg(31 downto 16); -- PC+1
                ID_EX_Reg(56 downto 41) <= RD1;
                ID_EX_Reg(40 downto 25) <= RD2;
                ID_EX_Reg(24 downto 9) <= EX_Imm;
                ID_EX_Reg(8 downto 6) <= fun;
                ID_EX_Reg(5 downto 3) <= IF_ID_Reg(9 downto 7);     ----IF_ID_Reg(15 downto 0)(9 downto 7); -- rt
                ID_EX_Reg(2 downto 0) <= IF_ID_Reg(6 downto 4);     ----IF_ID_Reg(15 downto 0)(6 downto 4); -- rd
            end if;
        end if;
    end process;
    
    --  Unitatea de executie , primeste date din registri RD1 RD2 si in functie de ALUOp si ALUSrc
    --  transmite un anumit rezultat pe ALURes
    C7: ALU port map(ID_EX_Reg(56 downto 41), ID_EX_Reg(40 downto 25) , ID_EX_Reg(24 downto 9), ID_EX_Reg(74), ID_EX_Reg(12), ID_EX_Reg(8 downto 6), ID_EX_Reg(76 downto 75), ALURes, ZeroF, GEZF, NotEF);
    
    process(clk, bt2_mpg, ID_EX_Reg(82 downto 81), ID_EX_Reg(80 downto 77), ID_EX_Reg(72 downto 57), ID_EX_Reg(24 downto 9), ZeroF, GEZF, NotEF, ALURes, ID_EX_Reg(40 downto 25), ID_EX_Reg(5 downto 3), ID_EX_Reg(2 downto 0))
    begin
        if rising_edge(clk) then
            if bt2_mpg = '1' then
                EX_MEM_Reg(59 downto 58) <= ID_EX_Reg(82 downto 81); -- WB
                EX_MEM_Reg(57 downto 54) <= ID_EX_Reg(80 downto 77); -- M
                EX_MEM_Reg(53 downto 38) <= ID_EX_Reg(72 downto 57) + ID_EX_Reg(24 downto 9); --Branch address
                EX_MEM_Reg(37 downto 35) <= ZeroF & GEZF & NotEF;  -- Branch Flags
                EX_MEM_Reg(34 downto 19) <= ALURes;
                EX_MEM_Reg(18 downto 3) <= ID_EX_Reg(40 downto 25); --RD2
                
                if ID_EX_Reg(73) = '1' then
                    EX_MEM_Reg(2 downto 0) <= ID_EX_Reg(2 downto 0); --WriteAdrres
                    --EX_MEM_Reg(2 downto 0) <= ID_EX_Reg(5 downto 3); --WriteAdrres
                else 
                    --EX_MEM_Reg(2 downto 0) <= ID_EX_Reg(2 downto 0); --WriteAdrres
                    EX_MEM_Reg(2 downto 0) <= ID_EX_Reg(5 downto 3); --WriteAdrres
                end if;
            end if;
        end if;
    end process;
    
    --  Scrierea in memoria RAM se va face doar la actionarea butonului de scriere impreuna cu generarea semnalului
    --  de catre unitatea de control pentru scriere in RAM
    MemWriteRam <= EX_MEM_Reg(57) and bt2_mpg;
    
    C8: RAM port map( MemWriteRam, EX_MEM_Reg(34 downto 19), EX_MEM_Reg(18 downto 3), clk, RamData, finalALU);
    
    process(clk, bt2_mpg, EX_MEM_Reg(59 downto 58), RamDAta, finalALU, EX_MEM_Reg(2 downto 0))
    begin
        if rising_edge(clk) then
            if bt2_mpg = '1' then
              MEM_WB_Reg(36 downto 35) <= EX_MEM_Reg(59 downto 58); --WB
              MEM_WB_Reg(34 downto 19) <= RamDAta; 
              MEM_WB_Reg(18 downto 3) <= finalALU;
              MEM_WB_Reg(2 downto 0) <=  EX_MEM_Reg(2 downto 0);
                
            end if;
        end if;
    end process;

    forLed <=  ExtOp & ALUSrc & Branch & BranchGEZ & BranchNE & Jump & MemWrite & MemtoReg & ALUOp & MEM_WB_Reg(2 downto 0) & MEM_WB_Reg(35) & RegWrite & andRegWrite;
    led <= forLed;

    C6:SSD port map(output, cat, an, clk);
    -- IF ID EX MEM WB
    -- Mux pentru afisare pe SSD
    process( sw(7 downto 5) )
    begin 
        case sw(7 downto 5) is
            when "000" => output <= Instr;      -- Din IF
            when "001" => output <= pc_next;    --Din IF
            when "010" => output <= RD1;        --Din ID
            when "011" => output <= RamDATA;    --Din MEM
            when "100" => output <= WData;      --Din WB
            when "101" => output <= RD2;        --Din ID
            when "110" => output <= ALURes;     --Din EX
            when "111" => output <= Ex_Imm;     --Din ID
        end case;
    
    
    end process;
    
end Behavioral;
