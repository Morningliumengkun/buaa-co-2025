module control(
    input [5:0] fuc,
    input [5:0] op,
    input [4:0] rs,
    input overflow,
    input AdEL_DM,
    input AdES,
    input AdEL_PC,
    input Req,
    output [2:0]NPCsle,
    output RegWrite,
    output [1:0] ALUOp,
    output Extsle,
    output [1:0] exstyle,
    output [1:0]RegDst,
    output [2:0]MemData,
    output MemWrite,
    output [4:0] ExcCodeIn,
    output en,
    output EXLClr
);
    wire add;
    wire sub;
    wire ori;
    wire lw;
    wire sw;
    wire beq;
    wire lui;
    wire j;
    wire jal;
    wire jr;
    wire mfc0;
    wire mtc0;
    wire eret;
    wire syscall;
    wire RI;
    wire nop;

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
assign mtc0 = (op == 6'b010000 && rs == 5'b00100) ? 1'b1 : 1'b0;
assign mfc0 = (op == 6'b010000 && rs == 5'b00000) ? 1'b1 : 1'b0;
assign eret = (op == 6'b010000 && fuc == 6'b011000) ? 1'b1 : 1'b0;
assign syscall = (op == 6'b000000 && fuc == 6'b001100) ? 1'b1 : 1'b0;
assign nop = (op == 6'b000000 && fuc == 6'b000000) ? 1'b1 : 1'b0;
assign RI = !(add || sub || ori || lw || sw || beq || j || jr || jal || lui || mfc0 || mtc0 || eret || syscall || nop);


assign ExcCodeIn =  (AdEL_PC) ? 5'b00100 :
                    (RI) ? 5'b01010 :
                    (syscall) ? 5'b01000 :
                    (AdEL_DM && lw) ? 5'b00100 :
                    (AdES && sw) ? 5'b00101 :
                    (overflow && (add || sub)) ? 5'b01100 :                    
                    5'b00000;
assign RegWrite = ((add && !overflow) | (sub && !overflow) | ori | lui | (lw && !AdEL_DM) | jal | mfc0) ? 1'b1 : 1'b0;
assign ALUOp = (sub) ? 2'b01 :
               (ori) ? 2'b10 : 2'b00;
assign RegDst = (add | sub) ? 2'b01 :
                (jal) ? 2'b10 : 
                2'b00;
assign NPCsle = (j | jal) ? 3'b001 :
                (jr) ? 3'b010 :
                (beq) ? 3'b011 : 
                (eret) ? 3'b100 : 
                 (Req) ? 3'b101 : 3'b000;
assign Extsle = (ori | lui | lw | sw) ? 1'b1 : 1'b0;
assign exstyle = (ori) ? 2'b01 :
                 (lui) ? 2'b10 : 2'b00;
assign MemData = (lw) ? 3'b001 :
                 (jal) ? 3'b010 :
                 (mfc0) ? 3'b011 : 3'b000;
assign MemWrite = (sw && (ExcCodeIn == 5'b00000)) ? 1'b1 : 1'b0;
assign en = (mtc0) ? 1'b1 : 1'b0;
assign EXLClr = (eret) ? 1'b1 : 1'b0;

endmodule