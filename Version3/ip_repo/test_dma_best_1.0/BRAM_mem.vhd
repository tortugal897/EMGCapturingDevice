----------------------------------------------------------------------------------
	-- Company: 
	-- Engineer: 
	-- 
	-- Create Date: 03.05.2018 11:40:11
	-- Design Name: 
	-- Module Name: RAM_module - Behavioral
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
use IEEE.Numeric_Std.all;

entity RAM_module_v1 is
    Generic (
		DATA_LEN : integer := 32;
		ADDRESS_BIT : integer := 11;
		ADDRESS_MAX : integer := 2048
	);
    Port ( ram_clk : in STD_LOGIC;
		ram_we : in STD_LOGIC;
		ram_re : in STD_LOGIC;
		ram_addr : in STD_LOGIC_VECTOR (ADDRESS_BIT-1 downto 0);
		ram_addw : in STD_LOGIC_VECTOR (ADDRESS_BIT-1 downto 0);
		ram_din : in STD_LOGIC_VECTOR (DATA_LEN-1 downto 0);
		ram_dout : out STD_LOGIC_VECTOR (DATA_LEN-1 downto 0)
	);
end RAM_module_v1;

architecture Behavioral of RAM_module_v1 is
	
	type ram_type is array(ADDRESS_MAX-1 downto 0) of std_logic_vector(DATA_LEN-1 downto 0);
	signal ram : ram_type;
	-- signal read_address : std_logic_vector(ADDRESS_BIT-1 downto 0);
signal read_data : std_logic_vector(DATA_LEN-1 downto 0);
begin
	
	RamProc: process(ram_clk) is
		begin
		if rising_edge(ram_clk) then
			if ram_we = '1' then
				ram(to_integer(unsigned(ram_addw))) <= ram_din;
			end if;
		end if;
	end process RamProc;
	
	RamReadProc: process(ram_clk) is
		begin
		if rising_edge(ram_clk) then
			if ram_re = '1' then
				ram_dout <= ram(to_integer(unsigned(ram_addr)));
			end if;
		end if;
	end process RamReadProc;
end Behavioral;
