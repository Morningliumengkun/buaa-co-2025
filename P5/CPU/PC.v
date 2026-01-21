module PC(
    input Clk,
    input Reset,
    input [31:0] npc,
    output [31:0] pc,
    output  AdEL
);

reg [31:0] regPC;
wire align_pc;
wire outedge_pc;

always @(posedge Clk) begin
    if (Reset == 1'b1) begin
        regPC <= 32'h00003000;
    end
    else begin
        regPC <= npc;
    end
end

assign pc = regPC;
assign align_pc = (regPC[1:0] != 2'b00) ? 1'b1 : 1'b0;
assign outedge_pc = ((pc < 32'h00003000) || (pc > 32'h00006ffc))? 1'b1 : 1'b0;
assign AdEL = (align_pc || outedge_pc)? 1'b1 : 1'b0;


endmodule