	component nios2core is
		port (
			clk_clk         : in    std_logic                     := 'X';             -- clk
			gpio0_export    : inout std_logic_vector(11 downto 0) := (others => 'X'); -- export
			gpio1_export    : inout std_logic_vector(11 downto 0) := (others => 'X'); -- export
			gpio2_export    : inout std_logic_vector(11 downto 0) := (others => 'X'); -- export
			led7seg_export  : out   std_logic_vector(23 downto 0);                    -- export
			qspi_sio        : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- sio
			qspi_sck        : out   std_logic;                                        -- sck
			qspi_ce_n       : out   std_logic;                                        -- ce_n
			qspi_outclock   : in    std_logic                     := 'X';             -- outclock
			reset_reset_n   : in    std_logic                     := 'X';             -- reset_n
			syskey_in_port  : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- in_port
			syskey_out_port : out   std_logic_vector(2 downto 0)                      -- out_port
		);
	end component nios2core;

	u0 : component nios2core
		port map (
			clk_clk         => CONNECTED_TO_clk_clk,         --     clk.clk
			gpio0_export    => CONNECTED_TO_gpio0_export,    --   gpio0.export
			gpio1_export    => CONNECTED_TO_gpio1_export,    --   gpio1.export
			gpio2_export    => CONNECTED_TO_gpio2_export,    --   gpio2.export
			led7seg_export  => CONNECTED_TO_led7seg_export,  -- led7seg.export
			qspi_sio        => CONNECTED_TO_qspi_sio,        --    qspi.sio
			qspi_sck        => CONNECTED_TO_qspi_sck,        --        .sck
			qspi_ce_n       => CONNECTED_TO_qspi_ce_n,       --        .ce_n
			qspi_outclock   => CONNECTED_TO_qspi_outclock,   --        .outclock
			reset_reset_n   => CONNECTED_TO_reset_reset_n,   --   reset.reset_n
			syskey_in_port  => CONNECTED_TO_syskey_in_port,  --  syskey.in_port
			syskey_out_port => CONNECTED_TO_syskey_out_port  --        .out_port
		);

