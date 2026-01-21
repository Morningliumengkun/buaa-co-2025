module DM(
    input [31:0] WD,
    input [31:0] addr,
    input WE,
    input Clk,
    input reset,
    input overflow,
    output [31:0] D,
    output AdEL,
    output AdES
);
reg [31:0] RAM [0:3071];
integer i;
wire [11:0] a;
wire align_dm;
wire outedge_dm;

assign a[11:0] = addr[13:2];
assign align_dm = (addr[1:0] != 2'b00) ? 1'b1 : 1'b0;
assign outedge_dm = (addr < 32'h0000000 || addr > 32'h00002fff) ? 1'b1 : 1'b0;

always @(posedge Clk) begin
    if(reset == 1'b1) begin
        for(i = 0;i < 3072; i = i + 1)begin
            RAM[i] <= 32'h00000000;
        end
    end
    else begin
        if(WE == 1'b1)begin
            RAM[a] <= WD;
        end
    end
end

assign AdEL = (align_dm || outedge_dm || overflow) ? 1'b1 : 1'b0;
assign AdES = (align_dm || outedge_dm || overflow) ? 1'b1 : 1'b0;
assign D = RAM[a];

endmodule