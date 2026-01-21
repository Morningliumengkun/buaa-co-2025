module EMreg(
    input clk,
    input reset,
    input EM_en,
    input EM_clr,
    input [31:0] E_instr,
    input [31:0] E_PCplus8,
    input [31:0] E_PC,
    input [31:0] E_ALUres,
    input [31:0] E_RD2,
    input [4:0] E_A3,
    output reg [31:0] M_instr,
    output reg [31:0] M_PCplus8,
    output reg [31:0] M_PC,
    output reg [31:0] M_ALUres,
    output reg [31:0] M_RD2,
    output reg [4:0] M_A3
);

always @(posedge clk) begin
    if (reset | EM_clr) begin
        M_instr <= 32'h00000000;
        M_PCplus8 <= 32'h00000000;
        M_PC <= 32'h00000000;
        M_ALUres <= 32'h00000000;
        M_A3 <= 5'b00000;
    end
    else if(EM_en) begin
        M_instr <= E_instr;
        M_PCplus8 <= E_PCplus8;
        M_PC <= E_PC;
        M_ALUres <=E_ALUres;
        M_RD2 <= E_RD2;
        M_A3 <= E_A3;
    end
end
endmodule