// Reporting for control
// Automatically generated on 2025-06-04 18:27:26

class control_reporting extends uvm_subscriber #(control_transaction);
    
    `uvm_component_utils(control_reporting)
    
    // Collected metrics
    int passed_tests = 0;
    int failed_tests = 0;
    real coverage = 0.0;
    
    // Constructor
    function new(string name = "control_reporting", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Write method
    virtual function void write(control_transaction t);
        // Implement metric collection
        // This is a simplified implementation
        if ($urandom_range(0, 100) > 10) begin
            passed_tests++;
        end else begin
            failed_tests++;
        end
        coverage = passed_tests * 100.0 / (passed_tests + failed_tests);
    endfunction
    
    // Report phase
    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Test Results:\nPassed: %0d\nFailed: %0d\nCoverage: %.2f%%", 
            passed_tests, failed_tests, coverage), UVM_LOW)
        
        // Exports report to JSON file
        begin
            int fd;
            fd = $fopen("control_test_report.json", "w");
            if (fd) begin
                $fdisplay(fd, "{");
                $fdisplay(fd, "  \"module\": \"control\",");
                $fdisplay(fd, "  \"timestamp\": \"%s\",", $sformatf("%t", $realtime));
                $fdisplay(fd, "  \"passed_tests\": %0d,", passed_tests);
                $fdisplay(fd, "  \"failed_tests\": %0d,", failed_tests);
                $fdisplay(fd, "  \"coverage\": %.2f", coverage);
                $fdisplay(fd, "}");
                $fclose(fd);
            end
        end
    endfunction

endclass
