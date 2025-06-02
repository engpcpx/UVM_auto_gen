`timescale 1ns/1ps

module top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // Clock and reset generation
    logic clk;
    logic rst;
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        #20 rst = 0;
    end
    
    // Instantiate interface
    alu_interface dut_if(clk, rst);
    
    // Instantiate DUT
    alu dut (
        .logic(dut_if.logic),        .logic(dut_if.logic),        .logic(dut_if.logic),        .logic(dut_if.logic)    );
    
    initial begin
        // Set interface in config DB
        uvm_config_db#(virtual alu_interface)::set(null, "*", "vif", dut_if);
        
        // Set test specific configs
        uvm_config_db#(int)::set(null, "*", "num_tests", 100);
        
        // Run test
        run_test("alu_test");
    end
    
    initial begin
        #10000;
        $display("Simulation timeout reached");
        $finish;
    end
endmodule