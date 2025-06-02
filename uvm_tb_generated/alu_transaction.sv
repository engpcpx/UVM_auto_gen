class alu_transaction extends uvm_sequence_item;
    `uvm_object_utils(alu_transaction)
    
    // Transaction fields
    rand logic 1 logic;
    rand logic 1 logic;
    
    logic 1 logic;
    logic 1 logic;
    
    // Constraints
    constraint reasonable_values {
        logic inside {0, 1};
        logic inside {0, 1};
        
    }
    
    function new(string name = "alu_transaction");
        super.new(name);
    endfunction
    
    function string convert2string();
        return $sformatf("logic=%0d ""logic=%0d ""logic=%0d ""logic=%0d ", logic, logic, logic, logic);
    endfunction
endclass