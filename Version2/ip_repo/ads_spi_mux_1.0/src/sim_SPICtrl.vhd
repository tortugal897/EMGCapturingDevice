----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2023 10:14:22
-- Design Name: 
-- Module Name: sim_SPICtrl - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_SPICtrl is
--  Port ( );
end sim_SPICtrl;

architecture Behavioral of sim_SPICtrl is

component ads_spi_ctrl is
    generic( ADS_SPI_CLK_FREQ : natural :=  100000000; --system clk 100 MHz
			 ADS_SPI_SCLK_FREQ   : natural := 4000000; --ADC sclk 10 MHz
			 ADS_SPI_FRAME_N     : natural := 9; --STAT + 8CHs
			 ADS_SPI_BIT_N       : natural := 24 --ADC bit
		);	
      port (
        mclk           : in  std_logic;
        mrst           : in  std_logic;
        maxis_tvalid   : out std_logic;
        maxis_tdata    : out std_logic_vector(31 downto 0);
        maxis_tstrb    : out std_logic_vector(3 downto 0);
        maxis_tlast    : out std_logic;
        maxis_tready   : in  std_logic;
        spi_ssel_o     : out std_logic;
        spi_sck_o      : out std_logic;
        spi_mosi_o     : out std_logic;
        spi_miso_i     : in  std_logic := 'X';
        spi_drdy_i     : in  std_logic := 'X'
    );
    end component;

    signal mclk         : std_logic;
    signal mrst         : std_logic;
    signal maxis_tvalid : std_logic;
    signal maxis_tdata  : std_logic_vector(31 downto 0);
    signal maxis_tstrb  : std_logic_vector(3 downto 0);
    signal maxis_tlast  : std_logic;
    signal maxis_tready : std_logic;
    signal spi_ssel_o   : std_logic;
    signal spi_sck_o    : std_logic;
    signal spi_mosi_o   : std_logic;
    signal spi_miso_i   : std_logic;
    signal spi_drdy_i   : std_logic;
    
    signal data_int   : std_logic_vector(5 downto 0);
    signal data_int1   : std_logic_vector(23 downto 0);
    
    constant PERIOD    : time := 1 sec / 60_000_000;        -- Full period
    constant HIGH_TIME : time := PERIOD / 2;          -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
    
    constant PERIOD2    : time := 1 sec / 4_000_000;        -- Full period
    constant HIGH_TIME2 : time := PERIOD2 / 2;          -- High time
    constant LOW_TIME2  : time := PERIOD2 - HIGH_TIME2;  -- Low time; always >= HIGH_TIME

begin

    UUT: ads_spi_ctrl generic map(
            ADS_SPI_CLK_FREQ => 60_000_000, 
            ADS_SPI_SCLK_FREQ =>  4_000_000,
            ADS_SPI_FRAME_N   => 9 , 
            ADS_SPI_BIT_N     => 24 )
        port map(
            mclk          => mclk          , 
            mrst          => mrst          , 
            maxis_tvalid  => maxis_tvalid  , 
            maxis_tdata   => maxis_tdata   , 
            maxis_tstrb   => maxis_tstrb   , 
            maxis_tlast   => maxis_tlast   , 
            maxis_tready  => maxis_tready  , 
            spi_ssel_o    => spi_ssel_o    , 
            spi_sck_o     => spi_sck_o     , 
            spi_mosi_o    => spi_mosi_o    , 
            spi_miso_i    => spi_miso_i    , 
            spi_drdy_i    => spi_drdy_i    
        );
            
   sim_clk: process
   begin
    mclk <= '0';
    wait for LOW_TIME;
    mclk <= '1';
    wait for HIGH_TIME;
   end process;   
   
   mrst <= '0', '1' after 5 ns, '0' after 160 ns;
   
   maxis_tready <= '0', '1' after 190 ns;
            
   spi_drdy_i <= '1', '0' after 180 ns;
   
   process
   begin
    loop_in: for item in 0 to 15_000_000 loop 
            data_int1 <= std_logic_vector(to_unsigned(item, 24));
            loop_in2: for item in 0 to 23 loop 
                spi_miso_i <= data_int1(item);
                 wait for HIGH_TIME2;
            end loop;         
        end loop;         
    end process;    
    


end Behavioral;
