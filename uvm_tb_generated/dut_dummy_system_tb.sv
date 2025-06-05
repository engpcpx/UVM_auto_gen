// Testbench sistêmico para dut_dummy
    // Gerado automaticamente em 2025-06-04 23:10:28

    module dut_dummy_system_tb;
        // Clock e reset
        logic clk;
        logic reset_n;
        
        // Interfaces para todos os submodules
        uvm_test_if uvm_test_if();
        
        // Instância do DUT
        dut_dummy dut (
            .clk(clk),
            .reset_n(reset_n),
        );

        // Geração de clock
        initial begin
            clk = 0;
            forever #10 clk = ~clk;
        end
        
        // Ambiente UVM
        initial begin
            // Configura as interfaces
            uvm_config_db#(virtual dut_dummy_if)::set(null, "*", "dut_vif", dut_if);
            uvm_config_db#(virtual uvm_test_if)::set(null, "*", "uvm_test_vif", uvm_test_if);
            
            // Inicia o teste
            run_test("dut_dummy_system_test");
        end
    endmodule
    