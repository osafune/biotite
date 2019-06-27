-- ===================================================================
-- TITLE : 1/f fluctuator module
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM WORKS LIMITED)
--     DATE   : 2019/05/15 -> 2019/06/05
--
-- ===================================================================

-- The MIT License (MIT)
-- Copyright (c) 2019 J-7SYSTEM WORKS LIMITED.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- resource
-- CycloneIII/IV E/10LP/MAX10 : 120LE + 2DSP
-- MAX II/V : 576LE


library ieee;
library lpm;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use lpm.lpm_components.all;

entity fluctuator is
	port(
		reset		: in  std_logic;
		clk			: in  std_logic;
		enable		: in  std_logic := '1';

		random		: out std_logic_vector(15 downto 0);
		random2		: out std_logic_vector(15 downto 0);
		fluctuator	: out std_logic_vector(15 downto 0);
		out_valid	: out std_logic
	);
end fluctuator;

architecture RTL of fluctuator is
	type DEF_STATE_CALC is (MULT,ADD);
	signal state		: DEF_STATE_CALC;

	signal r2_reg		: std_logic_vector(15 downto 0);
	signal f_reg		: std_logic_vector(17 downto 0);
	signal inv_f_sig	: std_logic_vector(18 downto 0);
	signal mul_a_reg	: std_logic_vector(17 downto 0);
	signal mul_ans_sig	: std_logic_vector(35 downto 0);
	signal add_f_sig	: std_logic_vector(17 downto 0);

	signal x_reg		: std_logic_vector(31 downto 0);
	signal a_sig		: std_logic_vector(31 downto 0);
	signal b_sig		: std_logic_vector(31 downto 0);
	signal c_sig		: std_logic_vector(31 downto 0);
	signal rand_sig		: std_logic_vector(31 downto 0);

begin

	----------------------------------------------
	-- 間欠カオス関数 
	----------------------------------------------

	-- Xorshift32
	a_sig <= x_reg xor (x_reg(18 downto 0) & "0000000000000");
	b_sig <= a_sig xor ("00000000000000000" & a_sig(31 downto 17));
	c_sig <= b_sig xor (b_sig(16 downto 0) & "000000000000000");
	rand_sig <= x_reg;

	-- pow_u18
	inv_f_sig <= conv_std_logic_vector(262144, 19) - ('0' & f_reg);

	u_mult : lpm_mult
	generic map(
		lpm_type			=> "LPM_MULT",
		lpm_representation	=> "UNSIGNED",
		lpm_hint			=> "MAXIMIZE_SPEED=5",
		lpm_widtha			=> 18,
		lpm_widthb			=> 18,
		lpm_widthp			=> 36
	)
	port map(
		dataa	=> mul_a_reg,
		datab	=> mul_a_reg,
		result	=> mul_ans_sig
	);

	add_f_sig <= mul_ans_sig(34 downto 18) & (mul_ans_sig(17) xor rand_sig(31));

	-- main FSM
	process (clk, reset) begin
		if (reset = '1') then
			state <= ADD;
			x_reg <= conv_std_logic_vector(2463534242, 32);
			r2_reg <= (others=>'0');
			f_reg <= (others=>'0');

		elsif rising_edge(clk) then
			if (enable = '1') then

				case state is
				when MULT =>
					state <= ADD;

					if (f_reg(17) = '1') then
						mul_a_reg <= inv_f_sig(17 downto 0);
					else
						mul_a_reg <= f_reg;
					end if;

					r2_reg <= mul_ans_sig(34 downto 19);

				when ADD =>
					state <= MULT;
					x_reg <= c_sig;

					mul_a_reg <= rand_sig(17 downto 0);

					if (f_reg(17 downto 14) = "1111") then
						f_reg <= f_reg - ("000000" & rand_sig(11 downto 0));
					elsif (f_reg(17 downto 14) = "0000") then
						f_reg <= f_reg + ("000000" & rand_sig(11 downto 0));
					else
						if (f_reg(17) = '1') then
							f_reg <= f_reg - add_f_sig;
						else
							f_reg <= f_reg + add_f_sig;
						end if;
					end if;

				end case;
			end if;

		end if;
	end process;

	-- data output
	random <= x_reg(31 downto 16);
	random2 <= r2_reg;
	fluctuator <= f_reg(17 downto 2);
	out_valid <= '1' when(state = MULT) else '0';



end RTL;
