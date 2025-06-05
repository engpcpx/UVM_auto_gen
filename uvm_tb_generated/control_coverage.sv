class control_coverage extends uvm_subscriber #(control_transaction);
    `uvm_component_utils(control_coverage)
    
    // Coverage groups
    covergroup control_cg;
        
        // Cross coverage
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        control_cg = new();
    endfunction
    
    function void write(control_transaction t);
        control_cg.sample();
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COVERAGE", $sformatf("Functional coverage: %0.2f%%", 
                   control_cg.get_inst_coverage()), UVM_MEDIUM)
    endfunction
endclass