// ===================================================================
// TITLE : PERIDOT-NGS / QSPI PSRAM avs controller
//
//   DEGISN : S.OSAFUNE (J-7SYSTEM WORKS LIMITED)
//   DATE   : 2019/04/28 -> 2019/05/03
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

// ・LY68L6400で現状確認されている問題
// FAST_READ_QUADで読み出すと特定の回数あるいは特定のアドレスビットパターンの時に
// 読み出しデータが異常（１ニブル分ずれる、ビット位置が入れ替わる等）になる。
// 今のところ原因不明。デバイス不良？


`default_nettype none

module peridot_qspi_avs #(
	parameter CS_NEGATE_DELAY = 2,			// tCHD cycle
	parameter CS_NEGATE_HOLD = 5-1,			// tCPH cycle
	parameter SPI_READ_WAIT_CYCLE = 8-1,	// SPI Fast Read wait cycle
	parameter QSPI_READ_WAIT_CYCLE = 6-1,	// QSPI Fast Read wait cycle
	parameter READDATA_LATENCY = 4-1,
	parameter INITIAL_WAIT_CYCLE = 10,		// Wait 150us from reset release.
	parameter DEVICE_FAMILY	= "Cyclone III"
//	parameter DEVICE_FAMILY	= "Cyclone IV E"
//	parameter DEVICE_FAMILY	= "Cyclone 10 LP"
//	parameter DEVICE_FAMILY	= "MAX 10"
) (
	output wire [7:0]	test_sck_count,
	output wire			test_command_req,
	output wire			test_spi_write_ack,
	output wire			test_spi_read_ack,
	output wire			test_qspi_write_ack,
	output wire			test_qspi_read_ack,

	// clock & reset
	input wire			csi_reset,
	input wire			csi_clock,

	// Avalon-MM interface
	input wire  [23:0]	avs_address,
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

	localparam	STATE_IDLE			= 5'd0,
				STATE_START			= 5'd1,
				STATE_ADDR			= 5'd2,
				STATE_READ			= 5'd3,
				STATE_WRITE			= 5'd4,
				STATE_INIT			= 5'd5,
				STATE_INIT_QPI		= 5'd6,
				STATE_INIT_SPI		= 5'd7,
				STATE_DONE			= 5'd31;

	localparam	CMD_RESET_ENABLE	= 8'h66;
	localparam	CMD_RESET			= 8'h99;
//	localparam	CMD_ENTER_QUAD_MODE	= 8'h35;
//	localparam	CMD_EXIT_QUAD_MODE	= 8'hf5;
//	localparam	CMD_FAST_READ_QUAD	= 8'heb;
	localparam	CMD_QUAD_WRITE		= 8'h38;
	localparam	CMD_FAST_READ		= 8'h0b;
//	localparam	CMD_WRITE			= 8'h02;
//	localparam	CMD_READ_ID			= 8'h9f;
//	localparam	CMD_SET_BURST_LEN	= 8'hc0;


/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
	wire			reset_sig = csi_reset;		// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
	wire			clock_sig = csi_clock;		// モジュール内部駆動クロック 

	reg  [4:0]		state_reg;
	reg  [14:0]		initwaitcount_reg;
	reg				avs_read_reg;
	reg  [1:0]		bytecycle_reg, datacycle_reg;
	reg				spi_wrreq_reg, spi_rdreq_reg, qspi_wrreq_reg, qspi_rdreq_reg;
	reg  [31:0]		txdata_reg;
	reg  [23:0]		address_reg;
	reg  [31:0]		wrdata_reg;
	reg  [31:0]		rddata_reg;
	reg  [1:0]		rddata_count_reg;
	reg				rddatavalid_reg;

	wire			spi_command_req_sig, qspi_command_req_sig;
	wire			spi_write_req_sig, spi_write_ack_sig;
	wire			spi_read_req_sig, spi_read_ack_sig;
	wire			qspi_write_req_sig, qspi_write_ack_sig;
	wire			qspi_read_req_sig, qspi_read_ack_sig;
	wire			qspi_idle_sig;
	wire [7:0]		qspi_wrdata_sig;
	wire [7:0]		qspi_rddata_sig;
	wire			qspi_rddatavalid_sig;


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テスト記述 ============== */

	assign test_command_req = spi_command_req_sig | qspi_command_req_sig;
	assign test_spi_write_ack = spi_write_ack_sig;
	assign test_spi_read_ack = spi_read_ack_sig;
	assign test_qspi_write_ack = qspi_write_ack_sig;
	assign test_qspi_read_ack = qspi_read_ack_sig;


/* ===== モジュール構造記述 ============== */


	///// Avalon-MM メモリスレーブ制御 /////

	assign avs_waitrequest = (state_reg != STATE_IDLE &&( avs_read || avs_write ));

	assign avs_readdata = rddata_reg;
	assign avs_readdatavalid = rddatavalid_reg;


	always @(posedge clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			state_reg <= STATE_INIT;
			initwaitcount_reg <= INITIAL_WAIT_CYCLE[14:0];
			spi_wrreq_reg <= 1'b0;
			spi_rdreq_reg <= 1'b0;
			qspi_wrreq_reg <= 1'b0;
			qspi_rdreq_reg <= 1'b0;
			avs_read_reg <= 1'b0;
			rddata_count_reg <= 1'd0;
			rddatavalid_reg <= 1'b0;
		end
		else begin

		// リードデータ組み立て 

			if (qspi_rddatavalid_sig) begin
				rddata_reg <= {qspi_rddata_sig, rddata_reg[31:8]};
				rddata_count_reg <= rddata_count_reg + 1'd1;
			end

			if (qspi_rddatavalid_sig && rddata_count_reg == 2'd3) begin
				rddatavalid_reg <= 1'b1;
			end
			else begin
				rddatavalid_reg <= 1'b0;
			end


		// 制御ステートマシン 

			case (state_reg)

			// トランザクション受付 

			STATE_IDLE : begin
				if (avs_read) begin
					state_reg <= STATE_START;
//					txdata_reg <= {CMD_FAST_READ_QUAD, avs_address[23:2], 2'd0};
					txdata_reg <= {CMD_FAST_READ, avs_address[23:2], 2'd0};
					address_reg <= {avs_address[23:2], 2'd0};
					datacycle_reg <= 2'd3;
					avs_read_reg <= 1'b1;
				end
				else if (avs_write) begin
					avs_read_reg <= 1'b0;

					case (avs_byteenable)
					4'b1111 : begin
						state_reg <= STATE_START;
						txdata_reg <= {CMD_QUAD_WRITE, avs_address[23:2], 2'd0};
						address_reg <= {avs_address[23:2], 2'd0};
						wrdata_reg <= {avs_writedata[7:0], avs_writedata[15:8], avs_writedata[23:16], avs_writedata[31:24]};
						datacycle_reg <= 2'd3;
					end
					4'b0011 : begin
						state_reg <= STATE_START;
						txdata_reg <= {CMD_QUAD_WRITE, avs_address[23:2], 2'd0};
						address_reg <= {avs_address[23:2], 2'd0};
						wrdata_reg <= {avs_writedata[7:0], avs_writedata[15:8], {16{1'bx}}};
						datacycle_reg <= 2'd1;
					end
					4'b1100 : begin
						state_reg <= STATE_START;
						txdata_reg <= {CMD_QUAD_WRITE, avs_address[23:2], 2'd2};
						address_reg <= {avs_address[23:2], 2'd2};
						wrdata_reg <= {avs_writedata[23:16], avs_writedata[31:24], {16{1'bx}}};
						datacycle_reg <= 2'd1;
					end
					4'b0001 : begin
						state_reg <= STATE_START;
						txdata_reg <= {CMD_QUAD_WRITE, avs_address[23:2], 2'd0};
						address_reg <= {avs_address[23:2], 2'd0};
						wrdata_reg <= {avs_writedata[7:0], {24{1'bx}}};
						datacycle_reg <= 2'd0;
					end
					4'b0010 : begin
						state_reg <= STATE_START;
						txdata_reg <= {CMD_QUAD_WRITE, avs_address[23:2], 2'd1};
						address_reg <= {avs_address[23:2], 2'd1};
						wrdata_reg <= {avs_writedata[15:8], {24{1'bx}}};
						datacycle_reg <= 2'd0;
					end
					4'b0100 : begin
						state_reg <= STATE_START;
						txdata_reg <= {CMD_QUAD_WRITE, avs_address[23:2], 2'd2};
						address_reg <= {avs_address[23:2], 2'd2};
						wrdata_reg <= {avs_writedata[23:16], {24{1'bx}}};
						datacycle_reg <= 2'd0;
					end
					4'b1000 : begin
						state_reg <= STATE_START;
						txdata_reg <= {CMD_QUAD_WRITE, avs_address[23:2], 2'd3};
						address_reg <= {avs_address[23:2], 2'd3};
						wrdata_reg <= {avs_writedata[31:24], {24{1'bx}}};
						datacycle_reg <= 2'd0;
					end
					default : begin
						txdata_reg <= {32{1'bx}};
						address_reg <= {24{1'bx}};
						wrdata_reg <= {32{1'bx}};
						datacycle_reg <= {2{1'bx}};
					end
					endcase
				end
			end


			// トランザクション開始 

			STATE_START : begin
				if (spi_write_ack_sig || qspi_write_ack_sig) begin
					state_reg <= STATE_ADDR;
					bytecycle_reg <= 2'd2;
					txdata_reg <= {txdata_reg[23:0], {8{1'b0}}};

					if (avs_read_reg) begin
						spi_wrreq_reg <= 1'b1;
					end
					else begin
						qspi_wrreq_reg <= 1'b1;
					end
				end
			end

			STATE_ADDR : begin
				if ((spi_wrreq_reg && spi_write_ack_sig)||(qspi_wrreq_reg && qspi_write_ack_sig)) begin
					if (bytecycle_reg != 0) begin
						bytecycle_reg <= bytecycle_reg - 1'd1;
						txdata_reg <= {txdata_reg[23:0], {8{1'b0}}};
					end
					else begin
						if (avs_read_reg) begin
							state_reg <= STATE_READ;
							bytecycle_reg <= datacycle_reg;
							spi_wrreq_reg <= 1'b0;
							spi_rdreq_reg <= 1'b1;
//							qspi_wrreq_reg <= 1'b0;
//							qspi_rdreq_reg <= 1'b1;
						end
						else begin
							state_reg <= STATE_WRITE;
							txdata_reg <= wrdata_reg;
							bytecycle_reg <= datacycle_reg;
						end
					end
				end
			end


			// 読み出しステート 

			STATE_READ : begin
				if ((spi_rdreq_reg && spi_read_ack_sig)||(qspi_rdreq_reg && qspi_read_ack_sig)) begin
					if (bytecycle_reg != 0) begin
						bytecycle_reg <= bytecycle_reg - 1'd1;
					end
					else begin
						state_reg <= STATE_IDLE;
						spi_rdreq_reg <= 1'b0;
						qspi_rdreq_reg <= 1'b0;
					end
				end
			end

			// 書き込みステート 

			STATE_WRITE : begin
				if ((spi_wrreq_reg && spi_write_ack_sig)||(qspi_wrreq_reg && qspi_write_ack_sig)) begin
					if (bytecycle_reg != 0) begin
						bytecycle_reg <= bytecycle_reg - 1'd1;
						txdata_reg <= {txdata_reg[23:0], {8{1'b0}}};
					end
					else begin
						state_reg <= STATE_IDLE;
						spi_wrreq_reg <= 1'b0;
						qspi_wrreq_reg <= 1'b0;
					end
				end
			end


			// デバイス初期化ステート 

			STATE_INIT : begin
				if (initwaitcount_reg != 0) begin
					initwaitcount_reg <= initwaitcount_reg - 1'd1;
				end
				else begin
//					state_reg <= STATE_INIT_QPI;
					state_reg <= STATE_INIT_SPI;
					txdata_reg <= {CMD_RESET_ENABLE, CMD_RESET, {16{1'bx}}};
					bytecycle_reg <= 2'd1;
				end
			end
/*
			STATE_INIT_QPI : begin
				if (qspi_write_ack_sig) begin
					if (bytecycle_reg != 0) begin
						bytecycle_reg <= bytecycle_reg - 1'd1;
						txdata_reg <= {txdata_reg[23:0], {8{1'b0}}};
					end
					else begin
						state_reg <= STATE_INIT_SPI;
						txdata_reg <= {CMD_RESET_ENABLE, CMD_RESET, CMD_ENTER_QUAD_MODE, {8{1'bx}}};
						bytecycle_reg <= 2'd3;
					end
				end
			end
*/
			STATE_INIT_SPI : begin
				if (spi_write_ack_sig) begin
					if (bytecycle_reg != 0) begin
						bytecycle_reg <= bytecycle_reg - 1'd1;
						txdata_reg <= {txdata_reg[23:0], {8{1'b0}}};
					end
					else begin
						state_reg <= STATE_IDLE;
					end
				end
			end

			endcase
		end
	end



	///// QSPI-PSRAM コントローラインスタンス /////

//	assign spi_command_req_sig = (state_reg == STATE_INIT_SPI);
	assign spi_command_req_sig = (state_reg == STATE_START || state_reg == STATE_INIT_SPI);
	assign spi_write_req_sig = spi_wrreq_reg;
	assign spi_read_req_sig = spi_rdreq_reg;
//	assign qspi_command_req_sig = (state_reg == STATE_START || state_reg == STATE_INIT_QPI);
	assign qspi_command_req_sig = 1'b0;
	assign qspi_write_req_sig = qspi_wrreq_reg;
	assign qspi_read_req_sig = qspi_rdreq_reg;
	assign qspi_wrdata_sig = txdata_reg[31:24];

	peridot_qspi_control #(
		.CS_NEGATE_DELAY		(CS_NEGATE_DELAY),
		.CS_NEGATE_HOLD			(CS_NEGATE_HOLD),
		.SPI_READ_WAIT_CYCLE	(SPI_READ_WAIT_CYCLE),
		.QSPI_READ_WAIT_CYCLE	(QSPI_READ_WAIT_CYCLE),
		.READDATA_LATENCY		(READDATA_LATENCY),
		.DEVICE_FAMILY			(DEVICE_FAMILY)
	)
	u0 (
		.test_sck_count		(test_sck_count),

		.reset				(reset_sig),
		.clock				(clock_sig),
		.outclock			(outclock),

		.spi_command_req	(spi_command_req_sig),
		.spi_write_req		(spi_write_req_sig),
		.spi_write_ack		(spi_write_ack_sig),
		.spi_read_req		(spi_read_req_sig),
		.spi_read_ack		(spi_read_ack_sig),
		.qspi_command_req	(qspi_command_req_sig),
		.qspi_write_req		(qspi_write_req_sig),
		.qspi_write_ack		(qspi_write_ack_sig),
		.qspi_read_req		(qspi_read_req_sig),
		.qspi_read_ack		(qspi_read_ack_sig),
		.idle				(qspi_idle_sig),
		.writedata			(qspi_wrdata_sig),
		.readdata			(qspi_rddata_sig),
		.readdatavalid		(qspi_rddatavalid_sig),

		.qspi_sck			(qspi_sck),
		.qspi_cs_n			(qspi_cs_n),
		.qspi_sio			(qspi_sio)
	);



endmodule
