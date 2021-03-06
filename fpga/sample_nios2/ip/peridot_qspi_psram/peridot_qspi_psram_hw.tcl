# TCL File Generated by Component Editor 17.1
# Mon Apr 29 04:37:29 JST 2019
# DO NOT MODIFY


# 
# peridot_qspi_psram "peridot_qspi_psram" v1.0
#  2019.04.29.04:37:29
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module peridot_qspi_psram
# 
set_module_property DESCRIPTION "QSPI-PSRAM Controller (Beta test ver)"
set_module_property NAME peridot_qspi_psram
set_module_property VERSION 0.9
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "S.OSAFUNE / J-7SYSTEM WORKS LIMITED"
set_module_property DISPLAY_NAME peridot_qspi_psram
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL peridot_qspi_psram
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file peridot_qspi_psram.v VERILOG PATH hdl/peridot_qspi_psram.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter CS_NEGATE_DELAY INTEGER 2
set_parameter_property CS_NEGATE_DELAY DEFAULT_VALUE 2
set_parameter_property CS_NEGATE_DELAY DISPLAY_NAME CS_NEGATE_DELAY
set_parameter_property CS_NEGATE_DELAY TYPE INTEGER
set_parameter_property CS_NEGATE_DELAY UNITS None
set_parameter_property CS_NEGATE_DELAY HDL_PARAMETER true
add_parameter CS_NEGATE_HOLD INTEGER 4
set_parameter_property CS_NEGATE_HOLD DEFAULT_VALUE 4
set_parameter_property CS_NEGATE_HOLD DISPLAY_NAME CS_NEGATE_HOLD
set_parameter_property CS_NEGATE_HOLD TYPE INTEGER
set_parameter_property CS_NEGATE_HOLD UNITS None
set_parameter_property CS_NEGATE_HOLD HDL_PARAMETER true
add_parameter SPI_READ_WAIT_CYCLE INTEGER 6
set_parameter_property SPI_READ_WAIT_CYCLE DEFAULT_VALUE 6
set_parameter_property SPI_READ_WAIT_CYCLE DISPLAY_NAME SPI_READ_WAIT_CYCLE
set_parameter_property SPI_READ_WAIT_CYCLE TYPE INTEGER
set_parameter_property SPI_READ_WAIT_CYCLE UNITS None
set_parameter_property SPI_READ_WAIT_CYCLE HDL_PARAMETER true
add_parameter QSPI_READ_WAIT_CYCLE INTEGER 4
set_parameter_property QSPI_READ_WAIT_CYCLE DEFAULT_VALUE 4
set_parameter_property QSPI_READ_WAIT_CYCLE DISPLAY_NAME QSPI_READ_WAIT_CYCLE
set_parameter_property QSPI_READ_WAIT_CYCLE TYPE INTEGER
set_parameter_property QSPI_READ_WAIT_CYCLE UNITS None
set_parameter_property QSPI_READ_WAIT_CYCLE HDL_PARAMETER true
add_parameter READDATA_LATENCY INTEGER 4
set_parameter_property READDATA_LATENCY DEFAULT_VALUE 4
set_parameter_property READDATA_LATENCY DISPLAY_NAME READDATA_LATENCY
set_parameter_property READDATA_LATENCY TYPE INTEGER
set_parameter_property READDATA_LATENCY UNITS None
set_parameter_property READDATA_LATENCY HDL_PARAMETER true
add_parameter INITIAL_WAIT_CYCLE INTEGER 10
set_parameter_property INITIAL_WAIT_CYCLE DEFAULT_VALUE 10
set_parameter_property INITIAL_WAIT_CYCLE DISPLAY_NAME INITIAL_WAIT_CYCLE
set_parameter_property INITIAL_WAIT_CYCLE TYPE INTEGER
set_parameter_property INITIAL_WAIT_CYCLE UNITS None
set_parameter_property INITIAL_WAIT_CYCLE HDL_PARAMETER true
add_parameter DEVICE_FAMILY string
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY DISPLAY_NAME DEVICE_FAMILY
set_parameter_property DEVICE_FAMILY HDL_PARAMETER true
set_parameter_property DEVICE_FAMILY ENABLED false


# 
# display items
# 


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits SYMBOLS
set_interface_property avalon_slave_0 associatedClock clock_sink
set_interface_property avalon_slave_0 associatedReset reset_sink
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 isMemoryDevice true
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 1
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 avs_address address Input 23
add_interface_port avalon_slave_0 avs_read read Input 1
add_interface_port avalon_slave_0 avs_readdata readdata Output 32
add_interface_port avalon_slave_0 avs_readdatavalid readdatavalid Output 1
add_interface_port avalon_slave_0 avs_write write Input 1
add_interface_port avalon_slave_0 avs_writedata writedata Input 32
add_interface_port avalon_slave_0 avs_byteenable byteenable Input 4
add_interface_port avalon_slave_0 avs_waitrequest waitrequest Output 1
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 1
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink csi_reset reset Input 1


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink csi_clock clk Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock ""
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end qspi_sio sio Bidir 4
add_interface_port conduit_end qspi_sck sck Output 1
add_interface_port conduit_end qspi_cs_n ce_n Output 1
add_interface_port conduit_end outclock outclock Input 1

