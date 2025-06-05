// Ambiente UVM sistêmico para dut_dummy
    // Gerado automaticamente em 2025-06-04 23:10:28

    class dut_dummy_system_env extends uvm_env;
        // Agentes para cada submodule
        uvm_test_agent uvm_test_agent;
        
        // Scoreboard sistêmico
        dut_dummy_system_scoreboard scoreboard;
        
        `uvm_component_utils(dut_dummy_system_env)
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            // Cria agentes
            uvm_test_agent = uvm_test_agent::type_id::create("uvm_test_agent", this);
            
            // Cria scoreboard
            scoreboard = dut_dummy_system_scoreboard::type_id::create("scoreboard", this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            
            // Conecta os agentes ao scoreboard
            uvm_test_agent.monitor.analysis_port.connect(scoreboard.uvm_test_export);
        endfunction
    endclass
    