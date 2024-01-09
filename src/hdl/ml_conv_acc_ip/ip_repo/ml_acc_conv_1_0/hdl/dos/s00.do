onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CLK /tb_s00/DUT0/S_AXI_ACLK
add wave -noupdate -label S_AXI_ARESETN /tb_s00/s_S_AXI_ARESETN
add wave -noupdate -label {Test #} -radix decimal /tb_s00/s_TEST_NUMBER
add wave -noupdate -expand -group {Read stuff} -label s_S00i_READ_START /tb_s00/s_S00i_READ_START
add wave -noupdate -expand -group {Read stuff} -label s_S00i_READ_ADDR -radix binary /tb_s00/s_S00i_READ_ADDR
add wave -noupdate -expand -group {Read stuff} -label s_S00o_READ_RESULT -radix hexadecimal /tb_s00/s_S00o_READ_RESULT
add wave -noupdate -expand -group {Write Stuff} -label s_S00i_WRITE_START /tb_s00/s_S00i_WRITE_START
add wave -noupdate -expand -group {Write Stuff} -label s_S00i_WRITE_ADDR -radix binary /tb_s00/s_S00i_WRITE_ADDR
add wave -noupdate -expand -group {Write Stuff} -label s_S00i_WRITE_DATA -radix hexadecimal /tb_s00/s_S00i_WRITE_DATA
add wave -noupdate -expand -group {Write Stuff} -label s_S00o_WRITE_DONE /tb_s00/s_S00o_WRITE_DONE
add wave -noupdate -expand -group internals /tb_s00/DUT0/slv_reg_rden
add wave -noupdate -expand -group internals /tb_s00/DUT0/slv_reg_wren
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_s00/DUT0/slv_reg0
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_s00/DUT0/slv_reg1
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_s00/DUT0/slv_reg2
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_s00/DUT0/slv_reg3
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_s00/DUT0/slv_reg4
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_s00/DUT0/slv_reg5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {160 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 269
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
WaveRestoreZoom {0 ns} {260 ns}
