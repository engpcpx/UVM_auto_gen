interface control_interface;
    // Module signals
    
    // Clocking blocks
    clocking driver_cb @(posedge );
        default input #1 output #1;
    endclocking
    
    modport DRIVER (clocking driver_cb);
    modport MONITOR (input );
endinterface