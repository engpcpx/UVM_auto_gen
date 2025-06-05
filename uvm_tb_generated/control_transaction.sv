class control_transaction extends uvm_sequence_item;
    `uvm_object_utils(control_transaction)
    
    // Transaction fields
    
    
    // Constraints
    constraint reasonable_values {
        
    }
    
    function new(string name = "control_transaction");
        super.new(name);
    endfunction
    
    function string convert2string();
        return $sformatf();
    endfunction
endclass