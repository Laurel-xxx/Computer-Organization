module decoder(input [31:0] Instruction,
                    output [5:0] op,
                    output [4:0] rs,
                    output [4:0] rt,
                    output [4:0] rd,
                    output [4:0] shamt,
                    output [5:0] func,
                    output [15:0] imm16,
                    output [25:0] target);

    assign op = Instruction[31:26];
    assign rs = Instruction[25:21];
    assign rt = Instruction[20:16];
    assign rd = Instruction[15:11];
    assign shamt = Instruction[10:6];
    assign func = Instruction[5:0];
    assign imm16 = Instruction[15:0];
    assign target = Instruction[25:0];

endmodule