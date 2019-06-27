
module nios2core (
	clk_clk,
	gpio0_export,
	gpio1_export,
	gpio2_export,
	led7seg_export,
	qspi_sio,
	qspi_sck,
	qspi_ce_n,
	qspi_outclock,
	reset_reset_n,
	syskey_in_port,
	syskey_out_port);	

	input		clk_clk;
	inout	[11:0]	gpio0_export;
	inout	[11:0]	gpio1_export;
	inout	[11:0]	gpio2_export;
	output	[23:0]	led7seg_export;
	inout	[3:0]	qspi_sio;
	output		qspi_sck;
	output		qspi_ce_n;
	input		qspi_outclock;
	input		reset_reset_n;
	input	[2:0]	syskey_in_port;
	output	[2:0]	syskey_out_port;
endmodule
