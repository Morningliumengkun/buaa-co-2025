module GRF(
    input clk,
    input reset,
    input WE,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    input [31:0] WPC,
    output [31:0] RD1,
    output [31:0] RD2
);

integer i;
reg [31:0] GRF [0:31];
reg [31:0] resultRD1;
reg [31:0] resultRD2;

always @(posedge clk) begin
    if(reset == 1'b1) begin
        for(i = 0;i < 32;i = i + 1) begin
            GRF[i] <= 32'h00000000;
        end
    end
    else begin
        if(WE == 1'b1) begin
            if(A3 != 5'b0) begin
                GRF[A3] <= WD;
            end
            $display("%d@%h: $%d <= %h", $time,WPC, A3, WD);
        end
    end
end

assign RD1 = GRF[A1];
assign RD2 = GRF[A2];

endmodule