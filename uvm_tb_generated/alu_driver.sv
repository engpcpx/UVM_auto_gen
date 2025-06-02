class alu_driver extends uvm_driver #(alu_transaction);
    `uvm_component_utils(alu_driver)
    
    virtual alu_interface vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual alu_interface)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            alu_transaction tr;
            seq_item_port.get_next_item(tr);
            drive_transaction(tr);
            seq_item_port.item_done();
        end
    endtask
    
    task drive_transaction(alu_transaction tr);
        @(vif.driver_cb);
        vif.driver_cb.logic <= tr.logic;
        vif.driver_cb.logic <= tr.logic;
    endtask
endclass