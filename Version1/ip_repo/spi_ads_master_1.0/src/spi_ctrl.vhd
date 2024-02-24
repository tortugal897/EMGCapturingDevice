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

use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Main entity
-------------------------------------------------------------------------------
entity spi_ctrl is
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
end spi_ctrl;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Main architecture
-------------------------------------------------------------------------------
architecture rtl of spi_ctrl is

  -----------------------------------------------------------------------------
  -- SPI master controller
  -----------------------------------------------------------------------------
    component rdatac_ctrl is
        generic ( CLK_FREQ : natural :=  60000000; --system clk 60 MHz
               SCLK_FREQ : natural := 4000000; --ADC sclk 4 MHz
               FRAME_N: natural := 9; --STAT + 8CHs
               BIT_N : natural := 24 --ADC bit
               );	
        Port ( clk : in  std_logic;
           rst : in  std_logic;
           start : in std_logic;
           ads_din : in  std_logic;
           ads_drdy : in  std_logic;
           ads_cs : out std_logic;
           ads_sclk : out std_logic;
           dout_rdy : out std_logic;
           dout_rcv : out  std_logic_vector (23 downto 0));
    end component;
    
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
      almost_empty : out std_logic --;
      -- prog_full    : out std_logic
      );
  end component;

  -----------------------------------------------------------------------------
  -- AFE Commands
  -----------------------------------------------------------------------------
  constant M_AIRMS           : std_logic_vector(15 downto 0) := x"2028";
  constant M_AVRMS           : std_logic_vector(15 downto 0) := x"2038";
  constant M_AIRMS_OC           : std_logic_vector(15 downto 0) := x"2098";
  constant M_AVRMS_OC           : std_logic_vector(15 downto 0) := x"20A8";
  constant M_AI_WAV           : std_logic_vector(15 downto 0) := x"2008";
  constant M_AV_WAV           : std_logic_vector(15 downto 0) := x"2018";
  constant M_AWATT           : std_logic_vector(15 downto 0) := x"2048";
  constant M_AFVAR           : std_logic_vector(15 downto 0) := x"2078";
  constant M_AVA             : std_logic_vector(15 downto 0) := x"2068";
  constant M_APERIOD         : std_logic_vector(15 downto 0) := x"4188";
  constant M_VERSION_PRODUCT : std_logic_vector(15 downto 0) := x"2428";
  constant T_NO_CMDS         : integer                       := 7;
  constant T_NO_WORDS_X_CMD  : integer                       := 5;

  type commands_t is array (T_NO_CMDS*T_NO_WORDS_X_CMD-1 downto 0) of std_logic_vector(15 downto 0);
  -- constant M_CMDS : commands_t := (M_AIRMS, x"0000", x"0000", x"0000", x"0000",
  --                                 M_AVRMS, x"0000", x"0000", x"0000", x"0000",
--  constant M_CMDS : commands_t := (M_AIRMS_OC, x"0000", x"0000", x"0000", x"0000",
--                                   M_AVRMS_OC, x"0000", x"0000", x"0000", x"0000",
  constant M_CMDS : commands_t := (M_AI_WAV, x"0000", x"0000", x"0000", x"0000",
                                   M_AV_WAV, x"0000", x"0000", x"0000", x"0000",
                                   M_AWATT, x"0000", x"0000", x"0000", x"0000",
                                   M_AFVAR, x"0000", x"0000", x"0000", x"0000",
                                   M_AVA, x"0000", x"0000", x"0000", x"0000",
                                   M_APERIOD, x"0000", x"0000", x"0000", x"0000",
                                   M_VERSION_PRODUCT, x"0000", x"0000", x"0000", x"0000");

  -----------------------------------------------------------------------------
  -- General configuration parameters
  -----------------------------------------------------------------------------
  constant CLK_FREQ_N       : natural  := 60000000;
  constant SCLK_FREQ_N      : natural  := 4000000;
  constant FRAME_N_N        : natural  := 9;
  constant BIT_N_N          : natural  := 24;

  -----------------------------------------------------------------------------
  -- Command signals
  -----------------------------------------------------------------------------
  signal active_dev     : std_logic;
  signal active_dev_dly : std_logic;

  -----------------------------------------------------------------------------
  -- AXI-Stream
  -----------------------------------------------------------------------------
  type tag_fsm is (Qidle, Qrun);
  signal frame_state                                     : tag_fsm;
  signal fifo_rd_en, fifo_wr_en, fifo_empty, fifo_aempty : std_logic;
  signal fifo_full, fifo_afull, fifo_pfull               : std_logic;
  signal fifo_din                                        : std_logic_vector(31 downto 0);

  -----------------------------------------------------------------------------
  -- Init conversion
  -----------------------------------------------------------------------------
  signal init_conv : std_logic;
  signal init_cnt  : integer range 0 to 16#FFFFF#;

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
  signal spi_dout_valid_dly, spi_dout_valid_edge       : std_logic;
  signal spi_dout                                      : std_logic_vector(23 downto 0);

  signal cmd_cnt : integer range 0 to T_NO_CMDS*T_NO_WORDS_X_CMD-1;

  -----------------------------------------------------------------------------
  -- Time stamp signals
  -----------------------------------------------------------------------------
  signal time_stamp_cnt : std_logic_vector(31 downto 0);


begin  -- rtl

  -----------------------------------------------------------------------------
  -- SPI master controller
  -----------------------------------------------------------------------------
  RDataC : rdatac_ctrl
    generic map ( CLK_FREQ =>  CLK_FREQ_N,
            SCLK_FREQ =>  SCLK_FREQ_N,
            FRAME_N =>  FRAME_N_N,
            BIT_N =>  BIT_N_N  )	
    port map ( 
           clk => mclk,
           rst => mrst,
           start => '1',
           ads_din => spi_miso_i,
           ads_drdy => spi_drdy_i,
           ads_cs => spi_ssel_o,
           ads_sclk => spi_sck_o,
           dout_rdy => spi_dout_valid,
           dout_rcv => spi_dout
       );

  spi_din <= M_CMDS(cmd_cnt);
  -- spi_wren <= '1' when (cmd_cnt/= 0) else '0';


--  -- Edge_detection in spi_din_req
--  process (mclk, mrst)
--  begin  -- process
--    if mrst = '1' then                    -- asynchronous reset (active low)
--      spi_din_req_dly    <= '0';
--      spi_dout_valid_dly <= '0';
--    elsif mclk'event and mclk = '1' then  -- rising clock edge
--      spi_din_req_dly    <= spi_din_req;
--      spi_dout_valid_dly <= spi_dout_valid;
--    end if;
--  end process;

--  spi_message_end <= '1' when (cmd_cnt = 30 or cmd_cnt = 25 or cmd_cnt = 20 or cmd_cnt = 15 or cmd_cnt = 10 or cmd_cnt = 5) else '0';

--  -- process (cmd_cnt, spi_din_req_edge_short, spi_din_req_edge_long)
--  process (mrst, mclk)
--  begin  -- process
--    if mrst = '1' then
--      spi_din_req_edge   <= '0';
--    elsif mclk'event and mclk = '1' then
--      if (spi_message_end = '1') then
--        spi_din_req_edge <= spi_din_req_edge_long;
--      else
--        spi_din_req_edge <= spi_din_req_edge_short;
--      end if;
--    end if;
--  end process;

--  spi_din_req_edge_short <= (not spi_din_req_dly) and spi_din_req;
--  spi_dout_valid_edge    <= (not spi_dout_valid_dly) and spi_dout_valid;

  process (mclk, mrst)
    constant N_DEPTH   : integer := 100;
    variable shift_reg : std_logic_vector(N_DEPTH-1 downto 0);
  begin  -- process
    if mrst = '1' then                    -- asynchronous reset (active low)
      shift_reg                  := (others => '0');
      spi_din_req_edge_long <= '0';
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      for i in N_DEPTH-1 downto 1 loop
        shift_reg(i)             := shift_reg(i-1);
      end loop;  -- i
      shift_reg(0)               := ((not spi_din_req_dly) and spi_din_req) and spi_message_end;
      spi_din_req_edge_long <= shift_reg(N_DEPTH-1);
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Command register
  -----------------------------------------------------------------------------
--  active_dev <= cmd_reg(0);

  process (mclk, mrst)
  begin  -- process
    if mrst = '1' then                    -- asynchronous reset (active low)
      active_dev_dly   <= '0';
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      if active_dev = '1' then
        active_dev_dly <= '1';
      elsif active_dev = '0' and spi_dout_valid = '1' then
        active_dev_dly <= '0';
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Status register
  -----------------------------------------------------------------------------
--  status_reg <= (others => '1');


--  -----------------------------------------------------------------------------
--  -- Init conversion management
--  -----------------------------------------------------------------------------
--  process (mclk, mrst)
--  begin  -- process
--    if mrst = '1' then                    -- asynchronous reset (active low)
--      init_cnt     <= 24800;
--    elsif mclk'event and mclk = '1' then  -- rising clock edge
--      if active_dev = '0' and active_dev_dly = '0' then
--        init_cnt   <= 24800;
--      elsif active_dev = '1' or active_dev_dly = '1' then
--        if init_cnt = (sampling_reg(19 downto 0) - 1) then
--          init_cnt <= 0;
--        else
--          init_cnt <= init_cnt + 1;
--        end if;
--      end if;
--    end if;
--  end process;

--  init_conv <= '1' when (init_cnt = (sampling_reg(19 downto 0) - 1)) else '0';


--  -----------------------------------------------------------------------------
--  -- Time stamp
--  -----------------------------------------------------------------------------
--  process (mclk, mrst)
--  begin  -- process
--    if mrst = '1' then                    -- asynchronous reset (active low)
--      time_stamp_cnt   <= (others => '0');
--    elsif mclk'event and mclk = '1' then  -- rising clock edge
--      if active_dev = '0' then
--        time_stamp_cnt <= (others => '0');
--      elsif init_conv = '1' then
--        time_stamp_cnt <= time_stamp_cnt + 1;
--      end if;
--    end if;
--  end process;

--  time_stamp <= time_stamp_cnt;


  -----------------------------------------------------------------------------
  -- AXI-Stream interface
  -----------------------------------------------------------------------------
  process (mclk, mrst)
  begin  -- process
    if mrst = '1' then                    -- asynchronous reset (active low)
      maxis_tvalid   <= '0';
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      if ((frame_state = Qrun) and (fifo_empty = '0')) then
        maxis_tvalid <= '1';
      else
        maxis_tvalid <= '0';
      end if;
    end if;
  end process;

  -- maxis_tvalid <= '1'        when (frame_state = Qrun) else '0';
  maxis_tlast <= fifo_empty when (frame_state = Qrun) else '0';
  maxis_tstrb <= (others => '1');

  FIFO_MEM_I : fifo64x32
    port map (
      clk          => mclk,
      srst         => mrst,
      din          => fifo_din,
      wr_en        => fifo_wr_en,
      rd_en        => fifo_rd_en,
      dout         => maxis_tdata,
      full         => fifo_full,
      almost_full  => fifo_afull,
      empty        => fifo_empty,
      almost_empty => fifo_aempty-- ,
      -- prog_full    => fifo_pfull
      );

    fifo_din(31 downto 24) <= (others => spi_dout(23));
    fifo_din(23 downto 0)  <= spi_dout;
    fifo_wr_en <= spi_dout_valid  when (fifo_afull = '0')   else '0';
    fifo_rd_en <= (maxis_tready and (not fifo_empty)) when (frame_state = Qrun) else '0';

  process (mclk, mrst)
  begin  -- process
    if mrst = '1' then                    -- asynchronous reset (active low)
      frame_state       <= Qidle;
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      case frame_state is
        when Qidle =>
          if fifo_pfull = '1' then
            frame_state <= Qrun;
          else
            frame_state <= Qidle;
          end if;

        when Qrun =>
          if fifo_empty = '1' then
            frame_state <= Qidle;
          else
            frame_state <= Qrun;
          end if;

        when others => null;
      end case;
    end if;
  end process;
  
  spi_mosi_o <= '0';

end rtl;
