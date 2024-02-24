----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2023 15:35:09
-- Design Name: 
-- Module Name: sim_axis_test - Behavioral
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

entity sim_axis_test is
--  Port ( );
end sim_axis_test;

architecture Behavioral of sim_axis_test is

    component test_dma_best_v1_0_S00_AXI is
	generic (
		-- Users to add parameters here
    ADS_SPI_CLK_FREQ : natural :=  100000000; --system clk 100 MHz
    ADS_SPI_SCLK_FREQ : natural := 4000000; --ADC sclk 10 MHz
     ADS_SPI_FRAME_N: natural := 9; --STAT + 8CHs
     ADS_SPI_BIT_N : natural := 24; --ADC bit
		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
    maxis_tvalid       : out std_logic;
    maxis_tdata        : out std_logic_vector(31 downto 0);
    maxis_tstrb        : out std_logic_vector(3 downto 0);
    maxis_tlast        : out std_logic;
    maxis_tready       : in  std_logic;

--    spi_ssel_o : out std_logic;
--    spi_sck_o  : out std_logic;
--    spi_mosi_o : out std_logic;
--    spi_miso_i : in  std_logic;
--    spi_drdy_i : in  std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    		-- privilege and security level of the transaction, and whether
    		-- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    		-- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    		-- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    		-- valid data. There is one write strobe bit for each eight
    		-- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    		-- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    		-- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    		-- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    		-- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    		-- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    		-- and security level of the transaction, and whether the
    		-- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    		-- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    		-- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    		-- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    		-- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    		-- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end component;

signal  maxis_tvalid : std_logic;
signal  maxis_tdata  : std_logic_vector(31 downto 0);
signal  maxis_tstrb  : std_logic_vector(3 downto 0);
signal  maxis_tlast  : std_logic;
signal  maxis_tready : std_logic;
signal  S_AXI_ACLK : std_logic;
signal  S_AXI_ARESETN : std_logic;
signal  S_AXI_AWADDR   : std_logic_vector(3 downto 0);
signal S_AXI_AWPROT	  : std_logic_vector(2 downto 0);
signal S_AXI_AWVALID  : std_logic;
signal S_AXI_AWREADY  : std_logic;
signal S_AXI_WDATA	  : std_logic_vector(32-1 downto 0);
signal S_AXI_WSTRB	  : std_logic_vector(3 downto 0);
signal S_AXI_WVALID	  : std_logic;
signal S_AXI_WREADY	  : std_logic;
signal S_AXI_BRESP	  : std_logic_vector(1 downto 0);
signal S_AXI_BVALID	  : std_logic;
signal S_AXI_BREADY	  : std_logic;
signal S_AXI_ARADDR	  : std_logic_vector(3 downto 0);
signal S_AXI_ARPROT	  : std_logic_vector(2 downto 0);
signal S_AXI_ARVALID  : std_logic;
signal S_AXI_ARREADY  : std_logic;
signal S_AXI_RDATA	  : std_logic_vector(32-1 downto 0);
signal S_AXI_RRESP	  : std_logic_vector(1 downto 0);
signal S_AXI_RVALID	  : std_logic;
signal S_AXI_RREADY	  : std_logic;

begin
    
    UUT: test_dma_best_v1_0_S00_AXI
    port map(
         maxis_tvalid =>  maxis_tvalid,
         maxis_tdata  =>  maxis_tdata ,
         maxis_tstrb  =>  maxis_tstrb ,
         maxis_tlast  =>  maxis_tlast ,
         maxis_tready  => maxis_tready, 
         S_AXI_ACLK => S_AXI_ACLK,
         S_AXI_ARESETN => S_AXI_ARESETN,
         S_AXI_AWADDR	=>   S_AXI_AWADDR     ,
        S_AXI_AWPROT	=>  S_AXI_AWPROT        ,
        S_AXI_AWVALID   =>  S_AXI_AWVALID     ,
        S_AXI_AWREADY   =>  S_AXI_AWREADY     ,
        S_AXI_WDATA	    =>  S_AXI_WDATA	     ,
        S_AXI_WSTRB	    =>  S_AXI_WSTRB	     ,
        S_AXI_WVALID	=>  S_AXI_WVALID        ,
        S_AXI_WREADY	=>  S_AXI_WREADY        ,
        S_AXI_BRESP	    =>  S_AXI_BRESP	     ,
        S_AXI_BVALID	=>  S_AXI_BVALID        ,
        S_AXI_BREADY	=>  S_AXI_BREADY        ,
        S_AXI_ARADDR	=>  S_AXI_ARADDR        ,
        S_AXI_ARPROT	=>  S_AXI_ARPROT        ,
        S_AXI_ARVALID   =>  S_AXI_ARVALID     ,
        S_AXI_ARREADY   =>  S_AXI_ARREADY     ,
        S_AXI_RDATA	    =>  S_AXI_RDATA	     ,
        S_AXI_RRESP	    =>  S_AXI_RRESP	     ,
        S_AXI_RVALID	=>  S_AXI_RVALID        ,
        S_AXI_RREADY	=>  S_AXI_RREADY
       );
       
       sim_clk: process
       begin
            S_AXI_ACLK <= '0';
            wait for 10 ns;
            S_AXI_ACLK <= '1';
            wait for 10 ns;
       end process;
       
       maxis_tready <= '0', '1' after 150 us;
       S_AXI_ARESETN <= '0', '1' after 550 ns;

end Behavioral;
