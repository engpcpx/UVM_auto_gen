class control_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(control_scoreboard)
    
    uvm_analysis_imp #(control_transaction, control_scoreboard) analysis_export;
    
    // Expected results storage
    control_transaction expected_results[$];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction
    
    function void write(control_transaction tr);
        // Store or process the transaction
        expected_results.push_back(tr);
        
        // Compare with actual results
        check_result(tr);
    endfunction
    
    function void check_result(control_transaction actual);
        // Implement your checking logic here
        // This is module-specific and should be customized
        
        // Example for ALU:
        // if (actual.result !== (actual.a + actual.b))
        //     `uvm_error("SCOREBOARD", $sformatf("Mismatch! Expected %0d, Got %0d", 
        //                (actual.a + actual.b), actual.result))
    endfunction
endclass