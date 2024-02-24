----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rdatac_ctrl is
	 generic ( CLK_FREQ : natural :=  60000000; --system clk 60 MHz -- Antes 20MHz
			   SCLK_FREQ : natural := 4000000; --ADC sclk 4 MHz
			   FRAME_N: natural := 9; --STAT + 8CHs
			   BIT_N : natural := 24 --ADC bit
			   );	
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           start : in std_logic;
           ads_din : in  STD_LOGIC;
           ads_drdy : in  STD_LOGIC;
           ads_cs : out std_logic;
           ads_sclk : out std_logic;
           dout_rdy : out std_logic;
           dout_rcv : out  STD_LOGIC_VECTOR (BIT_N-1 downto 0));
end rdatac_ctrl;

architecture comp of rdatac_ctrl is

    constant full_t : natural := CLK_FREQ/(SCLK_FREQ)  - 1; -- full period tick: t_sclk/t_clk
	constant half_t : natural := CLK_FREQ/(2*SCLK_FREQ)  - 1; -- half period tick
	constant bit_adc : natural := BIT_N;-- - 1;
	constant frame_adc : natural := FRAME_N;-- - 1;
	
	signal full_cnt : natural range 0 to full_t;
	signal bit_cnt : natural range 0 to bit_adc;
	signal frame_cnt: natural range 0 to frame_adc;
	
	signal tick : std_logic := '0';
	signal shift : std_logic := '0';	
	signal tx_buff : std_logic_vector(23 downto 0);
	
	signal rst_alt : std_logic;
	
	type state is (idle, stat1, stat2, data_ready, data_read, data_shift);
	signal cstate, nstate: state;

begin
	
	-- Connect ports to internal signals
	rst_alt <= not rst;
	ads_sclk <= shift;
    ads_cs <= '0' when start = '1' else '1';
    
	-- Generate tick signal
	tick_gen : process(clk, rst_alt)
	begin
		if rst_alt = '0' then
			full_cnt <= 0;
			tick <= '0';
		elsif rising_edge(clk) then
			if full_cnt = half_t then
				full_cnt <= full_cnt + 1;
				tick <= '1';
			elsif full_cnt = full_t then
				full_cnt <= 0;
				tick <= '1';
			else 
				full_cnt <= full_cnt + 1;
				tick <= '0';
			end if;
		end if; 
	end process tick_gen;
	
	-- Generate ADC sclk signal
	sclk_gen : process(clk, rst_alt)
	begin
		if rst_alt = '0' then
			shift <= '0';
		elsif rising_edge(clk) then
			if cstate = idle then
				shift <= '0';
			elsif tick = '1' then
				shift <= not shift;
			end if;
		end if;
	end process sclk_gen;	
	
	-- Bits frame counter
	bitcnt : process(clk, rst_alt)
	begin
		if rst_alt = '0' then
			bit_cnt <= bit_adc;
			frame_cnt <= frame_adc;
		elsif rising_edge(clk) then
			if cstate = data_read and tick = '1' then
				if bit_cnt = 0 then
					bit_cnt <= bit_adc;
					if frame_cnt = 0 then
						frame_cnt <= frame_adc;
					else
						frame_cnt <= frame_cnt - 1; --0 to 23 bit is a frame
					end if;
				else
					bit_cnt <= bit_cnt - 1;
				end if;
			end if;
		end if;
	end process bitcnt;
	
	-- FSM register
	ffd : process(clk, rst_alt)
	begin
		if rst_alt = '0' then
			cstate <= idle;
		elsif rising_edge(clk) then
			cstate <= nstate;
		end if;
	end process ffd;
	
	--FSM
	next_state: process(cstate, ads_drdy, tick, frame_cnt, start)
	begin
		case cstate is
			when idle =>
				if ads_drdy = '0' and start = '1' then 
					nstate <= data_ready;
				else 
					nstate <= idle;
				end if;
			when data_ready =>
				if tick = '1' then
					nstate <= data_read;
				else
					nstate <= data_ready;
				end if;
			when data_read => 
				if tick = '1' then
					if frame_cnt = 0 then
						nstate <= idle;
					else 
						nstate <= data_shift;
					end if;
				else
					nstate <= data_read;
				end if;
			when data_shift =>
				if tick = '1' then
					nstate <= data_read;
				else
					nstate <= data_shift;
				end if;
			when others =>
				nstate <= idle;
		end case;
	end process next_state;
	
	-- Data shift register
	tx_buff_reg	: process(clk, rst_alt)
	begin
		if rst_alt = '0' then
			tx_buff <= (others => '0');
		elsif rising_edge(clk) then
			if cstate = data_read and tick = '1' then
				tx_buff <= tx_buff(BIT_N-2 downto 0) & rst_alt;
			end if;
		end if;
	end process tx_buff_reg;
	
	-- Data parallel out
	parallel_out :
		dout_rcv <= tx_buff when cstate = data_read and bit_cnt = 0;
		dout_rdy <= '1' when  cstate = data_read and bit_cnt = 24 else '0';
        
end comp;

