`timescale 1ns/1ps

module alu #(parameter WIDTH=32) (
    input  logic [WIDTH-1:0] a, b,
    input  logic [2:0] alu_control,
    output logic [WIDTH-1:0] result,
    output logic zero
);
    always_comb begin
        case (alu_control)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = a << b;
            3'b110: result = a >> b;
            3'b111: result = $signed(a) >>> b;
            default: result = '0;
        endcase
        zero = (result == '0);
    end
endmodule

module alu_tb;
    logic [31:0] a = 5, b = 3;
    logic [2:0] ctrl = 3'b000;
    logic [31:0] res;
    logic z;
    
    alu dut(.*);  // Conexão por nome
    
    initial begin
        $display("Testando ALU:");
        #10;
        $display("%d + %d = %d (zero=%b)", a, b, res, z);
        $finish;
    end
endmodule