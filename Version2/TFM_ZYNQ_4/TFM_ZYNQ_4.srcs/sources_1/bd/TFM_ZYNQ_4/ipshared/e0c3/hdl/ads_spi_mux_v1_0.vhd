library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity ads_spi_mux_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here                
        mx_ss              : out std_logic;
        mx_sck             : out std_logic;
        mx_miso            : in  std_logic;
        mx_mosi            : out std_logic;
        mx_dry             : in std_logic;
        
        a_ss               : in  std_logic;
        a_sck              : in  std_logic;
        a_miso             : out std_logic;
        a_mosi             : in  std_logic;
        a_dry             : out std_logic;
        
        b_ss               : in  std_logic;
        b_sck              : in  std_logic;
        b_miso             : out std_logic;
        b_mosi             : in  std_logic;
        b_dry             : out std_logic;  
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
end ads_spi_mux_v1_0;

architecture arch_imp of ads_spi_mux_v1_0 is

	-- component declaration
	component ads_spi_mux_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
        mx_rst  : out std_logic;
        mx_sel  : out std_logic;  
        
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component ads_spi_mux_v1_0_S00_AXI;
	
	signal mx_rst, mx_sel : std_logic;
	signal mx_ss_00, mx_sck_00, mx_mosi_00, mx_miso_00, mx_dry_00 : std_logic;
	
    component mux_spi is
      Port ( mx_rst : in std_logic;
             mx_sel : in std_logic;
             
             mx_ss  : out std_logic;
             mx_sck : out std_logic;
             mx_mosi : out std_logic;
             mx_miso : in std_logic;
             mx_dry     : in std_logic;
             
            a_ss    : in std_logic;
            a_sck : in std_logic;
            a_mosi : in std_logic;
            a_miso : out std_logic;
            a_dry   : out std_logic;
            
            b_ss    : in std_logic;
            b_sck : in std_logic;
            b_mosi : in std_logic;
            b_miso : out std_logic;
            b_dry   : out std_logic
            );
    end component;

begin

-- Instantiation of Axi Bus Interface S00_AXI
ads_spi_mux_v1_0_S00_AXI_inst : ads_spi_mux_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        mx_rst  => mx_rst,
        mx_sel  => mx_sel, 
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
    mux_spi_00: mux_spi port map(
         mx_rst => mx_rst,
         mx_sel => mx_sel,
                
         mx_ss  =>  mx_ss_00,
         mx_sck =>  mx_sck_00 ,
         mx_mosi =>  mx_mosi_00 ,
         mx_miso =>  mx_miso_00 ,
         mx_dry =>  mx_dry_00 ,
                           
        a_ss    => a_ss   ,
        a_sck   => a_sck   ,
        a_mosi  => a_mosi  ,
        a_miso  => a_miso  ,
        a_dry   => a_dry  ,
                           
        b_ss    => b_ss   ,
        b_sck   => b_sck   ,
        b_mosi  => b_mosi  ,
        b_miso  => b_miso  ,
        b_dry   => b_dry    
    );
    -- User logic ends
    
    MX_MISO_IBUF_inst : IBUF
    generic map (
       IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
       IOSTANDARD => "DEFAULT")
    port map (
       O => mx_miso_00,     -- Buffer output
       I => mx_miso      -- Buffer input (connect directly to top-level port)
    );
    
    MX_DRY_IBUF_inst : IBUF
    generic map (
       IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
       IOSTANDARD => "DEFAULT")
    port map (
       O => mx_dry_00,     -- Buffer output
       I => mx_dry      -- Buffer input (connect directly to top-level port)
    );
    
    MX_SS_OBUF_inst : OBUF
    generic map (
       DRIVE => 12,
       IOSTANDARD => "DEFAULT",
       SLEW => "FAST")
    port map (
       O => mx_ss,     -- Buffer output (connect directly to top-level port)
       I => mx_ss_00      -- Buffer input
    );
    
    MX_SCK_OBUF_inst : OBUF
    generic map (
       DRIVE => 12,
       IOSTANDARD => "DEFAULT",
       SLEW => "FAST")
    port map (
       O => mx_sck,     -- Buffer output (connect directly to top-level port)
       I => mx_sck_00      -- Buffer input
    );
    
    MX_MOSI_OBUF_inst : OBUF
    generic map (
       DRIVE => 12,
       IOSTANDARD => "DEFAULT",
       SLEW => "FAST")
    port map (
       O => mx_mosi,     -- Buffer output (connect directly to top-level port)
       I => mx_mosi_00      -- Buffer input
    );
 

end arch_imp;
    
