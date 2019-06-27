// ===================================================================
// TITLE : PERIDOT-NGS / QSPI PSRAM state controller
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

`default_nettype none

module peridot_qspi_control #(
	parameter CS_NEGATE_DELAY = 2,			// tCHD cycle
	parameter CS_NEGATE_HOLD = 5-1,			// tCPH cycle
	parameter SPI_READ_WAIT_CYCLE = 8-1,	// SPI Fast Read wait cycle
	parameter QSPI_READ_WAIT_CYCLE = 6-1,	// QSPI Fast Read wait cycle
	parameter READDATA_LATENCY = 4-1,
	parameter DEVICE_FAMILY	= "Cyclone III"
//	parameter DEVICE_FAMILY	= "Cyclone IV E"
//	parameter DEVICE_FAMILY	= "Cyclone 10 LP"
//	parameter DEVICE_FAMILY	= "MAX 10"
) (
	output wire [7:0]	test_sck_count,

	// clock & reset
	input wire			reset,				// Async reset
	input wire			clock,				// core and SIO latch clock
	input wire			outclock,			// output clock (shifted phase equivalent to tco)

	// QSPI interface
	input wire			spi_command_req,
	input wire			spi_write_req,
	output wire			spi_write_ack,
	input wire			spi_read_req,
	output wire			spi_read_ack,
	input wire			qspi_command_req,
	input wire			qspi_write_req,
	output wire			qspi_write_ack,
	input wire			qspi_read_req,
	output wire			qspi_read_ack,
	output wire			idle,

	input wire  [7:0]	writedata,
	output wire [7:0]	readdata,
	output wire			readdatavalid,

	// QSPI export
	output wire			qspi_sck,
	output wire			qspi_cs_n,
	inout wire  [3:0]	qspi_sio
);


/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */

	localparam	STATE_IO_IDLE		= 5'd0,
				STATE_IO_SPI_WRITE	= 5'd1,
				STATE_IO_SPI_WAIT	= 5'd2,
				STATE_IO_SPI_READ	= 5'd3,
				STATE_IO_QSPI_WRITE	= 5'd4,
				STATE_IO_QSPI_WAIT	= 5'd5,
				STATE_IO_QSPI_READ	= 5'd6,
				STATE_IO_CLOSE		= 5'd31;

	localparam	TRANS_SPI_CYCLE 	= 4'd7;
	localparam	TRANS_QSPI_CYCLE	= 4'd1;


/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
	wire			reset_sig = reset;			// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
	wire			clock_sig = clock;			// モジュール内部駆動クロック 

	wire [7:0]		wrdata_sig, rddata_sig;
	wire			rddatavalid_sig, read_byteena_sig;
	wire			req_command_spi_sig, req_command_qspi_sig;
	wire			req_write_spi_sig, ack_write_spi_sig;
	wire			req_read_spi_sig, ack_read_spi_sig;
	wire			req_write_qspi_sig, ack_write_qspi_sig;
	wire			req_read_qspi_sig, ack_read_qspi_sig;

	reg  [4:0]		state_io_reg;
	reg  [3:0]		cyclecount_reg;
	reg				trans_qspi_reg;
	reg  [7:0]		wrdata_reg, rddata_reg;
	reg  [7:0]		rddatavalid_reg;
	reg				sck_ena_reg;
	reg				cs_ena_reg;
	reg  [3:0]		oe_reg, dout_reg;
	wire [3:0]		phy_din_sig;


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テスト記述 ============== */



/* ===== モジュール構造記述 ============== */

	///// ポートマッピング /////

	assign req_command_spi_sig = spi_command_req;
	assign req_write_spi_sig = spi_write_req;
	assign req_read_spi_sig = spi_read_req;
	assign req_write_qspi_sig = qspi_write_req;
	assign req_read_qspi_sig = qspi_read_req;

	assign req_command_qspi_sig = qspi_command_req;
	assign spi_write_ack = ack_write_spi_sig;
	assign spi_read_ack = ack_read_spi_sig;
	assign qspi_write_ack = ack_write_qspi_sig;
	assign qspi_read_ack = ack_read_qspi_sig;

	assign wrdata_sig = writedata;
	
	assign readdata = rddata_sig;
	assign readdatavalid = rddatavalid_sig;

	assign idle = (state_io_reg == STATE_IO_IDLE);


	///// QSPI-PSRAM プロトコルコントローラ /////

	assign ack_write_spi_sig = (state_io_reg == STATE_IO_SPI_WRITE && cyclecount_reg == TRANS_SPI_CYCLE);
	assign ack_read_spi_sig = (state_io_reg == STATE_IO_SPI_READ && cyclecount_reg == TRANS_SPI_CYCLE);
	assign ack_write_qspi_sig = (state_io_reg == STATE_IO_QSPI_WRITE && cyclecount_reg == TRANS_QSPI_CYCLE);
	assign ack_read_qspi_sig = (state_io_reg == STATE_IO_QSPI_READ && cyclecount_reg == TRANS_QSPI_CYCLE);

	assign read_byteena_sig = (
				(state_io_reg == STATE_IO_SPI_READ && cyclecount_reg == 0) || 
				(state_io_reg == STATE_IO_QSPI_READ && cyclecount_reg == 0)
			);

	assign rddata_sig = rddata_reg;
	assign rddatavalid_sig = rddatavalid_reg[READDATA_LATENCY];


	always @(posedge clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			state_io_reg <= STATE_IO_IDLE;
			cyclecount_reg <= 1'd0;
			trans_qspi_reg <= 1'b0;
			rddatavalid_reg <= 8'b00000000;
			sck_ena_reg <= 1'b0;
			cs_ena_reg <= 1'b0;
			oe_reg <= 4'b0000;
		end
		else begin

		// リードデータ処理 

			rddatavalid_reg <= {rddatavalid_reg[6:0], read_byteena_sig};

			if (trans_qspi_reg) begin
				rddata_reg <= {rddata_reg[3:0], phy_din_sig};
			end
			else begin
				rddata_reg <= {rddata_reg[6:0], phy_din_sig[1]};
			end


		// 制御ステートマシン 

			case (state_io_reg)

			// トランザクション受付 

			STATE_IO_IDLE : begin
				if (cyclecount_reg == 0) begin
					if (req_command_qspi_sig) begin
						state_io_reg <= STATE_IO_QSPI_WRITE;
						cyclecount_reg <= TRANS_QSPI_CYCLE;
						trans_qspi_reg <= 1'b1;
						wrdata_reg <= wrdata_sig;
						sck_ena_reg <= 1'b1;
						cs_ena_reg <= 1'b1;
						oe_reg <= 4'b1111;
						dout_reg <= 4'b1111;
					end
					else if (req_command_spi_sig) begin
						state_io_reg <= STATE_IO_SPI_WRITE;
						cyclecount_reg <= TRANS_SPI_CYCLE;
						trans_qspi_reg <= 1'b0;
						wrdata_reg <= wrdata_sig;
						sck_ena_reg <= 1'b1;
						cs_ena_reg <= 1'b1;
						oe_reg <= 4'b0001;
						dout_reg <= 4'b1111;
					end
				end
				else begin
					cyclecount_reg <= cyclecount_reg - 1'd1;
				end
			end

			// SPIモードで1バイト送信 

			STATE_IO_SPI_WRITE : begin
				dout_reg <= {{3{1'bx}}, wrdata_reg[7]};

				if (cyclecount_reg != 0) begin
					cyclecount_reg <= cyclecount_reg - 1'd1;
					wrdata_reg <= {wrdata_reg[6:0], 1'b0};
				end
				else begin
					if (req_write_spi_sig) begin
						cyclecount_reg <= TRANS_SPI_CYCLE;
						wrdata_reg <= wrdata_sig;
					end
					else if (req_write_qspi_sig) begin
						state_io_reg <= STATE_IO_QSPI_WRITE;
						cyclecount_reg <= TRANS_QSPI_CYCLE;
						trans_qspi_reg <= 1'b1;
						wrdata_reg <= wrdata_sig;
						oe_reg <= 4'b1111;
					end
					else if (req_read_spi_sig) begin
						state_io_reg <= STATE_IO_SPI_WAIT;
						cyclecount_reg <= SPI_READ_WAIT_CYCLE[3:0];
					end
					else begin
						state_io_reg <= STATE_IO_CLOSE;
						cyclecount_reg <= CS_NEGATE_DELAY[3:0];
						sck_ena_reg <= 1'b0;
					end
				end
			end

			// SPIリードダミーサイクル 

			STATE_IO_SPI_WAIT : begin
				if (cyclecount_reg != 0) begin
					cyclecount_reg <= cyclecount_reg - 1'd1;
				end
				else begin
					state_io_reg <= STATE_IO_SPI_READ;
					cyclecount_reg <= TRANS_SPI_CYCLE;
				end
			end

			// SPIモードで1バイト受信 

			STATE_IO_SPI_READ : begin
				if (cyclecount_reg != 0) begin
					cyclecount_reg <= cyclecount_reg - 1'd1;
				end
				else begin
					if (req_read_spi_sig) begin
						cyclecount_reg <= TRANS_SPI_CYCLE;
					end
					else begin
						state_io_reg <= STATE_IO_CLOSE;
						cyclecount_reg <= CS_NEGATE_DELAY[3:0];
						sck_ena_reg <= 1'b0;
					end
				end
			end

			// QSPIモードで1バイト送信 

			STATE_IO_QSPI_WRITE : begin
				dout_reg <= wrdata_reg[7:4];

				if (cyclecount_reg != 0) begin
					cyclecount_reg <= cyclecount_reg - 1'd1;
					wrdata_reg <= {wrdata_reg[3:0], 4'b0000};
				end
				else begin
					if (req_write_qspi_sig) begin
						cyclecount_reg <= TRANS_QSPI_CYCLE;
						wrdata_reg <= wrdata_sig;
					end
					else if (req_read_qspi_sig) begin
						state_io_reg <= STATE_IO_QSPI_WAIT;
						cyclecount_reg <= QSPI_READ_WAIT_CYCLE[3:0];
					end
					else begin
						state_io_reg <= STATE_IO_CLOSE;
						cyclecount_reg <= CS_NEGATE_DELAY[3:0];
						sck_ena_reg <= 1'b0;
					end
				end
			end

			// QSPIリードダミーサイクル 

			STATE_IO_QSPI_WAIT : begin
				oe_reg <= 4'b0000;

				if (cyclecount_reg != 0) begin
					cyclecount_reg <= cyclecount_reg - 1'd1;
				end
				else begin
					state_io_reg <= STATE_IO_QSPI_READ;
					cyclecount_reg <= TRANS_QSPI_CYCLE;
				end
			end

			// QSPIモードで1バイト受信 

			STATE_IO_QSPI_READ : begin
				if (cyclecount_reg != 0) begin
					cyclecount_reg <= cyclecount_reg - 1'd1;
				end
				else begin
					if (req_read_qspi_sig) begin
						cyclecount_reg <= TRANS_QSPI_CYCLE;
					end
					else begin
						state_io_reg <= STATE_IO_CLOSE;
						cyclecount_reg <= CS_NEGATE_DELAY[3:0];
						sck_ena_reg <= 1'b0;
					end
				end
			end

			// デバイスクローズ処理 

			STATE_IO_CLOSE : begin
				if (cyclecount_reg != 0) begin
					cyclecount_reg <= cyclecount_reg - 1'd1;
				end
				else begin
					state_io_reg <= STATE_IO_IDLE;
					cyclecount_reg <= CS_NEGATE_HOLD[3:0];
					cs_ena_reg <= 1'b0;
					oe_reg <= 4'b0000;
				end
			end

			endcase
		end
	end



	///// QSPI-PSRAM 物理層インスタンス /////

	peridot_qspi_phy #(
		.DEVICE_FAMILY	(DEVICE_FAMILY)
	)
	u_phy (
		.test_sck_count	(test_sck_count),

		.clock			(clock_sig),
		.outclock		(outclock),

		.sck_enable		(sck_ena_reg),
		.cs_enable		(cs_ena_reg),
		.sio_outenable	(oe_reg),
		.sio_outdata	(dout_reg),
		.sio_indata		(phy_din_sig),

		.qspi_sck		(qspi_sck),
		.qspi_cs_n		(qspi_cs_n),
		.qspi_sio		(qspi_sio)
	);



endmodule
