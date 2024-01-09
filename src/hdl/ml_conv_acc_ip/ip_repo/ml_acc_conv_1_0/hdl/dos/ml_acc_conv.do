onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /tb_ml_acc_conv/DUT0/s00_axi_aclk
add wave -noupdate -label s_TEST_NUMBER /tb_ml_acc_conv/s_TEST_NUMBER
add wave -noupdate -label s00_axi_aresetn /tb_ml_acc_conv/DUT0/s00_axi_aresetn
add wave -noupdate -label m00_axi_aresetn /tb_ml_acc_conv/DUT0/m00_axi_aresetn
add wave -noupdate -group tbis -label tbis_s00_axi_awaddr /tb_ml_acc_conv/tbis_s00_axi_awaddr
add wave -noupdate -expand -group ml_acc_conv -label state /tb_ml_acc_conv/DUT0/state
add wave -noupdate -expand -group S00 -expand -group aw -label S_AXI_AWADDR /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_AWADDR
add wave -noupdate -expand -group S00 -expand -group aw -color Magenta -label S_AXI_AWVALID /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_AWVALID
add wave -noupdate -expand -group S00 -expand -group aw -label S_AXI_AWREADY /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_AWREADY
add wave -noupdate -expand -group S00 -expand -group w -label S_AXI_WDATA -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_WDATA
add wave -noupdate -expand -group S00 -expand -group w -color Magenta -label S_AXI_WVALID /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_WVALID
add wave -noupdate -expand -group S00 -expand -group w -label S_AXI_WREADY /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_WREADY
add wave -noupdate -expand -group S00 -expand -group b -label S_AXI_BRESP /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_BRESP
add wave -noupdate -expand -group S00 -expand -group b -label S_AXI_BVALID /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_BVALID
add wave -noupdate -expand -group S00 -expand -group b -label S_AXI_BREADY /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S_AXI_BREADY
add wave -noupdate -expand -group S00 -label axi_araddr /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/axi_araddr
add wave -noupdate -expand -group S00 -label axi_awaddr /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/axi_awaddr
add wave -noupdate -expand -group S00 -color Magenta -label axi_awready /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/axi_awready
add wave -noupdate -expand -group S00 -label aw_en /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/aw_en
add wave -noupdate -expand -group S00 -color Magenta -label axi_wready /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/axi_wready
add wave -noupdate -expand -group S00 -color {Blue Violet} -label slv_reg_wren /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg_wren
add wave -noupdate -expand -group S00 -label {loc_addr write process} /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/line__258/loc_addr
add wave -noupdate -expand -group S00 -group {User signals} -label S00i_READ_START /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S00i_READ_START
add wave -noupdate -expand -group S00 -group {User signals} -label S00i_READ_ADDR /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S00i_READ_ADDR
add wave -noupdate -expand -group S00 -group {User signals} -label S00o_READ_RESULT -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S00o_READ_RESULT
add wave -noupdate -expand -group S00 -group {User signals} -label S00i_WRITE_START /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S00i_WRITE_START
add wave -noupdate -expand -group S00 -group {User signals} -label S00i_WRITE_ADDR /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S00i_WRITE_ADDR
add wave -noupdate -expand -group S00 -group {User signals} -label S00i_WRITE_DATA -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S00i_WRITE_DATA
add wave -noupdate -expand -group S00 -group {User signals} -label S00o_WRITE_DONE /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/S00o_WRITE_DONE
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg0 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg0
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg1 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg1
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg2 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg2
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg3 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg3
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg9 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg9
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg10 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg10
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg11 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg11
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg19 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg19
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg20 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg20
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg21 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg21
add wave -noupdate -expand -group S00 -expand -group {S00 registers} -label reg31 -radix hexadecimal /tb_ml_acc_conv/DUT0/ml_acc_conv_v1_0_S00_AXI_inst/slv_reg31
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 8} {70 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 191
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {210 ns}
