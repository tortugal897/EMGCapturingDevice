----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2023 21:57:59
-- Design Name: 
-- Module Name: mux_spi - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_spi is
  Port ( mx_rst : in std_logic;
         mx_sel : in std_logic;
         
         mx_ss : out std_logic;
         mx_sck : out std_logic;
         mx_mosi : out std_logic;
         mx_miso : in std_logic;
         mx_dry : in std_logic;
         
        a_ss : in std_logic;
        a_sck : in std_logic;
        a_mosi : in std_logic;
        a_miso : out std_logic;
        a_dry : out std_logic;
        
        b_ss : in std_logic;
        b_sck : in std_logic;
        b_mosi : in std_logic;
        b_miso : out std_logic;
        b_dry : out std_logic
        );
end mux_spi;

architecture Behavioral of mux_spi is

begin
      process (mx_rst, mx_sel, a_ss, a_sck, a_mosi, b_ss, b_sck, b_mosi)
      begin  -- process
        if ( mx_rst = '0' ) then
          mx_ss   <= '0';
          mx_sck  <= '0';
          mx_mosi <= '0';
        elsif mx_sel = '0' then
          mx_ss   <= a_ss;
          mx_sck  <= a_sck;
          mx_mosi <= a_mosi;
        else
          mx_ss   <= b_ss;
          mx_sck  <= b_sck;
          mx_mosi <= b_mosi;
        end if;
      end process;
    
--      process (mx_rst, mx_sel, mx_miso, mx_dry)
--      begin  -- process
--        if ( mx_rst = '0' ) then
--          a_miso <= '0';
--          a_dry <= '0';
--          b_miso <= '0';
--          b_dry <= '0';
--        elsif mx_sel = '0' then
--          a_miso <= mx_miso;
--          a_dry <= mx_dry;
--          b_miso <= '0';
--          b_dry <= '0';
--        else
--          a_miso <= '0';
--          a_dry <= '0';
--          b_miso <= mx_miso;
--          b_dry <= mx_dry;
--        end if;
--      end process;

      a_miso <= mx_miso;
      a_dry <= mx_dry;
      
      b_miso <= mx_miso;
      b_dry <= mx_dry;

end Behavioral;
