-- ===================================================================
-- TITLE : BIOTITE NiosII test project
--
--   DEGISN : S.OSAFUNE (J-7SYSTEM WORKS LIMITED)
--   DATE   : 2018/08/04 -> 2018/08/04
--
-- ===================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sample_nios2 is
	port(
		CLOCK_50		: in  std_logic;

		USERKEY			: in  std_logic_vector(3 downto 1);
		USERLED			: out std_logic_vector(3 downto 1);

		QSPI_CE_N		: out std_logic;
		QSPI_SCK		: out std_logic;
		QSPI_SIO		: inout std_logic_vector(3 downto 0);

		LED7SEG1		: out std_logic_vector(6 downto 0);
		LED7SEG2		: out std_logic_vector(6 downto 0);
		LED7SEG3		: out std_logic_vector(6 downto 0);

		GPIO_D			: inout std_logic_vector(35 downto 0)
	);
end sample_nios2;

architecture RTL of sample_nios2 is
	signal clock_sig		: std_logic;
	signal reset_sig		: std_logic;


	component syspll
	port (
		areset	: IN STD_LOGIC  := '0';
		inclk0	: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		locked	: OUT STD_LOGIC 
	);
	end component;
	signal clock_50mhz_sig	: std_logic;
	signal qspi_outclock_sig: std_logic;
	signal pll_locked_sig	: std_logic;
	signal qsysreset_n_sig	: std_logic;

    component nios2core is
        port (
            clk_clk         : in    std_logic                     := 'X';             -- clk
            reset_reset_n   : in    std_logic                     := 'X';             -- reset_n
            syskey_in_port  : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- in_port
            syskey_out_port : out   std_logic_vector(2 downto 0);                     -- out_port
            qspi_sio        : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- sio
            qspi_sck        : out   std_logic;                                        -- sck
            qspi_ce_n       : out   std_logic;                                        -- ce_n
            qspi_outclock   : in    std_logic                     := 'X';             -- outclock
            gpio0_export    : inout std_logic_vector(11 downto 0) := (others => 'X'); -- export
            gpio1_export    : inout std_logic_vector(11 downto 0) := (others => 'X'); -- export
            gpio2_export    : inout std_logic_vector(11 downto 0) := (others => 'X'); -- export
            led7seg_export  : out   std_logic_vector(23 downto 0)                     -- export
        );
    end component nios2core;
	signal led7seg_sig		: std_logic_vector(23 downto 0);

begin

	----------------------------------------------
	-- クロックとリセットを生成 
	----------------------------------------------

	clock_sig <= CLOCK_50;
	reset_sig <= '0';

	u0 : syspll
	port map (
		areset	 => reset_sig,
		inclk0	 => clock_sig,
		c0		 => clock_50mhz_sig,
		c1		 => qspi_outclock_sig,
		locked	 => pll_locked_sig
	);

	qsysreset_n_sig <= pll_locked_sig;


	----------------------------------------------
	-- Qsysモジュール 
	----------------------------------------------

	u1 : nios2core
	port map (
		clk_clk         => clock_50mhz_sig,
		reset_reset_n   => qsysreset_n_sig,
		qspi_sio        => QSPI_SIO,
		qspi_sck        => QSPI_SCK,
		qspi_ce_n       => QSPI_CE_N,
		qspi_outclock   => qspi_outclock_sig,
		syskey_in_port  => USERKEY,
		syskey_out_port => USERLED,
		led7seg_export  => led7seg_sig,
		gpio0_export    => GPIO_D(11 downto 0),
		gpio1_export    => GPIO_D(23 downto 12),
		gpio2_export    => GPIO_D(35 downto 24)
	);

	LED7SEG1 <= led7seg_sig(6 downto 0);
	LED7SEG2 <= led7seg_sig(14 downto 8);
	LED7SEG3 <= led7seg_sig(22 downto 16);



end RTL;
