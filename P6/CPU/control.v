module control(
    input [5:0] fuc,
    input [5:0] op,
    output [2:0]NPCsle,
    output RegWrite,
    output [1:0] ALUOp,
    output Extsle,
    output [1:0] exstyle,
    output [1:0]RegDst,
    output [1:0]MemData,
    output MemWrite,
    output [3:0] t_rs,
    output [3:0] t_rt,
    output [3:0] t
);

assign add = (op == 6'b000000 && fuc == 6'b100000) ? 1'b1 : 1'b0;
assign sub = (op == 6'b000000 && fuc == 6'b100010) ? 1'b1 : 1'b0;
assign ori = (op == 6'b001101) ? 1'b1 : 1'b0;
assign lui = (op == 6'b001111) ? 1'b1 : 1'b0;
assign lw = (op == 6'b100011) ? 1'b1 : 1'b0;
assign sw = (op == 6'b101011) ? 1'b1 : 1'b0;
assign beq = (op == 6'b000100) ? 1'b1 : 1'b0;
assign j = (op == 6'b000010) ? 1'b1 : 1'b0;
assign jr = (op == 6'b000000 && fuc == 6'b001000) ? 1'b1 : 1'b0;
assign jal = (op == 6'b000011) ? 1'b1 : 1'b0;
assign nop = (op == 6'b000000 && fuc == 6'b000000) ? 1'b1 : 1'b0;

assign RegWrite = (add | sub | ori | lui | lw | jal) ? 1'b1 : 1'b0;
assign ALUOp = (sub) ? 2'b01 :
               (ori) ? 2'b10 : 2'b00;
assign RegDst = (add | sub) ? 2'b01 :
                (jal) ? 2'b10 : 2'b0;
assign NPCsle = (j | jal) ? 3'b001 :
                (jr) ? 3'b010 :
                (beq) ? 3'b011 : 3'b000;
assign Extsle = (ori | lui | lw | sw) ? 1'b1 : 1'b0;
assign exstyle = (ori) ? 2'b01 :
                 (lui) ? 2'b10 : 2'b00;
assign MemData = (lw) ? 2'b01 :
                 (jal) ? 2'b10 :
                 2'b00;
assign MemWrite = (sw) ? 1'b1 : 1'b0;

assign t_rs = (add) ? 4'd1 :
              (sub) ? 4'd1 :
              (ori) ? 4'd1 :
              (lui) ? 4'd15 :
              (lw) ? 4'd1 :
              (sw) ? 4'd1 :
              (beq) ? 4'd0 :
              (j) ? 4'd15 :
              (jal) ? 4'd0 :
              (jr) ? 4'd0 : 4'd15;

assign t_rt = (add) ? 4'd1 :
              (sub) ? 4'd1 :
              (ori) ? 4'd15 :
              (lui) ? 4'd15 :
              (lw) ? 4'd15 :
              (sw) ? 4'd2 :
              (beq) ? 4'd0 :
              (j) ? 4'd15 :
              (jal) ? 4'd15 :
              (jr) ? 4'd15 : 4'd15;

assign t = (add) ? 4'd2 :
           (sub) ? 4'd2 :
           (ori) ? 4'd2 :
           (lui) ? 4'd2 :
           (lw) ? 4'd3 :
           (sw) ? 4'd15 :
           (beq) ? 4'd15 :
           (j) ? 4'd15 :
           (jr) ? 4'd15 :
           (jal) ? 4'd0 : 4'd15;

endmodule