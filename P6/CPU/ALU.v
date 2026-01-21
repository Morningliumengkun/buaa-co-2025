module ALU(
    input [31:0] A,
    input [31:0] B,
    input [1:0] ALUOp,
    output [31:0] res
);

assign res = (ALUOp == 2'b00) ? (A + B) :
             (ALUOp == 2'b01) ? (A - B) :
             (ALUOp == 2'b10) ? (A | B) :
             32'b000000;



endmodule