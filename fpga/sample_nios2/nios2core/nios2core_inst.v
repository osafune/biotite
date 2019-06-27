	nios2core u0 (
		.clk_clk         (<connected-to-clk_clk>),         //     clk.clk
		.gpio0_export    (<connected-to-gpio0_export>),    //   gpio0.export
		.gpio1_export    (<connected-to-gpio1_export>),    //   gpio1.export
		.gpio2_export    (<connected-to-gpio2_export>),    //   gpio2.export
		.led7seg_export  (<connected-to-led7seg_export>),  // led7seg.export
		.qspi_sio        (<connected-to-qspi_sio>),        //    qspi.sio
		.qspi_sck        (<connected-to-qspi_sck>),        //        .sck
		.qspi_ce_n       (<connected-to-qspi_ce_n>),       //        .ce_n
		.qspi_outclock   (<connected-to-qspi_outclock>),   //        .outclock
		.reset_reset_n   (<connected-to-reset_reset_n>),   //   reset.reset_n
		.syskey_in_port  (<connected-to-syskey_in_port>),  //  syskey.in_port
		.syskey_out_port (<connected-to-syskey_out_port>)  //        .out_port
	);

