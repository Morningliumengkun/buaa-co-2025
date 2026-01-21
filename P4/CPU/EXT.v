module EXT(
    input [15:0] imm,
    input [1:0] Exstyle,
    output [31:0] B
);

reg [31:0] resultB;

assign B = (Exstyle == 2'b00) ? {{16{imm[15]}},imm} :
           (Exstyle == 2'b01) ? {16'b0,imm} :
           (Exstyle == 2'b10) ? {imm,16'b0} :
           32'b000000;

endmodule