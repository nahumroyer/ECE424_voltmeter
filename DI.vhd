----------------------------------------------------------------------------------
-- Company: ECE424L
-- Display Interface
-- Engineer: Nahum Royer
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity DI is
  Port (
    din : in std_logic_vector (5 downto 0);
    wadd : in std_logic_vector (2 downto 0);
    clk,w : in std_logic;
    e: out std_logic_vector (7 downto 0);
    seg7: out std_logic_vector (6 downto 0);
    dp: out std_logic 
    );
end DI;

architecture DI_A of DI is

signal q : unsigned (19 downto 15):= (others => '0'); -- change 15 to 0
signal radd : unsigned (2 downto 0);
signal dout : std_logic_vector (5 downto 0);

type memory is array (0 to 7) of std_logic_vector (5 downto 0);
signal RAM: memory := (others => "000000");

type rom is array (0 to 15) of std_logic_vector (6 downto 0);
constant ss_conv: rom := ( "0000001", "1001111", "0010010", "0000110", "1001100",
		                   "0100100", "0100000", "0001111", "0000000", "0000100", 
                           "0001000", "1100000", "0110001", "1000010", "0110000",                
                           "0111000");            

begin
-- 20 bit counter
counter : process (clk) is
    begin
        if rising_edge(clk) then
        q <= q + 1;
        end if;
     end process counter;
     
-- 6 x 8bit Registers     
process (clk) is
begin
    if rising_edge(clk) then
        if W = '1'
        then RAM(to_integer(unsigned(WADD))) <= DIN;
        end if;
        RADD <= q (19 downto 17);
    end if;
end process;

Dout <= RAM(to_integer(unsigned(RADD)));

-- Decoder
process (q (19 downto 17))
begin
    case q (19 downto 17) is
            when "000" => E <= "11111110";
            when "001" => E <= "11111101";
            when "010" => E <= "11111011";
            when "011" => E <= "11110111";
            when "100" => E <= "11101111";
            when "101" => E <= "11011111";
            when "110" => E <= "10111111";
            when "111" => E <= "01111111";
            when others => E <= "11111111";

      end case;
end process;

-- Enabling Displays
process ( Dout (5 downto 0) )
begin
    case Dout (5) is
        when '0' => seg7 <= ss_conv (To_integer(unsigned(Dout (4 downto 1)))); DP <= Dout(0);
        when '1' => seg7 <= "1111111"; DP <= '1';
        when others => seg7 <= "1111111"; DP <= '1';
    end case;
end process;

end di_A;