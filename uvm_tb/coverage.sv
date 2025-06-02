class alu_coverage extends uvm_subscriber #(alu_transaction);
    `uvm_component_utils(alu_coverage)
    
    // Coverage groups
    covergroup alu_cg;
        logic_cp: coverpoint tr.logic {
            bins logic_vals[] = {[0:2**$size(tr.logic)-1]};
        }
        logic_cp: coverpoint tr.logic {
            bins logic_vals[] = {[0:2**$size(tr.logic)-1]};
        }
        
        // Cross coverage
        logic_logic_cross: 
            cross logic_cp, logic_cp;
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        alu_cg = new();
    endfunction
    
    function void write(alu_transaction t);
        alu_cg.sample();
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COVERAGE", $sformatf("Functional coverage: %0.2f%%", 
                   alu_cg.get_inst_coverage()), UVM_MEDIUM)
    endfunction
endclass