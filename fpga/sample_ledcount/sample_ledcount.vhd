-- ===================================================================
-- TITLE : BIOTITE test project
--
--   DEGISN : S.OSAFUNE (J-7SYSTEM WORKS LIMITED)
--   DATE   : 2019/06/25 -> 2019/06/25
--   MODIFY : 2019/11/08
--
-- ===================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity sample_ledcount is
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
end sample_ledcount;

architecture RTL of sample_ledcount is
	function bcd2deg7(bin : std_logic_vector(3 downto 0))
	return std_logic_vector is
		variable res : std_logic_vector(6 downto 0);
	begin
		case (bin) is		-- gfedcba
		when "0000" => res := "0111111";
		when "0001" => res := "0000110";
		when "0010" => res := "1011011";
		when "0011" => res := "1001111";
		when "0100" => res := "1100110";
		when "0101" => res := "1101101";
		when "0110" => res := "1111101";
		when "0111" => res := "0100111";
		when "1000" => res := "1111111";
		when "1001" => res := "1101111";
		when others => res := "0000000";
		end case;

		return res;
	end function;


	signal clock_sig		: std_logic;
	signal reset_sig		: std_logic;

	signal seg1_reg			: std_logic_vector(3 downto 0);
	signal seg2_reg			: std_logic_vector(3 downto 0);
	signal seg3_reg			: std_logic_vector(3 downto 0);

	component rgb_lampy is
	port(
		clock		: in  std_logic;
		reset		: in  std_logic;
		countup		: out std_logic;

		pwm_red		: out std_logic;
		pwm_green	: out std_logic;
		pwm_blue	: out std_logic
	);
	end component;
	signal countup_sig		: std_logic;
	signal led_r_sig		: std_logic;
	signal led_g_sig		: std_logic;
	signal led_b_sig		: std_logic;

	signal seg_pwmmask1_sig	: std_logic_vector(6 downto 0);
	signal seg_pwmmask2_sig	: std_logic_vector(6 downto 0);
	signal seg_pwmmask3_sig	: std_logic_vector(6 downto 0);


begin

	----------------------------------------------
	-- クロックとリセットを生成 
	----------------------------------------------

	clock_sig <= CLOCK_50;
	reset_sig <= '0';

	QSPI_CE_N <= '1';
	QSPI_SCK <= '0';
	QSPI_SIO <= (others=>'Z');

	GPIO_D <= (others=>'Z');


	----------------------------------------------
	-- LEDをじわっと点滅 
	----------------------------------------------

	u0 : rgb_lampy
	port map(
		clock		=> clock_sig,
		reset		=> reset_sig,
		countup		=> countup_sig,
		pwm_red		=> led_r_sig,
		pwm_green	=> led_g_sig,
		pwm_blue	=> led_b_sig
	);

	USERLED <= (led_r_sig & led_g_sig & led_b_sig) xor USERKEY;


	----------------------------------------------
	-- LEDカウンタ 
	----------------------------------------------

	process (clock_sig, reset_sig) begin
		if (reset_sig = '1') then
			seg1_reg <= (others=>'0');
			seg2_reg <= (others=>'0');
			seg3_reg <= (others=>'0');

		elsif (clock_sig'event and clock_sig = '1') then
			if (countup_sig = '1') then
				seg3_reg <= seg3_reg + 1;
				if (seg3_reg = 9) then
					if (seg2_reg = 9) then
						if (seg1_reg = 9) then
							seg1_reg <= (others=>'0');
						else
							seg1_reg <= seg1_reg + 1;
						end if;

						seg2_reg <= (others=>'0');
					else
						seg2_reg <= seg2_reg + 1;
					end if;

					seg3_reg <= (others=>'0');
				else
					seg3_reg <= seg3_reg + 1;
				end if;
			end if;
		end if;
	end process;

	seg_pwmmask1_sig <= (others=>led_r_sig);
	seg_pwmmask2_sig <= (others=>led_g_sig);
	seg_pwmmask3_sig <= (others=>led_b_sig);

	LED7SEG1 <= not(bcd2deg7(seg1_reg) and seg_pwmmask1_sig);
	LED7SEG2 <= not(bcd2deg7(seg2_reg) and seg_pwmmask2_sig);
	LED7SEG3 <= not(bcd2deg7(seg3_reg) and seg_pwmmask3_sig);



end RTL;
