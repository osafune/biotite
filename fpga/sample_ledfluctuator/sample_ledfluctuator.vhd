-- ===================================================================
-- TITLE : BIOTITE test project
--
--   DEGISN : S.OSAFUNE (J-7SYSTEM WORKS LIMITED)
--   DATE   : 2019/05/18 -> 2019/05/18
--
-- ===================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sample_ledfluctuator is
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
end sample_ledfluctuator;

architecture RTL of sample_ledfluctuator is
	signal clock_sig		: std_logic;
	signal reset_sig		: std_logic;

	signal reset_counter	: integer range 0 to 1023 := 0;
	signal reset_reg		: std_logic := '0';

	component fluctuator
	port(
		reset		: in  std_logic;
		clk			: in  std_logic;
		enable		: in  std_logic := '1';

		random		: out std_logic_vector(15 downto 0);
		random2		: out std_logic_vector(15 downto 0);
		fluctuator	: out std_logic_vector(15 downto 0);
		out_valid	: out std_logic
	);
	end component;
	signal enable_sig		: std_logic;
	signal fluctuator_sig	: std_logic_vector(15 downto 0);

	signal clkdiv_count_reg	: std_logic_vector(26 downto 0);
	signal pwmcompare_sig	: std_logic_vector(7 downto 0);
	signal pwmcount_sig		: std_logic_vector(7 downto 0);
	signal pwmout_reg		: std_logic;
begin

	----------------------------------------------
	-- クロックとリセットを生成 
	----------------------------------------------

	clock_sig <= CLOCK_50;

	process (clock_sig) begin
		if rising_edge(clock_sig) then
			if (reset_counter /= 1023) then
				reset_counter <= reset_counter + 1;
				reset_reg <= '0';
			else
				reset_reg <= '1';
			end if;
		end if;
	end process;

	reset_sig <= not reset_reg;

	QSPI_CE_N <= '1';
	QSPI_SCK <= '0';
	QSPI_SIO <= (others=>'Z');

	GPIO_D <= (others=>'Z');


	----------------------------------------------
	-- LEDを1/fゆらぎで点滅 
	----------------------------------------------

	enable_sig <= '1' when(clkdiv_count_reg(15 downto 0) = 0) else '0';

	u : fluctuator
	port map(
		reset		=> reset_sig,
		clk			=> clock_sig,
		enable		=> enable_sig,
		fluctuator	=> fluctuator_sig
	);


	pwmcompare_sig<= fluctuator_sig(15 downto 8);
	pwmcount_sig  <= clkdiv_count_reg(7 downto 0);

	process (clock_sig, reset_sig) begin
		if (reset_sig = '1') then
			clkdiv_count_reg <= (others=>'0');
			pwmout_reg <= '0';

		elsif rising_edge(clock_sig) then
			clkdiv_count_reg <= clkdiv_count_reg + 1;

			if (pwmcount_sig = pwmcompare_sig) then
				pwmout_reg <= '1';
			elsif (pwmcount_sig = 0) then
				pwmout_reg <= '0';
			end if;

		end if;
	end process;


	USERLED <= (pwmout_reg & pwmout_reg & pwmout_reg) xor USERKEY;

	LED7SEG1 <= (others=>pwmout_reg);
	LED7SEG2 <= (others=>pwmout_reg);
	LED7SEG3 <= (others=>pwmout_reg);



end RTL;
