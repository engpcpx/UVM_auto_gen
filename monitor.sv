class alu_monitor extends uvm_monitor;
    `uvm_component_utils(alu_monitor)
    
    virtual alu_interface vif;
    uvm_analysis_port #(alu_transaction) mon_ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_ap = new("mon_ap", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual alu_interface)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            alu_transaction tr;
            @(vif.monitor_cb);
            sample_transaction(tr);
            mon_ap.write(tr);
        end
    endtask
    
    task sample_transaction(output alu_transaction tr);
        tr = alu_transaction::type_id::create("tr");
        tr.logic = vif.monitor_cb.logic;
        tr.logic = vif.monitor_cb.logic;
        tr.logic = vif.monitor_cb.logic;
        tr.logic = vif.monitor_cb.logic;
    endtask
endclass