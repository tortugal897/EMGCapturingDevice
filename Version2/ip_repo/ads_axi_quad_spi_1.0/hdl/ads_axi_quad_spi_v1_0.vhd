library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity ads_axi_quad_spi_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 7
	);
	port (
		-- Users to add ports here
        
        ext_spi_clk         : in STD_LOGIC;
        quad_spi_intc       : out STD_LOGIC;
        
        ads_drdy_i  : in STD_LOGIC;
        ads_drdy_o  : out STD_LOGIC;
        ads_miso    : in STD_LOGIC;
        ads_mosi    : out STD_LOGIC;
        ads_sck     : out STD_LOGIC;
        ads_ss      : out STD_LOGIC_VECTOR ( 0 to 0 );
        
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end ads_axi_quad_spi_v1_0;

architecture arch_imp of ads_axi_quad_spi_v1_0 is

	-- component declaration
    component axi_quad_spi_0 is
      port (
        ext_spi_clk : IN STD_LOGIC;
        s_axi_aclk : IN STD_LOGIC;
        s_axi_aresetn : IN STD_LOGIC;
        s_axi_awaddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        s_axi_awvalid : IN STD_LOGIC;
        s_axi_awready : OUT STD_LOGIC;
        s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_wvalid : IN STD_LOGIC;
        s_axi_wready : OUT STD_LOGIC;
        s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bvalid : OUT STD_LOGIC;
        s_axi_bready : IN STD_LOGIC;
        s_axi_araddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        s_axi_arvalid : IN STD_LOGIC;
        s_axi_arready : OUT STD_LOGIC;
        s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rvalid : OUT STD_LOGIC;
        s_axi_rready : IN STD_LOGIC;
        -- io0_i : IN STD_LOGIC;
        io0_o : OUT STD_LOGIC;
        -- io0_t : OUT STD_LOGIC;
        io1_i : IN STD_LOGIC;
        -- io1_o : OUT STD_LOGIC;
        -- io1_t : OUT STD_LOGIC;
        -- sck_i : IN STD_LOGIC;
        sck_o : OUT STD_LOGIC;
        -- sck_t : OUT STD_LOGIC;
        -- ss_i : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        ss_o : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        -- ss_t : OUT STD_LOGIC;
        ip2intc_irpt : OUT STD_LOGIC
      );
  end component axi_quad_spi_0;
  
  signal ads_mosi_00, ads_miso_00, ads_sck_00 : std_logic;
  signal ads_ss_00 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ads_drdy_i_00, ads_drdy_o_00 : std_logic;
begin

    axi_quad_spi_00: axi_quad_spi_0 port map(
        io0_o    => ads_mosi_00  ,
        io1_i    => ads_miso_00  ,
        sck_o     => ads_sck_00   ,
        ss_o      => ads_ss_00    ,
        
        s_axi_araddr       => s00_axi_araddr  ,
        s_axi_arready      => s00_axi_arready ,
        s_axi_arvalid      => s00_axi_arvalid ,
        s_axi_awaddr       => s00_axi_awaddr  ,
        s_axi_awready      => s00_axi_awready ,
        s_axi_awvalid      => s00_axi_awvalid ,
        s_axi_bready       => s00_axi_bready  ,
        s_axi_bresp        => s00_axi_bresp   ,
        s_axi_bvalid       => s00_axi_bvalid  ,
        s_axi_rdata        => s00_axi_rdata   ,
        s_axi_rready       => s00_axi_rready  ,
        s_axi_rresp        => s00_axi_rresp   ,
        s_axi_rvalid       => s00_axi_rvalid  ,
        s_axi_wdata        => s00_axi_wdata   ,
        s_axi_wready       => s00_axi_wready  ,
        s_axi_wstrb        => s00_axi_wstrb   ,
        s_axi_wvalid       => s00_axi_wvalid  ,
        ext_spi_clk           => ext_spi_clk      ,
        ip2intc_irpt         => quad_spi_intc    ,
        s_axi_aclk            => s00_axi_aclk       ,
        s_axi_aresetn         => s00_axi_aresetn    
    );

	-- Add user logic here
    ads_drdy_o_00 <= not( ads_drdy_i_00 );
    
    MOSI_OBUF_inst : OBUF
    generic map (
       DRIVE => 12,
       IOSTANDARD => "DEFAULT",
       SLEW => "FAST")
    port map (
       O => ads_mosi,     -- Buffer output (connect directly to top-level port)
       I => ads_mosi_00      -- Buffer input
    );
    
    MISO_IBUF_inst : IBUF
    generic map (
       IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
       IOSTANDARD => "DEFAULT")
    port map (
       O => ads_miso_00,     -- Buffer output
       I => ads_miso      -- Buffer input (connect directly to top-level port)
    );
    
    SCK_OBUF_inst : OBUF
    generic map (
       DRIVE => 12,
       IOSTANDARD => "DEFAULT",
       SLEW => "FAST")
    port map (
       O => ads_sck,     -- Buffer output (connect directly to top-level port)
       I => ads_sck_00      -- Buffer input
    );
    
    SS_OBUF_inst : OBUF
    generic map (
       DRIVE => 12,
       IOSTANDARD => "DEFAULT",
       SLEW => "FAST")
    port map (
       O => ads_ss(0),     -- Buffer output (connect directly to top-level port)
       I => ads_ss_00(0)      -- Buffer input
    );
    
    DRDY_IIBUF_inst : IBUF
    generic map (
       IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
       IOSTANDARD => "DEFAULT")
    port map (
       O => ads_drdy_i_00,     -- Buffer output
       I => ads_drdy_i      -- Buffer input (connect directly to top-level port)
    );
    
    DRDY_o_OBUF_inst : OBUF
    generic map (
       DRIVE => 12,
       IOSTANDARD => "DEFAULT",
       SLEW => "FAST")
    port map (
       O => ads_drdy_o,     -- Buffer output (connect directly to top-level port)
       I => ads_drdy_o_00      -- Buffer input
    );
	-- User logic ends

end arch_imp;
