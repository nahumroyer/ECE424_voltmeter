----------------------------------------------------------------------------------
-- Company: ECE424L Lab 2
-- Engineer: Nahum Royer
-- Voltmeter (Top Module)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vm is
    Port ( clk : in STD_LOGIC;
           -- Physical Inputs to System
           vauxp3 : in STD_LOGIC;
           vauxn3 : in STD_LOGIC;
           vauxp11 : in STD_LOGIC;
           vauxn11 : in STD_LOGIC;
           -- Physical Outputs from System (Display Interface Outputs)
           enb : out STD_LOGIC_VECTOR (7 downto 0);
           digits : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC);
end vm;

-- Begin System Description
architecture vm_a of vm is

-- Jumper Connections within System
-- Jumpers between bin2BCD Converter and Display Controller
signal dv13 : std_logic_vector(3 downto 0);
signal dv12 : std_logic_vector(3 downto 0);
signal dv11 : std_logic_vector(3 downto 0);
signal dv10 : std_logic_vector(3 downto 0);
signal dv23 : std_logic_vector(3 downto 0);
signal dv22 : std_logic_vector(3 downto 0);
signal dv21 : std_logic_vector(3 downto 0);
signal dv20 : std_logic_vector(3 downto 0);

-- ADC Controller Output to bin2BCD Converter
signal v1 : std_logic_vector(11 downto 0);
signal v2 : std_logic_vector(11 downto 0);

-- Jumpers between Display Controller and Display Interface
signal w : std_logic;
signal wadd : integer range 0 to 7 := 0;
signal din : std_logic_vector(5 downto 0);

-- State Machine for Display Controller
type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
signal disp_con_state: state_type;

-- Instantiating Display Interface
component di is 
    port (
        din : in std_logic_vector(5 downto 0);
        wadd : in std_logic_vector(2 downto 0);
        clk, w : in std_logic;
        e : out std_logic_vector(7 downto 0);
        seg7 : out std_logic_vector(6 downto 0);
        dp : out std_logic
        );
end component; 
begin
process
begin

-- Display Controller
wait until (rising_edge(clk));
case disp_con_state is
    when s0 => disp_con_state <= s1; wadd <= 7; din <= '1' & dv23 & '1';
    when s1 => disp_con_state <= s2; wadd <= wadd - 1; din <= '1' & dv22 & '1'; w <= '1';
    when s2 => disp_con_state <= s3; wadd <= wadd - 1; din <= '1' & dv21 & '1'; w <= '1';
    when s3 => disp_con_state <= s4; wadd <= wadd - 1; din <= '1' & dv20 & '1'; w <= '1';
    when s4 => disp_con_state <= s5; wadd <= wadd - 1; din <= '1' & dv13 & '1'; w <= '1';
    when s5 => disp_con_state <= s6; wadd <= wadd - 1; din <= '1' & dv12 & '1'; w <= '1';
    when s6 => disp_con_state <= s7; wadd <= wadd - 1; din <= '1' & dv11 & '1'; w <= '1';
    when s7 => disp_con_state <= s8; wadd <= wadd - 1; din <= '1' & dv10 & '1'; w <= '1';
    when s8 => disp_con_state <= s0; w <= '1';
    when others => disp_con_state <= s0;
end case;
end process;

end vm_a;
