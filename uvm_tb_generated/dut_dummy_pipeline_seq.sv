// Sequência de verificação de pipeline para dut_dummy
    // Gerado automaticamente em 2025-06-04 23:10:28

    class dut_dummy_pipeline_seq extends uvm_sequence;
        // Sequências para cada estágio
        fetch_seq fetch;
        decode_seq decode;
        execute_seq execute;
        
        `uvm_object_utils(dut_dummy_pipeline_seq)
        
        function new(string name = "dut_dummy_pipeline_seq");
            super.new(name);
        endfunction
        
        task body();
            // Executa sequências em paralelo para simular o pipeline
            fork
                fetch.start(fetch_agent.sequencer);
                decode.start(decode_agent.sequencer);
                execute.start(execute_agent.sequencer);
            join
        endtask
    endclass
    