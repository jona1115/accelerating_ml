# accelerating_ml

This project started from CPRE 487 (hardware acceleration for machine learning, ML). In the class, we identified different overheads of an ML operation, explored different ML accelerators, and explored different software and hardware techniques to reduce various overheads. And for the final project of the class, we were able to create our ML accelerator.

Due to time constraints, my group wasn't able to complete the accelerator in time. However, I grew a deep interest in completing it myself during my free time. I am extremely interested in implementing different techniques and seeing firsthand their benefits as well as tradeoffs.

This repo will store the hardware portion of the project. The software portion is ISU IP, hence will be kept private. However, I will explain what I am doing and share the results on my Medium (jonathan-tan.medium.com) blog. Hopefully, anyone interested can recreate this project with ease.

To view benchmark results, implementation, and future ideas, visit my Medium blog (https://jonathan-tan.medium.com). I will post regularly as soon as updates have been made.

# Where are the HDL files?
System: ./vivado/ml_acc_system.tcl

Convolution IP: ./src/hdl/ml_conv_acc_ip/ip_repo/ml_acc_conv_1_0/hdl/*

# Recreating Vivado project (using Vivado 2023.1)

1. Clone the project and go to the system TCL location (./vivado/ml_acc_system.tcl)
2. Open Vivado and cd into ./vivado/
3. Run: source ml_acc_system.tcl
