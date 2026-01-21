module IM(

    input [31:0] addr,

    output [31:0] Instr

);

reg [31:0] ROM [0:4095];
wire [31:0] temp;


initial begin
    $readmemh("code.txt",ROM,0,4095);
end



assign temp = ((addr - 32'h00003000) >> 2);

assign align_IM = (addr[1:0] != 2'b00) ? 1'b1 : 1'b0;
assign outedge_IM = ((addr < 32'h00003000) || (addr > 32'h00006ffc))? 1'b1 : 1'b0;
assign Instr = (align_IM || outedge_IM) ? 32'h00000000 : ROM[temp];


endmodule