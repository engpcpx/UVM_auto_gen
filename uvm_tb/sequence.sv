// Sequências base para alu
// Gerado automaticamente em 2025-06-01

class alu_basic_sequence extends uvm_sequence #(alu_transaction);
    
    `uvm_object_utils(alu_basic_sequence)
    
    // Constructor
    function new(string name = "alu_basic_sequence");
        super.new(name);
    endfunction
    
    // Body task
    virtual task body();
        alu_transaction tx;
        
        repeat(10) begin
            tx = alu_transaction::type_id::create("tx");
            start_item(tx);
            if(!tx.randomize())
                `uvm_error("SEQ", "Randomization failed")
            finish_item(tx);
        end
    endtask

endclass

class alu_random_sequence extends alu_basic_sequence;
    
    `uvm_object_utils(alu_random_sequence)
    
    // Constraints adicionais
    constraint extended_ranges {
        // Exemplo: expande faixas de valores aleatórios
    }
    
    function new(string name = "alu_random_sequence");
        super.new(name);
    endfunction

endclass