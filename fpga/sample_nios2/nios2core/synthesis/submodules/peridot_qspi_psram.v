// ===================================================================
// TITLE : PERIDOT-NGS / QSPI PSRAM
//
//   DEGISN : S.OSAFUNE (J-7SYSTEM WORKS LIMITED)
//   DATE   : 2019/04/28 -> 2019/04/29
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

module peridot_qspi_psram #(
	parameter CS_NEGATE_DELAY = 2,			// tCHD cycle
	parameter CS_NEGATE_HOLD = 5-1,			// tCPH cycle
	parameter SPI_READ_WAIT_CYCLE = 8-2,	// SPI Fast Read wait cycle
	parameter QSPI_READ_WAIT_CYCLE = 6-2,	// QSPI Fast Read wait cycle
	parameter READDATA_LATENCY = 5-1,
	parameter INITIAL_WAIT_CYCLE = 10,
	parameter DEVICE_FAMILY	= "Cyclone III"
//	parameter DEVICE_FAMILY	= "Cyclone IV E"
//	parameter DEVICE_FAMILY	= "Cyclone 10 LP"
//	parameter DEVICE_FAMILY	= "MAX 10"
) (
	// clock & reset
	input wire			csi_reset,
	input wire			csi_clock,

	// Avalon-MM interface
	input wire  [22:0]	avs_address,
	input wire			avs_read,
	output wire [31:0]	avs_readdata,
	output wire			avs_readdatavalid,
	input wire			avs_write,
	input wire  [31:0]	avs_writedata,
	input wire  [3:0]	avs_byteenable,
	output wire			avs_waitrequest,

	// Conduit interface
	input wire			outclock,			// QSPI output clock (shifted phase equivalent to tco)
	output wire			qspi_sck,
	output wire			qspi_cs_n,
	inout wire  [3:0]	qspi_sio
);


/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */



/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
//	wire			reset_sig = csi_reset;		// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
//	wire			clock_sig = csi_clock;		// モジュール内部駆動クロック 


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テスト記述 ============== */



/* ===== モジュール構造記述 ============== */

	peridot_qspi_avs #(
		.CS_NEGATE_DELAY		(CS_NEGATE_DELAY),
		.CS_NEGATE_HOLD			(CS_NEGATE_HOLD),
		.SPI_READ_WAIT_CYCLE	(SPI_READ_WAIT_CYCLE),
		.QSPI_READ_WAIT_CYCLE	(QSPI_READ_WAIT_CYCLE),
		.READDATA_LATENCY		(READDATA_LATENCY),
		.INITIAL_WAIT_CYCLE		(INITIAL_WAIT_CYCLE),
		.DEVICE_FAMILY			(DEVICE_FAMILY)
	)
	u0 (
		.csi_reset			(csi_reset),
		.csi_clock			(csi_clock),

		.avs_address		({1'b0, avs_address}),
		.avs_read			(avs_read),
		.avs_readdata		(avs_readdata),
		.avs_readdatavalid	(avs_readdatavalid),
		.avs_write			(avs_write),
		.avs_writedata		(avs_writedata),
		.avs_byteenable		(avs_byteenable),
		.avs_waitrequest	(avs_waitrequest),

		.outclock			(outclock),
		.qspi_sck			(qspi_sck),
		.qspi_cs_n			(qspi_cs_n),
		.qspi_sio			(qspi_sio)
	);



endmodule
