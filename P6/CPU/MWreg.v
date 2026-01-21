module MWreg(
    input clk,
    input reset,
    input MW_en,
    input MW_clr,
    input [31:0] M_instr,
    input [31:0] M_PCplus8,
    input [31:0] M_PC,
    input [4:0] M_A3,
    input [31:0] M_ALUres,
    input [31:0] M_data,
    output reg [31:0] W_instr,
    output reg [31:0] W_PCplus8,
    output reg [31:0] W_PC,
    output reg [4:0] W_A3,
    output reg [31:0] W_ALUres,
    output reg [31:0] W_data 
);

always @(posedge clk) begin
    if(reset | MW_clr) begin
        W_instr <= 32'h00000000;
        W_PCplus8 <= 32'h00000000;
        W_PC <= 32'h00000000;
        W_A3 <= 5'b00000;
        W_ALUres <= 32'h00000000;
        W_data <= 32'h00000000;
    end
    else if (MW_en) begin
        W_instr <= M_instr;
        W_PCplus8 <= M_PCplus8;
        W_PC <= M_PC;
        W_A3 <= M_A3;
        W_ALUres <= M_ALUres;;
        W_data <= M_data;
    end
end
endmodule