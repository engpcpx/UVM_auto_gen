class alu_env extends uvm_env;
    `uvm_component_utils(alu_env)
    
    alu_agent agent;
    alu_scoreboard scoreboard;
    alu_coverage coverage;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = alu_agent::type_id::create("agent", this);
        
        scoreboard = alu_scoreboard::type_id::create("scoreboard", this);
        
        coverage = alu_coverage::type_id::create("coverage", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.mon_ap.connect(scoreboard.analysis_export);
        
        agent.monitor.mon_ap.connect(coverage.analysis_export);
    endfunction
endclass