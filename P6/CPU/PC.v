module PC(
    input clk,
    input reset,
    input [31:0] npc,
    input PC_en,
    output [31:0] pc
);

reg [31:0] regPC;

always @(posedge clk) begin
    if (reset == 1'b1) begin
        regPC <= 32'h00003000;
    end
    else if(PC_en) begin
        regPC <= npc;
    end
end

assign pc = regPC;

endmodule