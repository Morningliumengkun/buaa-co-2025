module CMP(
    input [31:0] inputA,
    input [31:0] inputB,
    input [5:0] op,
    output signal,
    output zero
);

assign zero = (inputA == inputB) ? 1'b1 : 1'b0;
assign signal = 1'b0;
endmodule