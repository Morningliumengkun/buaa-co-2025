module NPC(
    input [31:0] PC,
    input [25:0] imm26,
    input [31:0] GRF,
    input [15:0] imm16,
    input zero,
    input [2:0] NPCsle,
    input [31:0] EPCOut,
    output [31:0] NPC
);

wire [31:0] NPC_PCplus4;
wire [31:0] extimm26;
wire [31:0] extimm16;
wire [31:0] signimm16;

assign signimm16 = {{{14{imm16[15]}},imm16,2'b0}};
assign NPC_PCplus4 = PC + 4;
assign extimm26 = {PC[31:28],imm26,2'b0};
assign extimm16 = signimm16 + PC + 4;

assign NPC = (NPCsle == 3'b000) ? NPC_PCplus4 :
             (NPCsle == 3'b001) ? extimm26 :
             (NPCsle == 3'b010) ? GRF :
             (NPCsle == 3'b011 && zero) ? extimm16 :
             (NPCsle == 3'b100) ? EPCOut :
             (NPCsle == 3'b101) ? 32'h00004180 :
             NPC_PCplus4;

endmodule