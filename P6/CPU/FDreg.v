module FDreg(
    input clk,
    input reset,
    input FD_en,
    input FD_clr,
    input [31:0] F_instr,
    input [31:0] F_PCplus8,
    input [31:0] F_PC,
    output reg [31:0] D_instr,
    output reg [31:0] D_PCplus8,
    output reg [31:0] D_PC
);

always @(posedge clk) begin
    if(reset | FD_clr) begin
        D_instr <= 32'h00000000;
        D_PCplus8 <= 32'h00000000;
        D_PC <= 32'h00000000;
    end
    else begin
        if(FD_en) begin
            D_instr <= F_instr;
            D_PCplus8 <= F_PCplus8;
            D_PC <=F_PC;
        end
    end
end
endmodule