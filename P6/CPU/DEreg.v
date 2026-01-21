module DEreg(
    input clk,
    input reset,
    input DE_en,
    input DE_clr,
    input [31:0] D_instr,
    input [31:0] D_PCplus8,
    input [31:0] D_PC,
    input [31:0] D_RD1,
    input [31:0] D_RD2,
    input [4:0] D_A3,
    input [31:0] D_ext32,
    output reg [31:0] E_instr,
    output reg [31:0] E_PCplus8,
    output reg [31:0] E_PC,
    output reg [31:0] E_RD1,
    output reg [31:0] E_RD2,
    output reg [4:0] E_A3,
    output reg [31:0] E_ext32
);

always @(posedge clk) begin
    if(reset | DE_clr) begin
        E_instr <= 32'h00000000;
        E_PCplus8 <= 32'h00000000;
        E_PC <= 32'h00000000;
        E_RD1 <= 32'h00000000;
        E_RD2 <= 32'h00000000;
        E_A3 <= 5'b00000;
        E_ext32 <= 32'h00000000;
    end
    else if(DE_en) begin
        E_instr <= D_instr;
        E_PCplus8 <= D_PCplus8;
        E_PC <= D_PC;
        E_RD1 <= D_RD1;
        E_RD2 <= D_RD2;
        E_A3 <= D_A3;
        E_ext32 <= D_ext32;
    end
end

endmodule