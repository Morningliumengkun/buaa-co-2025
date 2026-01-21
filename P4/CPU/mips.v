module mips(
    input clk,
    input reset
);

//PC and NPC
wire [31:0] pc_npc;
wire [31:0] pc_pc;
wire [31:0] pc_pcplus4;

//IM
wire [31:0] im_instr;
wire [5:0] im_op;
wire [5:0] im_fuc;
wire [15:0] im_imm16;
wire [25:0] im_imm26;
wire [4:0] im_rs;
wire [4:0] im_rt;
wire [4:0] im_rd;
wire [4:0] im_shamt;

//grf
wire [4:0] grf_a1;
wire [4:0] grf_a2;
wire [4:0] grf_a3;
wire [31:0] grf_wd;
wire [31:0] grf_rd1;
wire [31:0] grf_rd2;

// alu
wire [31:0] alu_b;
wire [31:0] alu_res;
wire alu_zero;

//DM
wire [31:0] dm_data;

//ext
wire [31:0] ext_out;

//control
wire [2:0]NPCsle;
wire RegWrite;
wire [1:0] ALUOp;
wire Extsle;
wire [1:0] exstyle;
wire [1:0]RegDst;
wire [1:0]MemData;
wire MemWrite;

PC PC(.Clk(clk),.Reset(reset),.npc(pc_npc),.pc(pc_pc));
NPC NPC(.PC(pc_pc),.imm26(im_imm26),.GRF(grf_rd1),
        .imm16(im_imm16),.zero(alu_zero),.NPCsle(NPCsle),.NPC(pc_npc));
IM IM(.addr(pc_pc),.Instr(im_instr));
control CONTROL(.fuc(im_fuc),.op(im_op),.NPCsle(NPCsle),.RegWrite(RegWrite),
                .ALUOp(ALUOp),.Extsle(Extsle),.exstyle(exstyle),.RegDst(RegDst),
                .MemData(MemData),.MemWrite(MemWrite));
GRF GRF(.clk(clk),.reset(reset),.WE(RegWrite),.A1(im_rs),.A2(im_rt),.A3(grf_a3),
        .WD(grf_wd),.RD1(grf_rd1),.RD2(grf_rd2));
ALU ALU(.A(grf_rd1),.B(alu_b),.ALUOp(ALUOp),.zero(alu_zero),.res(alu_res));
DM DM(.WD(grf_rd2),.addr(alu_res),.WE(MemWrite),.Clk(clk),.reset(reset),.D(dm_data));
EXT EXT(.imm(im_imm16),.Exstyle(exstyle),.B(ext_out));

assign pc_pcplus4 = pc_pc + 32'h00000004;

assign im_op = im_instr[31:26];
assign im_rs = im_instr[25:21];
assign im_rt = im_instr[20:16];
assign im_rd = im_instr[15:11];
assign im_shamt = im_instr[10:6];
assign im_fuc = im_instr[5:0];
assign im_imm16 = im_instr[15:0];
assign im_imm26 = im_instr[25:0];

assign grf_a3 = (RegDst == 2'b00) ? im_rt :
                (RegDst == 2'b01) ? im_rd :
                (RegDst == 2'b10) ? 5'b11111 :
					 5'b00000;
assign grf_wd = (MemData == 2'b10) ? pc_pcplus4 :
                (MemData == 2'b01) ? dm_data :
                alu_res;

assign alu_b = (Extsle) ? ext_out : grf_rd2;

always @(posedge clk) begin
    if (RegWrite == 1 && reset == 0) begin
        $display("@%h: $%d <= %h",pc_pc,grf_a3,grf_wd);
    end
end

always @(posedge clk) begin
    if (MemWrite == 1 && reset == 0) begin
        $display("@%h: *%h <= %h", pc_pc,alu_res,grf_rd2);
    end
end

endmodule