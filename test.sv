class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)
    
    alu_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = alu_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        // Scenario selection
        string scenarios = "smoke,random,corner";
        
        phase.raise_objection(this);
        
        if ($test$plusargs("SMOKE") || scenarios.contains("smoke")) begin
            `uvm_info("TEST", "Running smoke tests", UVM_LOW)
            run_smoke_tests();
        end
        
        if ($test$plusargs("RANDOM") || scenarios.contains("random")) begin
            `uvm_info("TEST", "Running random tests", UVM_LOW)
            run_random_tests();
        end
        
        phase.drop_objection(this);
    endtask
    
    task run_smoke_tests();
        // Basic functionality tests
        alu_sequence seq = alu_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
    endtask
    
    task run_random_tests();
        // Random stimulus tests
        repeat(100) begin
            alu_sequence seq = alu_sequence::type_id::create("seq");
            assert(seq.randomize());
            seq.start(env.agent.sequencer);
        end
    endtask
endclass