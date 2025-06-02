interface alu_interface;
    // Module signals
    logic 1 logic;
    logic 1 logic;
    logic 1 logic;
    logic 1 logic;
    
    // Clocking blocks
    clocking driver_cb @(posedge );
        default input #1 output #1;
        output logic;
        output logic;
        input logic;
        input logic;
    endclocking
    
    modport DRIVER (clocking driver_cb);
    modport MONITOR (input logic, logic, logic, logic);
endinterface