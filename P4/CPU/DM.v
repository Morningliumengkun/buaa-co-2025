module DM(
    input [31:0] WD,
    input [31:0] addr,
    input WE,
    input Clk,
    input reset,
    output [31:0] D
);
reg [31:0] RAM [0:3071];
integer i;
wire [11:0] a;
assign a[11:0] = addr[13:2];

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

assign D = RAM[a];
endmodule