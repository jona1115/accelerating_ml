# Prerun: cd C:/vivado_workspace/accelerating_ml/vivado/
# tcl command: source updateIp_genOutProd.tcl
# This tcl script is for updating block diagram ml_acc_conv ip.
# This script is only compatible with Jonathan's computer which makes me think.. why tf did I not gitignored it?

# Save the waveform first
# save_wave_config {C:/vivado_workspace/accelerating_ml/src/hdl/ml_acc_system/dos/tb_ml_acc_system.wcfg}

open_bd_design {C:/vivado_workspace/accelerating_ml/vivado/ml_acc_system/ml_acc_system.srcs/sources_1/bd/design_1/design_1.bd}
update_ip_catalog -rebuild -scan_changes
report_ip_status -name ip_status
upgrade_ip -vlnv Jonathan:user:ml_acc_conv:1.0 [get_ips  design_1_ml_acc_conv_0_0] -log ip_upgrade.log
export_ip_user_files -of_objects [get_ips design_1_ml_acc_conv_0_0] -no_script -sync -force -quiet
generate_target all [get_files  C:/vivado_workspace/accelerating_ml/vivado/ml_acc_system/ml_acc_system.srcs/sources_1/bd/design_1/design_1.bd]
report_ip_status -name ip_status 
save_bd_design