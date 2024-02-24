----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ads_rdatac_ctrl is
	 generic ( CLK_FREQ : natural :=  100000000; --system clk 100 MHz
			   SCLK_FREQ : natural := 4000000; --ADC sclk 10 MHz
			   FRAME_N: natural := 9; --STAT + 8CHs
			   BIT_N : natural := 24 --ADC bit
			   );	
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           start : in std_logic;
           ads_din : in  STD_LOGIC;
           ads_dout : out  STD_LOGIC;
           ads_drdy : in  STD_LOGIC;
           ads_cs : out std_logic;
           ads_sclk : out std_logic;
           dout_rdy : out std_logic;
           dout_rcv : out  STD_LOGIC_VECTOR (BIT_N-1 downto 0));
end ads_rdatac_ctrl;

architecture comp of ads_rdatac_ctrl is

	constant bit_adc : natural := BIT_N - 1;
	constant frame_adc : natural := FRAME_N -1 ;
		
--	signal bit_cnt : natural range 0 to bit_adc;
--	signal frame_cnt: natural range 0 to frame_adc;
	
	signal bit_cnt : unsigned(5 downto 0); -- range 0 to bit_adc;
	signal frame_cnt: unsigned(4 downto 0); -- natural range 0 to frame_adc;
	
	signal fcnt_full : std_logic;
	signal fcnt_bit : std_logic;
	signal fcnt_frame : std_logic;
	
	signal flag : std_logic;
	signal tx_buff : std_logic_vector(23 downto 0);
	
	type state is (idle, stat1, stat2, data_ready, data_read, data_shift);
	signal cstate, nstate: state;
		
    signal clk_4Mz : std_logic;
    signal clk_8Mz : std_logic;
    signal en_count_bit : std_logic;
    signal en_count_bit_delay : std_logic;
	
	component clk_div_8MHz is
    port ( clk_in_50MHz : in STD_LOGIC;
            rst : in std_logic;
           clk_out_8MHz : out STD_LOGIC);
    end component;

begin
	-- Generate ADC sclk signal
	UUT: clk_div_8MHz port map( clk_in_50MHz => clk, rst => rst, clk_out_8MHz => clk_8Mz);
	
	-- clk_4_MHz
	gen_spi : process(clk_8Mz, rst)
	begin
		if rst = '1' then
			clk_4Mz <= '0';
		elsif rising_edge(clk_8Mz) then
            clk_4Mz <= not(clk_4Mz);
        end if;
	end process;
	
	
	-- Connect ports to internal signals
	ads_sclk <= clk_4Mz when cstate /= idle else '0' ;
    ads_cs <= '0' when start = '1' else '1';
    ads_dout <= '0';
	
	en_count_bit <= '1' when cstate /= idle else '0' ;
	en_dalay: process(clk_4Mz, rst)
	begin
	   if rst = '1' then
	       en_count_bit_delay <= '0';
	   elsif rising_edge(clk_4Mz) then
	       en_count_bit_delay <= en_count_bit;
	   end if;
	end process;
	
	-- Bits frame counter
	bitcnt : process(clk_4Mz, rst)
	begin
		if rst = '1' then
			bit_cnt <= "010111";
		elsif rising_edge(clk_4Mz) then
            if en_count_bit_delay = '1' then
               if fcnt_bit = '1' then
                    bit_cnt <= "010111";
                else
                    bit_cnt <= bit_cnt - 1;
                end if;
            end if;
        end if;
	end process bitcnt;
	fcnt_bit <= '1' when bit_cnt = 0 else '0';
	
	framecnt : process(clk_4Mz, rst)
	begin
		if rst = '1' then
			frame_cnt <= "01000";
		elsif rising_edge(clk_4Mz) then
			if fcnt_bit = '1' then
                if fcnt_frame = '1' then
                    frame_cnt <= "01000";
                else
                    frame_cnt <= frame_cnt - 1; --0 to 23 bit is a frame
                end if;
			end if;
		end if;
	end process framecnt;
	fcnt_frame <= '1' when frame_cnt = 0 and fcnt_bit = '1' else '0';
	
	fcnt_full <= '1' when fcnt_frame = '1' else '0';
	
	-- FSM register
	ffd : process(clk_8Mz, rst)
	begin
		if rst = '1' then
			cstate <= idle;
		elsif rising_edge(clk_8Mz) then
			cstate <= nstate;
		end if;
	end process ffd;
	
	--FSM
	next_state: process(cstate, ads_drdy, clk_4Mz, frame_cnt, start, fcnt_full)
	begin
		case cstate is
			when idle =>
				if ads_drdy = '0' and start = '1' then 
					nstate <= data_ready;
				else 
					nstate <= idle;
				end if;
			when data_ready =>
				if clk_4Mz = '1' then
					nstate <= data_read;
				else
					nstate <= data_ready;
				end if;
			when data_read => 
				if clk_4Mz = '1' then
					if fcnt_full = '1' then
						nstate <= idle;
					else 
						nstate <= data_shift;
					end if;
				else
					nstate <= data_read;
				end if;
			when data_shift =>
				if clk_4Mz = '1' then
					if fcnt_full = '1' then
						nstate <= idle;
					else 
						nstate <= data_read;
					end if;
				else
					nstate <= data_shift;
				end if;
			when others =>
				nstate <= idle;
		end case;
	end process next_state;
	
	-- Data shift register
	tx_buff_reg	: process(clk_4Mz, rst)
	begin
		if rst = '1' then
			tx_buff <= (others => '0');
		elsif rising_edge(clk_4Mz) then
			if cstate = data_read  then
				tx_buff(BIT_N-1 downto 1) <= tx_buff(BIT_N-2 downto 0);
				tx_buff(0) <= ads_din;
			end if;
		end if;
	end process tx_buff_reg;
	
	-- Data parallel out sync
	parallel_out_sinc: process(clk, rst)
	begin
	   if rst = '1' then
			dout_rcv <= (others => '0');
			flag <= '1';
		elsif rising_edge(clk) then
			if cstate = data_read and bit_cnt = 0 then
				dout_rcv <= tx_buff;
				if flag = '1' then
				    dout_rdy <= '1';
				    flag <= '0';
                else 
                    dout_rdy <= '0';
                    flag <= '0';
                end if;
            else 
                -- dout_rcv <= dout_rcv;
                dout_rdy <= '0';
                flag <= '1';
			end if;
		end if;
	end process;
        
end comp;

