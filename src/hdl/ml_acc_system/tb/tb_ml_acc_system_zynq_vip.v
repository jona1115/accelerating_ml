/* # ########################################################################
# Copyright (C) 2019, Xilinx Inc - All rights reserved

# Licensed under the Apache License, Version 2.0 (the "License"). You may
# not use this file except in compliance with the License. A copy of the
# License is located at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
# ######################################################################## */

// Modified by Jonathan Tan 1/8/2024 to test ml_acc_system

`timescale 1ns / 1ps

module tb;
    reg tb_ACLK;
    reg tb_ARESETn;
   
    wire temp_clk;
    wire temp_rstn; 
   
    reg [31:0] read_data;
    reg resp;

    reg test;
    
    initial 
    begin       
        tb_ACLK = 1'b0;
    end
    
    //------------------------------------------------------------------------
    // Simple Clock Generator
    //------------------------------------------------------------------------
    
    always #10 tb_ACLK = !tb_ACLK;
       
    integer sanity_var;
    integer i;
    
    initial
    begin
        assign sanity_var = 888;
        
        assign test = 1'b0;
    
        $display ("running the tb");

        tb_ARESETn = 1'b0;              // Clear the reset signal
        repeat(10)@(posedge tb_ACLK);   // Wait for 10 cycles (or +ve edges)
        tb_ARESETn = 1'b1;              // Set the reset signal
        @(posedge tb_ACLK);             // Wait for the next +ve edge before proceeding

        repeat(5) @(posedge tb_ACLK);

        // Reset the PL
        tb.DUT_zynq_sys.design_1_i.processing_system.inst.fpga_soft_reset(32'h1);
        tb.DUT_zynq_sys.design_1_i.processing_system.inst.fpga_soft_reset(32'h0);

		#200 // This waits x unit of time, is it ns?

        // Write dummy data to Weight BRAM
        for (i = 0; i < 25; i = i + 1) begin
            tb.DUT_zynq_sys.design_1_i.processing_system.inst.write_data(32'h42000000 + i*4, 4, -1*i**3+3*i**2+129, resp);
            $display ("Wrote %d to address 0x%x (in Weight BRAM).", -1*i**3+3*i**2+129, 32'h42000000 + i);
        end

        // Write dummy data to Input BRAM
        for (i = 0; i < 25; i = i + 1) begin
            tb.DUT_zynq_sys.design_1_i.processing_system.inst.write_data(32'h40000000 + i*4, 4, -2*i**3+30*i**2+231, resp);
            $display ("Wrote %d to address 0x%x (in Input BRAM).", -2*i**3+30*i**2+231, 32'h40000000 + i);
        end

        assign test = 1'b1;

        // This does this: "Xil_Out32(0x43C00000+4*10, 0x00000001);" (write 1 to 0x43C00000+4*10)
        //                                                               addr      size   data      response 
        tb.DUT_zynq_sys.design_1_i.processing_system.inst.write_data(32'h43C00028, 4, 32'h00000001, resp);
        // tb.DUT_zynq_sys.design_1_i.processing_system.inst.write_data(32'h43C00028, 4, 32'hDEADBEEF, resp);
        $display ("Wrote 1 to reg 10!");

		#2850

        // // Read from S00 reg0 and make sure is the correct value
        // tb.DUT_zynq_sys.design_1_i.processing_system.inst.read_data(32'h43C00000, 4, read_data, resp);
		// #200
        // if(read_data == 32'hD00D1234) begin
        //    $display ("Conv wrote 0xD00D1234 to reg0 success!");
        // end
        // else begin
        //    $display ("Conv wrote 0xD00D1234 to reg0 failed!");
        // end

        // // Read from OUTACT BRAM (offset 0) and make sure is the correct value
        // tb.DUT_zynq_sys.design_1_i.processing_system.inst.read_data(32'h44000000, 4, read_data, resp);
		// #200
        // if(read_data == 32'hB1A0CA0A) begin
        //    $display ("Conv wrote 0xB1A0CA0A to outact BRAM (offset 0) success!");
        // end
        // else begin
        //    $display ("Conv wrote 0xB1A0CA0A to outact BRAM (offset 0) failed!");
        // end

        #30000
    
        $display ("Simulation completed");
        $stop;  // This is like a breakpoint
    end

    assign temp_clk = tb_ACLK;
    assign temp_rstn = tb_ARESETn;
   
design_1_wrapper DUT_zynq_sys
(
    .DDR_addr(),
    .DDR_ba(),
    .DDR_cas_n(),
    .DDR_ck_n(),
    .DDR_ck_p(),
    .DDR_cke(),
    .DDR_cs_n(),
    .DDR_dm(),
    .DDR_dq(),
    .DDR_dqs_n(),
    .DDR_dqs_p(),
    .DDR_odt(),
    .DDR_ras_n(),
    .DDR_reset_n(),
    .DDR_we_n(),
    .FIXED_IO_ddr_vrn(),
    .FIXED_IO_ddr_vrp(),
    .FIXED_IO_mio(),
    .FIXED_IO_ps_clk(temp_clk),
    .FIXED_IO_ps_porb(temp_rstn),
    .FIXED_IO_ps_srstb(temp_rstn)
);

endmodule