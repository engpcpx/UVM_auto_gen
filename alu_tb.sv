module alu_tb;
    parameter WIDTH = 32;
    
    logic [WIDTH-1:0] a, b;
    logic [2:0] alu_control;
    logic [WIDTH-1:0] result;
    logic zero;
    
    // Instanciação da ALU
    alu #(WIDTH) dut (.*);
    
    initial begin
        // Teste de adição
        a = 5; b = 3; alu_control = 3'b000;
        #10;
        $display("ADD: %d + %d = %d (zero=%b)", a, b, result, zero);
        
        // Teste de subtração
        a = 10; b = 4; alu_control = 3'b001;
        #10;
        $display("SUB: %d - %d = %d (zero=%b)", a, b, result, zero);
        
        // Teste AND
        a = 8'hAA; b = 8'h0F; alu_control = 3'b010;
        #10;
        $display("AND: %h & %h = %h (zero=%b)", a, b, result, zero);
        
        // Teste OR
        a = 8'hAA; b = 8'h0F; alu_control = 3'b011;
        #10;
        $display("OR:  %h | %h = %h (zero=%b)", a, b, result, zero);
        
        // Teste XOR
        a = 8'hAA; b = 8'hFF; alu_control = 3'b100;
        #10;
        $display("XOR: %h ^ %h = %h (zero=%b)", a, b, result, zero);
        
        // Teste deslocamento à esquerda
        a = 8'b0000_0001; b = 2; alu_control = 3'b101;
        #10;
        $display("SHL: %b << %d = %b (zero=%b)", a, b, result, zero);
        
        // Finaliza a simulação
        #10 $finish;
    end
endmodule