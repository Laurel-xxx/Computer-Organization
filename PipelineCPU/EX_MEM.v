module EX_MEM(input clk,
                input bubble,
                input MemWr_in,
                input Branch_beq_in,
                input Branch_bne_in,
                input Jump_in,
                input MemtoReg_in,
                input [25:0] target_in,
                input [15:0] imm16_in,
                input [31:0] Result_in,
                input RegWr_in,
                input Zero_in,
                input [4:0] rw_in,
                input [31:0] pre_PC_in,
                input [31:0] bus_rs_in,
                input [31:0] busB_in,
                input bgez_in,
                input bgtz_in,
                input blez_in,
                input bltz_in,
                input zbgez_in,
                input zbgtz_in,
                input LB_in,
                input LBU_in,
                input Jal_in,
                input Jalr_in,
                input link_in,
                input SB_in,
                input lw_in,
                input mult_in,
                input mfhi_in,
                input mflo_in,
                input mthi_in,
                input mtlo_in,
                input mfc0_in,
                input mtc0_in,
                input syscall_in,
                input eret_in,
                input [63:0] mult_Result_in,
                input [31:0] eret_pc_in,
                input [4:0] cpnum_in,
                input [4:0] rs_in,
                input [4:0] rt_in,
                output reg MemWr,
                output reg Branch_beq,
                output reg Branch_bne,
                output reg Jump,
                output reg MemtoReg,
                output reg RegWr,
                output reg Zero,
                output reg[4:0] rw,
                output reg[31:0] pre_PC,
                output reg[31:0] Result,
                output reg[31:0] bus_rs,
                output reg[31:0] busB,
                output reg[25:0] target,
                output reg[15:0] imm16,
                output reg bgez,
                output reg bgtz,
                output reg blez,
                output reg bltz,
                output reg zbgez,
                output reg zbgtz,
                output reg LBU,
                output reg LB,
                output reg Jalr,
                output reg Jal,
                output reg link,
                output reg SB,
                output reg lw,
                output reg mult,
                output reg mfhi,
                output reg mflo,
                output reg mthi,
                output reg mtlo,
                output reg mfc0,
                output reg mtc0,
                output reg syscall,
                output reg eret,
                output reg[63:0] mult_Result,
                output reg[31:0] eret_pc,
                output reg[4:0] cpnum,
                output reg[4:0] rs,
                output reg[4:0] rt);

        always@(posedge clk) begin
                if(bubble!=0) //发生冒险，将此段寄存器中的所有控制信号均清零（相当于插入了一个气泡）
                begin
                        pre_PC<=0;
                        target=0;
                        imm16=0;
                        busB=0;
                        Branch_beq=0;
                        Branch_bne=0;
                        Jump=0;
                        bus_rs=0;
                        MemtoReg=0;
                        bgez=0;
                        bgtz=0;
                        RegWr=0;
                        Jal=0;
                        Jalr=0;
                        rw=0;
                        blez=0;
                        bltz=0;
                        LBU=0;
                        LB=0;
                        MemWr=0;
                        Zero=0;
                        Result=0;
                        zbgez=0;
                        zbgtz=0;
                        link=0;
                        SB=0;
                        lw=0;
                        mult=0;
                        mfhi=0;
                        mflo=0;
                        mthi=0;
                        mtlo=0;
                        mfc0=0;
                        mtc0=0;
                        syscall=0;
                        eret=0;
                        mult_Result=0;
                        eret_pc=0;
                        cpnum=0;
                        rs=0;
                        rt=0;
                end
                else begin //否则输出等于输入
                        pre_PC<=pre_PC_in;
                        target=target_in;
                        imm16=imm16_in;
                        busB=busB_in;
                        Branch_beq=Branch_beq_in;
                        Branch_bne=Branch_bne_in;
                        Jump=Jump_in;
                        bus_rs=bus_rs_in;
                        MemtoReg=MemtoReg_in;
                        bgez=bgez_in;
                        bgtz=bgtz_in;
                        RegWr=RegWr_in;
                        Jal=Jal_in;
                        Jalr=Jalr_in;
                        rw=rw_in;
                        blez=blez_in;
                        bltz=bltz_in;
                        LBU=LBU_in;
                        LB=LB_in;
                        MemWr=MemWr_in;
                        Zero=Zero_in;
                        Result=Result_in;
                        zbgez=zbgez_in;
                        zbgtz=zbgtz_in;
                        link=link_in;
                        SB=SB_in;
                        lw=lw_in;
                        mult=mult_in;
                        mfhi=mfhi_in;
                        mflo=mflo_in;
                        mthi=mthi_in;
                        mtlo=mtlo_in;
                        mfc0=mfc0_in;
                        mtc0=mtc0_in;
                        syscall=syscall_in;
                        eret=eret_in;
                        mult_Result=mult_Result_in;
                        eret_pc=eret_pc_in;
                        cpnum=cpnum_in;
                        rs=rs_in;
                        rt=rt_in;
                end
        end

endmodule