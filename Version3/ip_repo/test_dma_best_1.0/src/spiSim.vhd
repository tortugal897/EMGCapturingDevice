-------------------------------------------------------------------------------
-- Title      : Low-level processing for NILM techniques
-- Project    : 
-------------------------------------------------------------------------------
-- File       : lowlevel_proc.vhd
-- Author     :   <Alvaro@GILGAMESH>
-- Company    : 
-- Last update: 2020/01/31
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019/12/02  1.0      Alvaro  Created
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Main libraries
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- use ieee.std_logic_unsigned.all;
-- use ieee.std_logic_arith.all;

use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Main entity
-------------------------------------------------------------------------------
entity ads_spi_ctrl is
    generic( ADS_SPI_CLK_FREQ : natural :=  100000000; --system clk 100 MHz
			 ADS_SPI_SCLK_FREQ : natural := 4000000; --ADC sclk 10 MHz
			 ADS_SPI_FRAME_N: natural := 9; --STAT + 8CHs
			 ADS_SPI_BIT_N : natural := 24 --ADC bit
		);	
  port (
    mclk           : in  std_logic;
    mrst           : in  std_logic;
    maxis_tvalid   : out std_logic;
    maxis_tdata    : out std_logic_vector(31 downto 0);
    maxis_tstrb    : out std_logic_vector(3 downto 0);
    maxis_tlast    : out std_logic;
    maxis_tready   : in  std_logic--;
--    spi_ssel_o     : out std_logic;
--    spi_sck_o      : out std_logic;
--    spi_mosi_o     : out std_logic;
--    spi_miso_i     : in  std_logic;
--    spi_drdy_i     : in  std_logic
    --ext_spi_clk_i     : in  std_logic
);
end ads_spi_ctrl;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Main architecture
-------------------------------------------------------------------------------
architecture rtl of ads_spi_ctrl is

  -----------------------------------------------------------------------------
  -- SPI master controller
  -----------------------------------------------------------------------------
--    component ads_rdatac_ctrl is
--        generic ( CLK_FREQ : natural :=  100000000; --system clk 20 MHz
--               SCLK_FREQ : natural := 4000000; --ADC sclk 10 MHz
--               FRAME_N: natural := 9; --STAT + 8CHs
--               BIT_N : natural := 24 --ADC bit
--               );	
--        Port ( clk : in  std_logic;
--           rst : in  std_logic;
--           start : in std_logic;
--           ads_din : in  std_logic;
--           ads_dout : out  STD_LOGIC;
--           ads_drdy : in  std_logic;
--           ads_cs : out std_logic;
--           ads_sclk : out std_logic;
--           dout_rdy : out std_logic;
--           dout_rcv : out  std_logic_vector (23 downto 0));
--    end component;
    
      -----------------------------------------------------------------------------
  -- FIFO memory for the AXIstream interface
  -----------------------------------------------------------------------------
  component fifo64x32
    port (
      clk          : in  std_logic;
      srst         : in  std_logic;
      din          : in  std_logic_vector(31 downto 0);
      wr_en        : in  std_logic;
      rd_en        : in  std_logic;
      dout         : out std_logic_vector(31 downto 0);
      full         : out std_logic;
      almost_full  : out std_logic;
      empty        : out std_logic;
      almost_empty : out std_logic ;
      prog_full    : out std_logic
      );
  end component;
  
  component mem_pp_64 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

component RAM_module_v1 is
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
end component;

  -----------------------------------------------------------------------------
  -- AXI-Stream
  -----------------------------------------------------------------------------
  type tag_fsm is (Qidle, Qrun);
  signal frame_state                                     : tag_fsm;
  signal fifo_rd_en, fifo_wr_en, fifo_empty, fifo_aempty : std_logic;
  signal fifo_full, fifo_afull, fifo_pfull               : std_logic;
  signal fifo_din                                        : std_logic_vector(31 downto 0);
  
  signal mem_din                                        : std_logic_vector(31 downto 0);
  -- Total number of output data                                              
	constant NUMBER_OF_OUTPUT_WORDS : integer := 1017;   
	constant C_M_START_COUNT : integer := 32;
  	-- Define the states of state machine                                             
	-- The control state machine oversees the writing of input streaming data to the FIFO,
	-- and outputs the streaming data from the FIFO                                   
	type state is ( IDLE,        -- This is the initial/idle state                    
	                INIT_COUNTER,  -- This state initializes the counter, once        
	                                -- the counter reaches C_M_START_COUNT count,     
	                                -- the state machine changes state to SEND_STREAM  
	                SEND_STREAM);  -- In this state the                               
	                             -- stream data is output through M_AXIS_TDATA        
	-- State variable                                                                 
	signal  mst_exec_state : state;                                                   
	-- Example design FIFO read pointer                                               
--	signal read_pointer : integer range 0 to 64-1;                               
--	signal write_pointer : integer range 0 to 64-1;                               
    signal read_pointer_u : unsigned (9 downto 0);                               
	signal write_pointer_u : unsigned (9 downto 0); 

    signal addra_end : STD_LOGIC_VECTOR(10 DOWNTO 0);
    signal addrb_end : STD_LOGIC_VECTOR(10 DOWNTO 0);


	-- AXI Stream internal signals
	--wait counter. The master waits for the user defined number of clock cycles before initiating a transfer.
	signal count	: std_logic_vector(5-1 downto 0);
	--streaming data valid
	signal axis_tvalid	: std_logic;
	--streaming data valid delayed by one clock cycle
	signal axis_tvalid_delay	: std_logic;
	--Last of the streaming data 
	signal axis_tlast	: std_logic;
	--Last of the streaming data delayed by one clock cycle
	signal axis_tlast_delay	: std_logic;
	signal axis_tlast_delay2	: std_logic;
	--FIFO implementation signals
	signal stream_data_out	: std_logic_vector(32-1 downto 0);
	signal tx_en	: std_logic;
	--The master has issued all the streaming data stored in FIFO
	signal tx_done	: std_logic;
	--The master has issued all the streaming data stored in FIFO
	signal pp_flag_wr	: std_logic;
	--The master has issued all the streaming data stored in FIFO
	signal pp_flag_rd	: std_logic;
	signal flag_read	: std_logic;
	signal fwPointer	: std_logic;
	-- signal fwPointer2	: std_logic;
	signal read_en	: std_logic;

  -----------------------------------------------------------------------------
  -- SPI signals
  -----------------------------------------------------------------------------
  signal spi_din_req                                   : std_logic;
  signal spi_din_req_dly, spi_din_req_edge             : std_logic;
  signal spi_din_req_edge_short, spi_din_req_edge_long : std_logic;
  signal spi_message_end                               : std_logic;
  signal spi_din                                       : std_logic_vector(15 downto 0);
  signal spi_wren                                      : std_logic;
  signal spi_wr_ack                                    : std_logic;
  signal spi_dout_valid                                : std_logic;
  signal spi_dout_valid_we                                : std_logic_vector(0 downto 0);
  signal spi_dout_valid_dly, spi_dout_valid_edge       : std_logic;
  signal spi_dout                                      : std_logic_vector(23 downto 0);

--  signal cmd_cnt : integer range 0 to T_NO_CMDS*T_NO_WORDS_X_CMD-1;

  -----------------------------------------------------------------------------
  -- Time stamp signals
  -----------------------------------------------------------------------------
  signal time_stamp_cnt : std_logic_vector(31 downto 0);

    signal maxis_tvalid_s : std_logic;
    signal maxis_tlast_s : std_logic;
	signal axis_dataOut  : std_logic_vector(31 downto 0);
	
	signal AXIS_EN : std_logic;
      
      
      
begin  -- rtl

  -----------------------------------------------------------------------------
  -- SPI master controller
  -----------------------------------------------------------------------------
--  RDataC : ads_rdatac_ctrl
--    generic map ( CLK_FREQ =>  ADS_SPI_CLK_FREQ,
--            SCLK_FREQ =>  ADS_SPI_SCLK_FREQ,
--            FRAME_N =>  ADS_SPI_FRAME_N,
--            BIT_N =>  ADS_SPI_BIT_N  )	
--    port map ( 
--           clk => mclk,
--           rst => mrst,
--           start => '1',
--           ads_din => spi_miso_i,
--           ads_dout => spi_mosi_o,
--           ads_drdy => spi_drdy_i,
--           ads_cs => spi_ssel_o,
--           ads_sclk => spi_sck_o,
--           dout_rdy => spi_dout_valid,
--           dout_rcv => spi_dout
--       );
       
       
--    MEM_PINGPONG: mem_pp_64 
--      port map (
--        clka  => mclk,
--        ena   => spi_dout_valid,
--        wea   => spi_dout_valid_we,
--        addra => addra_end,
--        dina  => mem_din,
--        clkb  => mclk,
--        enb   => tx_en,
--        addrb => addrb_end ,
--        doutb => stream_data_out
--      );
      
      
      	-- BRAM memory instantation
    BRAM_MEM_inst: entity work.RAM_module_v1
    generic map(
        DATA_LEN => 32,
        ADDRESS_BIT => 11,
        ADDRESS_MAX => 2048
    )
    port map(
        ram_clk => mclk,
        ram_we => spi_dout_valid,
        ram_re => tx_en,
        -- ram_ack => read_ack_bram,
        ram_addr => addrb_end,
        ram_addw => addra_end,
        ram_din => mem_din,
        ram_dout => stream_data_out
    );
    


    -----------------------------------------------------------------------------
  -- AXI-Stream interface
  -----------------------------------------------------------------------------
  
  	-- I/O Connections assignments
	maxis_tvalid <= axis_tvalid_delay;
	maxis_tdata	 <= stream_data_out;
	maxis_tlast	 <= axis_tlast_delay;
	maxis_tstrb	 <= (others => '1');          
	
	
	-- output from slv_reg(0)
	AXIS_EN <= '1';
		-- Control state machine implementation 
	process (mclk, mrst) 
	begin
        if (mrst = '1') then 
            -- Synchronous reset (active low) 
            mst_exec_state <= IDLE;
            count <= (others => '0'); 
        elsif (rising_edge (mclk)) then 
            case (mst_exec_state) is 
                when IDLE => 
                    -- The slave starts accepting tdata when 
                    -- there tvalid is asserted to mark the 
                    -- presence of valid streaming data 
                    --if (count = "0")then 
                    -- count <= (others => '0'); 
                    if (AXIS_EN = '1') then
                        mst_exec_state <= INIT_COUNTER; 
                    else 
                        mst_exec_state <= IDLE; 
                    end if; 

                when INIT_COUNTER => 
                    -- This state is responsible to wait for user defined C_M_START_COUNT 
                    -- number of clock cycles. 
                    if (count = C_M_START_COUNT - 1) then
                        mst_exec_state <= SEND_STREAM; 
                    else 
                        count <= count + 1; 
                        mst_exec_state <= INIT_COUNTER; 
                    end if; 

                when SEND_STREAM => 
                    -- The example design streaming master functionality starts 
                    -- when the master drives output tdata from the FIFO and the slave 
                    -- has finished storing the S_AXIS_TDATA 
                    if (tx_done = '1') then 
                        mst_exec_state <= IDLE; 
                    else 
                        mst_exec_state <= SEND_STREAM; 
                    end if; 

                when others => 
                    mst_exec_state <= IDLE; 
            end case; 
        end if; 
	end process;                                                                    

	--tvalid generation
	--axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
	--number of output streaming data is less than the NUMBER_OF_OUTPUT_WORDS.
	axis_tvalid <= '1' when ((mst_exec_state = SEND_STREAM) and (read_pointer_u <= NUMBER_OF_OUTPUT_WORDS-1)) else '0';
	                                                                                               
	-- AXI tlast generation                                                                        
	-- axis_tlast is asserted number of output streaming data is NUMBER_OF_OUTPUT_WORDS-1          
	-- (0 to NUMBER_OF_OUTPUT_WORDS-1)                                                             
	axis_tlast <= '1' when (read_pointer_u = NUMBER_OF_OUTPUT_WORDS-1) else '0';                     
	                                                                                               
	-- Delay the axis_tvalid and axis_tlast signal by one clock cycle                              
	-- to match the latency of M_AXIS_TDATA                                                        
	process(mclk, mrst)                                                                            
	begin                                                                                          
	  if (rising_edge (mclk)) then                                                          
	    if(mrst = '1') then                                                              
	      axis_tvalid_delay <= '0';                                                                
	      axis_tlast_delay <= '0';                                                             
	    else                                                                                       
	      axis_tvalid_delay <= axis_tvalid;                                                        
	      axis_tlast_delay <= axis_tlast;                             
	    end if;                                                                                    
	  end if;                                                                                      
	end process;                                                                                   

    --read_pointer pointer
    process (mclk, mrst) 
        begin
            if (mrst = '1' or mst_exec_state = IDLE) then 
                read_pointer_u <= (others => '0'); 
                tx_done <= '0'; 
                -- ADD2READ <= (others => '0'); 
                -- elsif(mst_exec_state = IDLE) then 
                -- read_pointer <= (others => '0'); 
                -- tx_done <= '0'; 
                pp_flag_rd  <= '0'; 
            elsif (rising_edge (mclk)) then 
                if (mst_exec_state = SEND_STREAM) then
                    tx_done <= '0'; 
                    if (read_pointer_u <= NUMBER_OF_OUTPUT_WORDS - 1) then 
                        if (tx_en = '1') then 
                            -- read pointer is incremented after every read from the FIFO 
                            -- when FIFO read signal is enabled. 
                            read_pointer_u <= read_pointer_u + 1; 
                            tx_done <= '0'; 
                        end if;
                    end if; 

                    if (read_pointer_u = NUMBER_OF_OUTPUT_WORDS - 1) then 
                        -- tx_done is asserted when NUMBER_OF_OUTPUT_WORDS numbers of streaming data
                        -- has been out.
                        -- read_pointer <= (others => '0'); 
                        tx_done <= '1'; 
                        pp_flag_rd  <= not(pp_flag_rd);
                    end if;

                end if; 
            end if; 
        end process; 

	--FIFO read enable generation 
	tx_en <= maxis_tready and axis_tvalid;
	
	process(mclk, mrst)  
	begin
	   if mrst = '1' then
	       flag_read <= '1'; 
	   elsif rising_edge(mclk) then
	       if fwPointer = '1' then
	           flag_read <= '1';
           end if;
           if tx_done = '1' then
                flag_read <= '0';
           end if;
	   end if;
    end process;

    addra_end <= pp_flag_wr & std_logic_vector( write_pointer_u );
    addrb_end <= pp_flag_rd & std_logic_vector( read_pointer_u );
      
    spi_dout_valid_we <=  (others => spi_dout_valid);
    
    mem_din(31 downto 24) <= (others => spi_dout(23));
    mem_din(23 downto 0)  <= spi_dout;
    
    process(mclk, mrst)  -- spi_dout_valid                                                     
	begin         
	   if (rising_edge (mclk)) then 
           if(mrst = '1') then  
               write_pointer_u <= (others => '0');
               pp_flag_wr  <= '0';         
           end if;                                                                                                                                      
           if (write_pointer_u <= NUMBER_OF_OUTPUT_WORDS-1) then        
                if (fwPointer = '1') then                         
                    -- tx_done is asserted when NUMBER_OF_OUTPUT_WORDS numbers of streaming data
                    -- has been out.                                                          
                    write_pointer_u <= (others => '0');     
                    pp_flag_wr  <= not(pp_flag_wr);                                                          
                else
                    if (spi_dout_valid_edge = '1') then                                                    
                      -- read pointer is incremented after every read from the FIFO          
                      -- when FIFO read signal is enabled.                                   
                      write_pointer_u <= write_pointer_u + 1;                                                                                              
                    end if;                                                                  
                end if;                                                                  
            end if;                                                                  
        end if;                                                                  
    end process;  
	fwPointer <= '1' when write_pointer_u = NUMBER_OF_OUTPUT_WORDS-1 and spi_dout_valid_edge = '1' else '0';
    read_en <= '1' when  write_pointer_u = 0 else '0';
 
    process(spi_dout_valid, write_pointer_u)  -- spi_dout_valid                                                     
	begin 
        spi_dout_valid_edge <= '0';
        if (rising_edge(spi_dout_valid)) then
            spi_dout_valid_edge <= '1';
        end if;
	end process;  
end rtl;
