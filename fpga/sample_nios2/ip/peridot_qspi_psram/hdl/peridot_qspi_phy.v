// ===================================================================
// TITLE : PERIDOT-NGS / QSPI Phy-Layer
//
//   DEGISN : S.OSAFUNE (J-7SYSTEM WORKS LIMITED)
//   DATE   : 2019/04/28 -> 2019/04/28
//   MODIFY :
//
// ===================================================================
//
// The MIT License (MIT)
// Copyright (c) 2019 J-7SYSTEM WORKS LIMITED.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

`default_nettype none

module peridot_qspi_phy #(
	parameter DEVICE_FAMILY	= "Cyclone III"
//	parameter DEVICE_FAMILY	= "Cyclone IV E"
//	parameter DEVICE_FAMILY	= "Cyclone 10 LP"
//	parameter DEVICE_FAMILY	= "MAX 10"
) (
	output wire [7:0]	test_sck_count,

	input wire			clock,				// core and SIO latch clock
	input wire			outclock,			// output clock (shifted phase equivalent to tco)

	input wire			sck_enable,
	input wire			cs_enable,
	input wire  [3:0]	sio_outenable,
	input wire  [3:0]	sio_outdata,
	output wire [3:0]	sio_indata,

	output wire			qspi_sck,
	output wire			qspi_cs_n,
	inout wire  [3:0]	qspi_sio
);


/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */



/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
//	wire			reset_sig = ;			// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
//	wire			clock_sig = ;			// モジュール内部駆動クロック 

	reg				clock_ena_reg;
	wire [3:0]		datain_sig;

	(* altera_attribute = "FAST_OUTPUT_REGISTER=ON" *)
	reg				cs_reg;
	(* altera_attribute = "FAST_OUTPUT_REGISTER=ON ; FAST_OUTPUT_ENABLE_REGISTER=ON" *)
	reg  [3:0]		dataout_reg;
	(* altera_attribute = "FAST_OUTPUT_ENABLE_REGISTER=ON" *)
	reg  [3:0]		oe_reg;
	(* altera_attribute = "FAST_INPUT_REGISTER=ON" *)
	reg  [3:0]		datain_reg;

	reg  [7:0]		sck_count_reg;
	genvar i;


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テスト記述 ============== */

	always @(posedge outclock) begin
		if (clock_ena_reg) begin
			sck_count_reg <= sck_count_reg + 1'd1;
		end
		else begin
			sck_count_reg <= 1'd0;
		end
	end

	assign test_sck_count = sck_count_reg;


/* ===== モジュール構造記述 ============== */

	always @(posedge outclock) begin
		clock_ena_reg <= sck_enable;
		cs_reg <= cs_enable;
		oe_reg <= sio_outenable;
		dataout_reg <= sio_outdata;
	end

	altddio_out #(
		.extend_oe_disable			("OFF"),
		.intended_device_family		(DEVICE_FAMILY),
		.invert_output				("OFF"),
		.lpm_hint					("UNUSED"),
		.lpm_type					("altddio_out"),
		.oe_reg						("UNREGISTERED"),
		.power_up_high				("OFF"),
		.width						(1)
	)
	u_sck (
		.datain_h	(1'b0),
		.datain_l	(clock_ena_reg),
		.outclock	(outclock),
		.dataout	(qspi_sck),
		.aclr		(1'b0),
		.aset		(1'b0),
		.oe			(1'b1),
		.oe_out		(),
		.outclocken	(1'b1),
		.sclr		(1'b0),
		.sset		(1'b0)
	);

	assign qspi_cs_n = ~cs_reg;

	generate
		for (i=0 ; i<4 ; i=i+1) begin : u_io
			assign qspi_sio[i] = (oe_reg[i])? dataout_reg[i] : 1'bz;
			assign datain_sig[i] = qspi_sio[i];
		end
	endgenerate

	always @(posedge clock) begin
		datain_reg <= datain_sig;
	end

	assign sio_indata = datain_reg;



endmodule
