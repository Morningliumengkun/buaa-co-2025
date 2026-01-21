module PC(
    input Clk,
    input Reset,
    input [31:0] npc,
    output [31:0] pc
);

reg [31:0] regPC;

always @(posedge Clk) begin
    if (Reset == 1'b1) begin
        regPC <= 32'h00003000;
    end
    else begin
        regPC <= npc;
    end
end

assign pc = regPC;

endmodule