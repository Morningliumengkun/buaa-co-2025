`include "def.v"

module mips(
    input clk,
    input reset
);

//F
//PC and NPC
wire [31:0] F_PC;
wire [31:0] F_NPC;
wire [31:0] F_PCplus8;

//F_IM
wire [31:0] F_instr;

//D
//D_control
wire [2:0] D_NPCsle;
wire [1:0] D_exstyle;
wire [1:0] D_RegDst;
wire [3:0] D_t_rs;
wire [3:0] D_t_rt;
wire [3:0] D_t;

//D_IM
wire [31:0] D_instr;
wire [5:0] D_op;
wire [5:0] D_fuc;
wire [15:0] D_imm16;
wire [25:0] D_imm26;
wire [4:0] D_rs;
wire [4:0] D_rt;
wire [4:0] D_rd;
wire [4:0] D_shamt;

//GRF
wire [4:0] D_grf_a1;
wire [4:0] D_grf_a2;
wire [31:0] D_grf_rd1;
wire [31:0] D_grf_rd2;
wire [4:0] D_grf_a3;

//EXT
wire [31:0] D_ext32;

//CMP
wire D_zero;
wire D_signal;

//F->D
wire [31:0] D_PCplus8;
wire [31:0] D_PC;

//E
//E_control
wire [3:0] E_t_rs;
wire [3:0] E_t_rt;
wire [3:0] E_t;
wire [1:0] E_ALUOp;
wire E_Extsle;

//E_IM
wire [31:0] E_instr;
wire [5:0] E_op;
wire [5:0] E_fuc;
wire [15:0] E_imm16;
wire [25:0] E_imm26;
wire [4:0] E_rs;
wire [4:0] E_rt;
wire [4:0] E_rd;
wire [4:0] E_shamt;

//ALU
wire [31:0] E_alu_a;
wire [31:0] E_alu_b;
wire [31:0] E_alu_res;

//D->E
wire [31:0] E_PCplus8;
wire [31:0] E_PC;
wire [31:0] E_RD1;
wire [31:0] E_RD2;
wire [4:0] E_A3;
wire [31:0] E_ext32;

//M
//M_control
wire M_MemWrite;
wire [3:0] M_t_rs;
wire [3:0] M_t_rt;
wire [3:0] M_t;

//M_IM
wire [31:0] M_instr;
wire [5:0] M_op;
wire [5:0] M_fuc;
wire [15:0] M_imm16;
wire [25:0] M_imm26;
wire [4:0] M_rs;
wire [4:0] M_rt;
wire [4:0] M_rd;
wire [4:0] M_shamt;

//DM
wire [31:0] M_dm_addr;
wire [31:0] M_dm_data;
wire [31:0] M_dm_wd;

//E->M
wire [31:0] M_PCplus8;
wire [31:0] M_PC;
wire [31:0] M_ALUres;
wire [31:0] M_RD2;
wire [4:0] M_A3;

//W
//W_control
wire W_RegWrite;
wire [1:0] W_MemData;
wire [1:0] W_RegDst;
wire [3:0] W_t_rs;
wire [3:0] W_t_rt;
wire [3:0] W_t;

//W_IM
wire [31:0] W_instr;
wire [5:0] W_op;
wire [5:0] W_fuc;
wire [15:0] W_imm16;
wire [25:0] W_imm26;
wire [4:0] W_rs;
wire [4:0] W_rt;
wire [4:0] W_rd;
wire [4:0] W_shamt;

//GRF(W)
wire [4:0] W_A3;
wire [31:0] W_grf_wd; 

//从M到W
wire [31:0] W_PCplus8;
wire [31:0] W_PC;
wire [31:0] W_ALUres;
wire [31:0] W_data; 

//forward
//fixed data
wire [31:0] D_fixedRD1;
wire [31:0] D_fixedRD2;
wire [31:0] E_fixedRD1;
wire [31:0] E_fixedRD2;
wire [31:0] M_fixedRD2;

//tuse and tnew
wire [3:0] D_t_rsuse;
wire [3:0] D_t_rtuse;
wire [3:0] D_t_new;

wire [3:0] E_t_rsuse;
wire [3:0] E_t_rtuse;
wire [3:0] E_t_new;

wire [3:0] M_t_rsuse;
wire [3:0] M_t_rtuse;
wire [3:0] M_t_new;

wire [3:0] W_t_rsuse;
wire [3:0] W_t_rtuse;
wire [3:0] W_t_new;

//isPCplus8
wire E_isPCplus8;
wire M_isPCplus8;

//forward
wire D_RD1_from_E_PCplus8;
wire D_RD2_from_E_PCplus8;

wire D_RD1_from_M_PCplus8;
wire D_RD2_from_M_PCplus8;
wire E_RD1_from_M_PCplus8;
wire E_RD2_from_M_PCplus8;

wire D_RD1_from_M;
wire D_RD2_from_M;
wire E_RD1_from_M;
wire E_RD2_from_M;

wire D_RD1_from_W;
wire D_RD2_from_W;
wire E_RD1_from_W;
wire E_RD2_from_W;
wire M_RD2_from_W;

//stall
//PC and reg
wire PC_en;
wire FD_en;
wire DE_en;
wire EM_en;
wire MW_en;

wire FD_clr;
wire DE_clr;
wire EM_clr;
wire MW_clr;

wire D_stall;

//F
PC PC(.clk(clk),.reset(reset),.PC_en(PC_en),.npc(F_NPC),.pc(F_PC));
NPC NPC(.F_PC(F_PC),.imm26(D_imm26),.GRF(D_fixedRD1),.imm16(D_imm16),
        .zero(D_zero),.NPCsle(D_NPCsle),.NPC(F_NPC),.signal(D_signal));
IM IM(.addr(F_PC),.Instr(F_instr));
FDreg FDreg(.clk(clk),.reset(reset),.FD_en(FD_en),.FD_clr(FD_clr),
            .F_instr(F_instr),.F_PCplus8(F_PCplus8),.F_PC(F_PC),
            .D_instr(D_instr),.D_PCplus8(D_PCplus8),.D_PC(D_PC));

//D
control D_control(.op(D_op),.fuc(D_fuc),.exstyle(D_exstyle),.NPCsle(D_NPCsle),
                .RegDst(D_RegDst),.t_rs(D_t_rs),.t_rt(D_t_rt),.t(D_t));
GRF GRF(.clk(clk),.reset(reset),.WE(W_RegWrite),.A1(D_grf_a1),.A2(D_grf_a2),
        .A3(W_A3),.WD(W_grf_wd),.RD1(D_grf_rd1),.RD2(D_grf_rd2),.WPC(W_PC));
EXT EXT(.imm(D_imm16),.Exstyle(D_exstyle),.B(D_ext32));
CMP CMP(.inputA(D_fixedRD1),.inputB(D_fixedRD2),
        .zero(D_zero),.op(D_op),.signal(D_signal));
DEreg DEreg(.clk(clk),.reset(reset),.DE_en(DE_en),.DE_clr(DE_clr),.D_instr(D_instr),
            .D_PCplus8(D_PCplus8),.D_PC(D_PC),.D_RD1(D_fixedRD1),.D_RD2(D_fixedRD2),
            .D_A3(D_grf_a3),.D_ext32(D_ext32),.E_instr(E_instr),.E_PCplus8(E_PCplus8),
            .E_PC(E_PC),.E_RD1(E_RD1),.E_RD2(E_RD2),.E_A3(E_A3),.E_ext32(E_ext32));


//E
control E_control(.op(E_op),.fuc(E_fuc),.ALUOp(E_ALUOp),.t_rs(E_t_rs),.t_rt(E_t_rt),.t(E_t),.Extsle(E_Extsle));
ALU ALU(.A(E_alu_a),.B(E_alu_b),.ALUOp(E_ALUOp),.res(E_alu_res));
EMreg EMreg(.clk(clk),.reset(reset),.EM_en(EM_en),.EM_clr(EM_clr),.E_instr(E_instr),.E_PCplus8(E_PCplus8),.E_PC(E_PC),
            .E_ALUres(E_alu_res),.E_RD2(E_fixedRD2),.E_A3(E_A3),.M_instr(M_instr),.M_PCplus8(M_PCplus8),
            .M_ALUres(M_ALUres),.M_PC(M_PC),.M_RD2(M_RD2),.M_A3(M_A3));

//M
control M_control(.op(M_op),.fuc(M_fuc),.MemWrite(M_MemWrite),.t_rs(M_t_rs),.t_rt(M_t_rt),.t(M_t));
DM DM(.Clk(clk),.reset(reset),.WE(M_MemWrite),.WD(M_dm_wd),.addr(M_dm_addr),.D(M_dm_data),.WPC(M_PC));
MWreg MWreg(.clk(clk),.reset(reset),.MW_en(MW_en),.MW_clr(MW_clr),.M_instr(M_instr),.M_PCplus8(M_PCplus8),.M_PC(M_PC),
            .M_A3(M_A3),.M_ALUres(M_ALUres),.M_data(M_dm_data),.W_instr(W_instr),.W_PCplus8(W_PCplus8),.W_PC(W_PC),
            .W_A3(W_A3),.W_ALUres(W_ALUres),.W_data(W_data));

//W
control W_control(.op(W_op),.fuc(W_fuc),.MemData(W_MemData),.RegWrite(W_RegWrite),.t_rs(W_t_rs),
                  .t_rt(W_t_rt),.t(W_t));

//F
assign F_PCplus8 = F_PC + 32'h00000008;

//D
assign D_op = D_instr[`op];
assign D_fuc = D_instr[`fuc];
assign D_rs = D_instr[`rs];
assign D_rt = D_instr[`rt];
assign D_rd = D_instr[`rd];
assign D_shamt = D_instr[`shamt];
assign D_imm16 = D_instr[`imm16];
assign D_imm26 = D_instr[`imm26];

assign D_grf_a1 = D_rs;
assign D_grf_a2 = D_rt;
assign D_grf_a3 = (D_RegDst == 2'b01) ? D_rd :
                  (D_RegDst == 2'b10) ? 5'b11111 : D_rt;

//E
assign E_op = E_instr[`op];
assign E_fuc = E_instr[`fuc];
assign E_rs = E_instr[`rs];
assign E_rt = E_instr[`rt];
assign E_rd = E_instr[`rd];
assign E_shamt = E_instr[`shamt];
assign E_imm16 = E_instr[`imm16];
assign E_imm26 = E_instr[`imm26];

assign E_alu_a = E_fixedRD1;
assign E_alu_b = (E_Extsle) ? E_ext32 : E_fixedRD2;

//M
assign M_op = M_instr[`op];
assign M_fuc = M_instr[`fuc];
assign M_rs = M_instr[`rs];
assign M_rt = M_instr[`rt];
assign M_rd = M_instr[`rd];
assign M_shamt = M_instr[`shamt];
assign M_imm16 = M_instr[`imm16];
assign M_imm26 = M_instr[`imm26];

assign M_dm_addr = M_ALUres;
assign M_dm_wd = M_fixedRD2;

//W
assign W_op = W_instr[`op];
assign W_fuc = W_instr[`fuc];
assign W_rs = W_instr[`rs];
assign W_rt = W_instr[`rt];
assign W_rd = W_instr[`rd];
assign W_shamt = W_instr[`shamt];
assign W_imm16 = W_instr[`imm16];
assign W_imm26 = W_instr[`imm26];

assign W_grf_wd = (W_MemData == 2'b01) ? W_data :
                  (W_MemData == 2'b10) ? W_PCplus8 : W_ALUres;



//fixed data
assign D_fixedRD1 = (D_RD1_from_E_PCplus8) ? E_PCplus8 :
                    (D_RD1_from_M_PCplus8) ? M_PCplus8 :
                    (D_RD1_from_M) ? M_ALUres :
                    (D_RD1_from_W) ? W_grf_wd : D_grf_rd1;
assign D_fixedRD2 = (D_RD2_from_E_PCplus8) ? E_PCplus8 :
                    (D_RD2_from_M_PCplus8) ? M_PCplus8 :
                    (D_RD2_from_M) ? M_ALUres :
                    (D_RD2_from_W) ? W_grf_wd : D_grf_rd2;
assign E_fixedRD1 = (E_RD1_from_M_PCplus8) ? M_PCplus8 :
                    (E_RD1_from_M) ? M_ALUres :
                    (E_RD1_from_W) ? W_grf_wd : E_RD1;
assign E_fixedRD2 = (E_RD2_from_M_PCplus8) ? M_PCplus8 :
                    (E_RD2_from_M) ? M_ALUres :
                    (E_RD2_from_W) ? W_grf_wd : E_RD2;
assign M_fixedRD2 = (M_RD2_from_W) ? W_grf_wd : M_RD2;                 

//tuse and tnew
assign D_t_rsuse = D_t_rs;
assign D_t_rtuse = D_t_rt;
assign D_t_new =D_t;

assign E_t_rsuse = (E_t_rs == 4'd15) ? 4'd15 :
                   (E_t_rs >= 4'd1) ? (E_t_rs - 4'd1) :
                   4'd0;
assign E_t_rtuse = (E_t_rt == 4'd15) ? 4'd15 :
                   (E_t_rt >= 4'd1) ? (E_t_rt - 4'd1) :
                   4'd0;
assign E_t_new = (E_t == 4'd15) ? 4'd15 :
                 (E_t >= 4'd1) ? (E_t - 4'd1) :
                 4'd0;


assign M_t_rsuse = (M_t_rs == 4'd15) ? 4'd15 :
                   (M_t_rs >= 4'd2) ? (M_t_rs - 4'd2) :
                   4'd0;
assign M_t_rtuse = (M_t_rt == 4'd15) ? 4'd15 :
                   (M_t_rt >= 4'd2) ? (M_t_rt - 4'd2) :
                   4'd0;
assign M_t_new = (M_t == 4'd15) ? 4'd15 :
                 (M_t >= 4'd2) ? (M_t - 4'd2) :
                 4'd0;


assign W_t_rsuse = (W_t_rs == 4'd15) ? 4'd15 :
                   (W_t_rs >= 4'd3) ? (W_t_rs - 4'd3) :
                   4'd0;
assign W_t_rtuse = (W_t_rt == 4'd15) ? 4'd15 :
                   (W_t_rt >= 4'd3) ? (W_t_rt - 4'd3) :
                   4'd0;
assign W_t_new = (W_t == 4'd15) ? 4'd15 :
                 (W_t >= 4'd3) ? (W_t - 4'd3) :
                 4'd0;                 


//isPCplus8(jal)
assign E_isPCplus8 = (E_op == 6'b000011) ? 1'b1 : 1'b0;
assign M_isPCplus8 = (M_op == 6'b000011) ? 1'b1 : 1'b0;

// zhuanfa judgement
assign D_RD1_from_E_PCplus8 = (E_isPCplus8 && E_A3 != 5'b00000 
                              && D_rs == E_A3 && D_t_rsuse != 4'd15 && E_t_new != 4'd15 
                              && D_t_rsuse >= E_t_new) ? 1'b1 : 1'b0;
assign D_RD2_from_E_PCplus8 = (E_isPCplus8 && E_A3 != 5'b00000 
                              && D_rt == E_A3 && D_t_rtuse != 4'd15 && E_t_new != 4'd15 
                              && D_t_rtuse >= E_t_new) ? 1'b1 : 1'b0;
                              
assign D_RD1_from_M_PCplus8 = (M_isPCplus8 && M_A3 != 5'b00000 
                              && D_rs == M_A3 && D_t_rsuse != 4'd15 && M_t_new != 4'd15 
                              && D_t_rsuse >= M_t_new) ? 1'b1 : 1'b0;
assign D_RD2_from_M_PCplus8 = (M_isPCplus8 && M_A3 != 5'b00000 
                              && D_rt == M_A3 && D_t_rtuse != 4'd15 && M_t_new != 4'd15 
                              && D_t_rtuse >= M_t_new) ? 1'b1 : 1'b0;
assign E_RD1_from_M_PCplus8 = (M_isPCplus8 && M_A3 != 5'b00000 
                              && E_rs == M_A3 && E_t_rsuse != 4'd15 && M_t_new != 4'd15 
                              && E_t_rsuse >= M_t_new) ? 1'b1 : 1'b0;
assign E_RD2_from_M_PCplus8 = (M_isPCplus8 && M_A3 != 5'b00000 
                              && E_rt == M_A3 && E_t_rtuse != 4'd15 && M_t_new != 4'd15 
                              && E_t_rtuse >= M_t_new) ? 1'b1 : 1'b0;

assign D_RD1_from_M = (~M_isPCplus8 && M_A3 != 5'b00000 
                      && D_rs == M_A3 && D_t_rsuse != 4'd15 && M_t_new != 4'd15 
                      && D_t_rsuse >= M_t_new) ? 1'b1 : 1'b0;
assign D_RD2_from_M = (~M_isPCplus8 && M_A3 != 5'b00000 
                      && D_rt == M_A3 && D_t_rtuse != 4'd15 && M_t_new != 4'd15 
                      && D_t_rtuse >= M_t_new) ? 1'b1 : 1'b0;
assign E_RD1_from_M = (~M_isPCplus8 && M_A3 != 5'b00000 
                      && E_rs == M_A3 && E_t_rsuse != 4'd15 && M_t_new != 4'd15 
                      && E_t_rsuse >= M_t_new) ? 1'b1 : 1'b0;
assign E_RD2_from_M = (~M_isPCplus8 && M_A3 != 5'b00000 
                      && E_rt == M_A3 && E_t_rtuse != 4'd15 && M_t_new != 4'd15 
                      && E_t_rtuse >= M_t_new) ? 1'b1 : 1'b0;

assign D_RD1_from_W = (W_A3 != 5'b00000 && D_rs == W_A3 && D_t_rsuse != 4'd15 && W_t_new != 4'd15 && D_t_rsuse >= W_t_new) ? 1'b1 : 1'b0;
assign D_RD2_from_W = (W_A3 != 5'b00000 && D_rt == W_A3 && D_t_rtuse != 4'd15 && W_t_new != 4'd15 && D_t_rtuse >= W_t_new) ? 1'b1 : 1'b0;
assign E_RD1_from_W = (W_A3 != 5'b00000 && E_rs == W_A3 && E_t_rsuse != 4'd15 && W_t_new != 4'd15 && E_t_rsuse >= W_t_new) ? 1'b1 : 1'b0;
assign E_RD2_from_W = (W_A3 != 5'b00000 && E_rt == W_A3 && E_t_rtuse != 4'd15 && W_t_new != 4'd15 && E_t_rtuse >= W_t_new) ? 1'b1 : 1'b0;
assign M_RD2_from_W = (W_A3 != 5'b00000 && M_rt == W_A3 && M_t_rtuse != 4'd15 && W_t_new != 4'd15 && M_t_rtuse >= W_t_new) ? 1'b1 : 1'b0;


assign PC_en = (D_stall) ? 1'b0 : 1'b1;
assign FD_en = (D_stall) ? 1'b0 : 1'b1;
assign DE_en = 1'b1;
assign EM_en = 1'b1;
assign MW_en = 1'b1;

//NulllifyCurrentInstruction()
//wire fixedsingal
//assign fixedsignal = (D_signal & (!D_stall))
//assign FD_clr = (fixedsignal) ? 1'b1 : 1'b0;
assign FD_clr = 1'b0;
assign DE_clr = (D_stall) ? 1'b1 : 1'b0;
assign EM_clr = 1'b0;
assign MW_clr = 1'b0;

// stall judgement
assign D_stall = (E_A3 != 5'b00000 && D_rs == E_A3 && D_t_rsuse != 4'd15 && E_t_new != 4'd15 && D_t_rsuse < E_t_new) ? 1'b1 :
                 (E_A3 != 5'b00000 && D_rt == E_A3 && D_t_rtuse != 4'd15 && E_t_new != 4'd15 && D_t_rtuse < E_t_new) ? 1'b1 :
                 (M_A3 != 5'b00000 && D_rs == M_A3 && D_t_rsuse != 4'd15 && M_t_new != 4'd15 && D_t_rsuse < M_t_new) ? 1'b1 :
                 (M_A3 != 5'b00000 && D_rt == M_A3 && D_t_rtuse != 4'd15 && M_t_new != 4'd15 && D_t_rtuse < M_t_new) ? 1'b1 :
                 (W_A3 != 5'b00000 && D_rs == W_A3 && D_t_rsuse != 4'd15 && W_t_new != 4'd15 && D_t_rsuse < W_t_new) ? 1'b1 :
                 (W_A3 != 5'b00000 && D_rt == W_A3 && D_t_rtuse != 4'd15 && W_t_new != 4'd15 && D_t_rtuse < W_t_new) ? 1'b1 : 1'b0;

endmodule