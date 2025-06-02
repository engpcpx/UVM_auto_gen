// Agente UVM para alu
// Gerado automaticamente em 2025-06-01

class alu_agent extends uvm_agent;
    
    `uvm_component_utils(alu_agent)
    
    // Componentes
    alu_driver     driver;
    alu_monitor    monitor;
    uvm_sequencer #(alu_transaction) sequencer;
    
    // Configuração
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    
    // Constructor
    function new(string name = "alu_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        monitor = alu_monitor::type_id::create("monitor", this);
        
        if(is_active == UVM_ACTIVE) begin
            driver = alu_driver::type_id::create("driver", this);
            sequencer = uvm_sequencer#(alu_transaction)::type_id::create("sequencer", this);
        end
    endfunction
    
    // Connect phase
    virtual function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass