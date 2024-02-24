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
    cmd_reg        : in  std_logic_vector(31 downto 0);
    status_reg     : out std_logic_vector(31 downto 0);
    sampling_reg   : in  std_logic_vector(31 downto 0);
    spi_ssel_o     : out std_logic;
    spi_sck_o      : out std_logic;
    spi_mosi_o     : out std_logic;
    spi_miso_i     : in  std_logic := 'X';
    time_stamp     : out std_logic_vector(31 downto 0)
    );
    -- ila_fifo_din   : out std_logic_vector(31 downto 0);
    -- ila_fifo_wr_en : out std_logic;
    -- ila_spi_dout   : out std_logic_vector(15 downto 0));
end spi_ctrl;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Main architecture
-------------------------------------------------------------------------------
architecture rtl of spi_ctrl is

  -----------------------------------------------------------------------------
  -- SPI master controller
  -----------------------------------------------------------------------------
  component spi_master
    generic (
      N              :     positive;
      CPOL           :     std_logic;
      CPHA           :     std_logic;
      PREFETCH       :     positive;
      SPI_2X_CLK_DIV :     positive);
    port (
      sclk_i         : in  std_logic                       := 'X';
      pclk_i         : in  std_logic                       := 'X';
      rst_i          : in  std_logic                       := 'X';
      spi_ssel_o     : out std_logic;
      spi_sck_o      : out std_logic;
      spi_mosi_o     : out std_logic;
      spi_miso_i     : in  std_logic                       := 'X';
      di_req_o       : out std_logic;
      di_i           : in  std_logic_vector (N-1 downto 0) := (others => 'X');
      wren_i         : in  std_logic                       := 'X';
      wr_ack_o       : out std_logic;
      do_valid_o     : out std_logic;
      do_o           : out std_logic_vector (N-1 downto 0);
      sck_ena_o      : out std_logic;
      sck_ena_ce_o   : out std_logic;
      do_transfer_o  : out std_logic;
      wren_o         : out std_logic;
      rx_bit_reg_o   : out std_logic;
      state_dbg_o    : out std_logic_vector (3 downto 0);
      core_clk_o     : out std_logic;
      core_n_clk_o   : out std_logic;
      core_ce_o      : out std_logic;
      core_n_ce_o    : out std_logic;
      sh_reg_dbg_o   : out std_logic_vector (N-1 downto 0));
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
      almost_empty : out std_logic;
      prog_full    : out std_logic
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
  constant C_N              : integer   := 16;
  constant C_CPOL           : std_logic := '1';
  constant C_CPHA           : std_logic := '1';
  constant C_PREFETCH       : integer   := 2;
  constant C_SPI_2X_CLK_DIV : integer   := 5;

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
  signal spi_dout                                      : std_logic_vector(15 downto 0);

  signal cmd_cnt : integer range 0 to T_NO_CMDS*T_NO_WORDS_X_CMD-1;

  -----------------------------------------------------------------------------
  -- Time stamp signals
  -----------------------------------------------------------------------------
  signal time_stamp_cnt : std_logic_vector(31 downto 0);


begin  -- rtl

  -----------------------------------------------------------------------------
  -- SPI master controller
  -----------------------------------------------------------------------------
  SPICtrl : spi_master
    generic map (
      N              => C_N,
      CPOL           => C_CPOL,
      CPHA           => C_CPHA,
      PREFETCH       => C_PREFETCH,
      SPI_2X_CLK_DIV => C_SPI_2X_CLK_DIV)
    port map (
      sclk_i         => mclk,
      pclk_i         => mclk,
      rst_i          => mrst,
      spi_ssel_o     => spi_ssel_o,
      spi_sck_o      => spi_sck_o,
      spi_mosi_o     => spi_mosi_o,
      spi_miso_i     => spi_miso_i,
      di_req_o       => spi_din_req,
      di_i           => spi_din,
      wren_i         => spi_wren,
      wr_ack_o       => spi_wr_ack,
      do_valid_o     => spi_dout_valid,
      do_o           => spi_dout,
      -- Debug signals
      sck_ena_o      => open,
      sck_ena_ce_o   => open,
      do_transfer_o  => open,
      wren_o         => open,
      rx_bit_reg_o   => open,
      state_dbg_o    => open,
      core_clk_o     => open,
      core_n_clk_o   => open,
      core_ce_o      => open,
      core_n_ce_o    => open,
      sh_reg_dbg_o   => open);

  spi_din <= M_CMDS(cmd_cnt);
  -- spi_wren <= '1' when (cmd_cnt/= 0) else '0';

  -- Commands transmission
  process (mclk, mrst)
  begin  -- process
    if mrst = '1' then                    -- asynchronous reset (active low)
      cmd_cnt      <= 0;
      spi_wren     <= '0';
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      spi_wren     <= '0';
      if init_conv = '1' then
        cmd_cnt    <= T_NO_CMDS*T_NO_WORDS_X_CMD-1;
        -- cmd_cnt    <= 4;
        spi_wren   <= '1';
      elsif cmd_cnt > 0 then
        -- if spi_wr_ack = '1' then
        if spi_din_req_edge = '1' then
          cmd_cnt  <= cmd_cnt - 1;
          spi_wren <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Edge_detection in spi_din_req
  process (mclk, mrst)
  begin  -- process
    if mrst = '1' then                    -- asynchronous reset (active low)
      spi_din_req_dly    <= '0';
      spi_dout_valid_dly <= '0';
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      spi_din_req_dly    <= spi_din_req;
      spi_dout_valid_dly <= spi_dout_valid;
    end if;
  end process;

  spi_message_end <= '1' when (cmd_cnt = 30 or cmd_cnt = 25 or cmd_cnt = 20 or cmd_cnt = 15 or cmd_cnt = 10 or cmd_cnt = 5) else '0';

  -- process (cmd_cnt, spi_din_req_edge_short, spi_din_req_edge_long)
  process (mrst, mclk)
  begin  -- process
    if mrst = '1' then
      spi_din_req_edge   <= '0';
    elsif mclk'event and mclk = '1' then
      if (spi_message_end = '1') then
        spi_din_req_edge <= spi_din_req_edge_long;
      else
        spi_din_req_edge <= spi_din_req_edge_short;
      end if;
    end if;
  end process;

  spi_din_req_edge_short <= (not spi_din_req_dly) and spi_din_req;
  spi_dout_valid_edge    <= (not spi_dout_valid_dly) and spi_dout_valid;

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
  active_dev <= cmd_reg(0);

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
  status_reg <= (others => '1');


  -----------------------------------------------------------------------------
  -- Init conversion management
  -----------------------------------------------------------------------------
  process (mclk, mrst)
  begin  -- process
    if mrst = '1' then                    -- asynchronous reset (active low)
      init_cnt     <= 24800;
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      if active_dev = '0' and active_dev_dly = '0' then
        init_cnt   <= 24800;
      elsif active_dev = '1' or active_dev_dly = '1' then
        if init_cnt = (sampling_reg(19 downto 0) - 1) then
          init_cnt <= 0;
        else
          init_cnt <= init_cnt + 1;
        end if;
      end if;
    end if;
  end process;

  init_conv <= '1' when (init_cnt = (sampling_reg(19 downto 0) - 1)) else '0';


  -----------------------------------------------------------------------------
  -- Time stamp
  -----------------------------------------------------------------------------
  process (mclk, mrst)
  begin  -- process
    if mrst = '1' then                    -- asynchronous reset (active low)
      time_stamp_cnt   <= (others => '0');
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      if active_dev = '0' then
        time_stamp_cnt <= (others => '0');
      elsif init_conv = '1' then
        time_stamp_cnt <= time_stamp_cnt + 1;
      end if;
    end if;
  end process;

  time_stamp <= time_stamp_cnt;


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
      almost_empty => fifo_aempty,
      prog_full    => fifo_pfull);

  fifo_din   <= time_stamp_cnt(15 downto 0) & spi_dout;
  fifo_wr_en <= spi_dout_valid_edge                 when (fifo_afull = '0')   else '0';
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


  ------------------------------------------------------------------------------
  -- Debugging
  ------------------------------------------------------------------------------
  -- ila_fifo_din   <= fifo_din;
  -- ila_fifo_wr_en <= fifo_wr_en;
  -- ila_spi_dout   <= spi_dout;

end rtl;
