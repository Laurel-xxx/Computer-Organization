module Decoder(input clk,
                input [31:0] instruction,
                input [31:0] busW,
                input [4:0] rw,
                input RegWr,
                output [15:0] imm16,
                output [31:0] busA,
                output [31:0] busB,
                output [4:0] rs,
                output [4:0] rt,
                output [4:0] rd,
                output [4:0] shf,
                output [25:0] target,
                output [5:0] op,
                output [5:0] func,
                input LB,
                input LBU,
                input [31:0] Addr,
                input rs_sel,
                input rt_sel,
                output [31:0] bus_rs_id,
                output [31:0] bus_rt_id,
                input [4:0] rs_sel_id,
                input [4:0] rt_sel_id,
                input mfhi,
                input mflo,
                input mthi,
                input mtlo,
                input mult,
                input [63:0] mult_result,
                input mfc0,
                input mtc0,
                input syscall,
                input eret,
                output [31:0] eret_pc,
                input [31:0] pc,
                input [4:0] cpnum_in,
                output [4:0] cpnum,
                input [4:0] rs_in,
                input [4:0] rt_in,
                input [4:0] cpnum_mem,
                output [31:0] CP0_out);
    
    assign op=instruction[31:26];
    assign rs=instruction[25:21];
    assign rt=instruction[20:16];
    assign rd=instruction[15:11];
    assign shf=instruction[10:6];
    assign func=instruction[5:0];
    assign target=instruction[25:0];
    assign imm16=instruction[15:0];
    assign cpnum=instruction[15:11];

    RegFile regfile(clk,pc,RegWr,rw,rs,rt,busW,busA,busB,LB,LBU,Addr,rs_sel,rt_sel,bus_rs_id,bus_rt_id,rs_sel_id,rt_sel_id,mfhi,mflo,mthi,mtlo,mult,mult_result,mfc0,mtc0,syscall,eret,eret_pc,cpnum_in,rs_in,rt_in,cpnum_mem,CP0_out);

endmodule