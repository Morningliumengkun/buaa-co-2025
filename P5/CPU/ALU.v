module ALU(
    input [31:0] A,
    input [31:0] B,
    input [1:0] ALUOp,
    output [31:0] res,
    output zero,
    output Less,
    output overflow
);

assign res = (ALUOp == 2'b00) ? (A + B) :
             (ALUOp == 2'b01) ? (A - B) :
             (ALUOp == 2'b10) ? (A | B) :
             32'b000000;

assign zero = (A == B) ? 1'b1 : 1'b0;
assign Less = (A < B) ? 1'b1 : 1'b0;
wire [31:0] result_add = A + B;
wire [31:0] result_div = A - B;
reg Overflow_reg;
always @(*)begin
    case(ALUOp)
        2'b00: begin
            if((A[31] == B[31]) && (result_add[31] != A[31])) begin
                Overflow_reg = 1'b1;
            end
            else begin
                Overflow_reg = 1'b0;
            end
        end
        2'b01: begin
            if((A[31] != B[31]) && (result_div[31] != A[31])) begin
                Overflow_reg = 1'b1;
            end
            else begin
                Overflow_reg = 1'b0;
            end
        end
        default:Overflow_reg = 1'b0;
    endcase
end

assign overflow = Overflow_reg;

endmodule