module ALU(
    input [31:0] A,
    input [31:0] B,
    input [1:0] ALUOp,
    output [31:0] res,
    output zero,
    output Less
);

assign res = (ALUOp == 2'b00) ? (A + B) :
             (ALUOp == 2'b01) ? (A - B) :
             (ALUOp == 2'b10) ? (A | B) :
             32'b000000;

assign zero = (A == B) ? 1'b1 : 1'b0;
assign Less = (A < B) ? 1'b1 : 1'b0;

endmodule