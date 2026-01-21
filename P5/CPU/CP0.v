module CP0(
    input clk,
    input reset,
    input en,
    input [4:0] CP0Add,
    input [31:0] CP0In,
    input [31:0] VPC,
    input [4:0] ExcCodeIn,
    input EXLClr,
    output [31:0] EPCOut,
    output Req,
    output [31:0] CP0Out
);

reg [31:0] SR;    //SR[1] = EXL;
reg [31:0] CAUSE; //CAUSE[6:2] = ExcCode;
reg [31:0] EPC;   //PC

assign Req = (!SR[1] && (ExcCodeIn != 5'd0)) ? 1'd1 : 1'd0;

always @(posedge clk) begin
    if(reset) begin
        SR <= 0;
        CAUSE <= 0;
        EPC <= 0;
    end
    else if(EXLClr) begin
        SR[1] <= 0;
    end
    else if(en) begin
        case(CP0Add)
            5'd12: SR <= CP0In;
            5'd13: CAUSE <= CP0In;
            5'd14: EPC <= CP0In;
        endcase
    end
    else if(ExcCodeIn != 5'b0 && SR[1] != 1'b1) begin
        SR[1] <= 1'b1;
        CAUSE[6:2] <= ExcCodeIn;
        EPC <= VPC;
    end
end

assign CP0Out = (CP0Add == 5'd12) ? SR :
                 (CP0Add == 5'd13) ? CAUSE :
                 (CP0Add == 5'd14) ? EPC :
                 32'd0;
assign EPCOut = EPC;

endmodule


