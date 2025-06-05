class control_test extends uvm_test;
    `uvm_component_utils(control_test)
    
    control_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = control_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        // Scenario selection
        string scenarios = "smoke,random,corner,reset,stress,error,functional,performance";
        
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
        control_sequence seq = control_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
    endtask
    
    task run_random_tests();
        // Random stimulus tests
        repeat(100) begin
            control_sequence seq = control_sequence::type_id::create("seq");
            assert(seq.randomize());
            seq.start(env.agent.sequencer);
        end
    endtask
endclass