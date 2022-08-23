module ID_EX(input clk,
                input bubble,
                input [31:0] PC_in,
                input [25:0] target_in,
                input [15:0] imm16_in,
                input [31:0] busA_in,
                input [31:0] busB_in,
                input [4:0] rt_in,
                input Branch_beq_in,
                input Branch_bne_in,
                input Jump_in,
                input RegDst_in,
                input ALUSrc_in,
                input MemtoReg_in,
                input [4:0] ALUctr_in,
                input lw_in,
                input bgez_in,
                input bgtz_in,
                input RegWr_in,
                input ExtOp_in,
                input jal_in,
                input [4:0] shf_in,
                input [4:0] rs_in,
                input [4:0] rd_in,
                input jalr_in,
                input blez_in,
                input bltz_in,
                input LBU_in,
                input LB_in,
                input MemWr_in,
                input link_in,
                input SB_in,
                input mult_in,
                input mfhi_in,
                input mflo_in,
                input mthi_in,
                input mtlo_in,
                input mfc0_in,
                input mtc0_in,
                input syscall_in,
                input eret_in,
                input [31:0] eret_pc_in,
                input [4:0] cpnum_in,
                output reg[31:0] PC,
                output reg[25:0] target,
                output reg[15:0] imm16,
                output reg[31:0] busA,
                output reg[31:0] busB,
                output reg[4:0] rt,
                output reg Branch_beq,
                output reg Branch_bne,
                output reg Jump,
                output reg RegDst,
                output reg ALUSrc,
                output reg MemtoReg,
                output reg[4:0] ALUctr,
                output reg lw,
                output reg bgez,
                output reg bgtz,
                output reg RegWr,
                output reg ExtOp,
                output reg jal,
                output reg[4:0] shf,
                output reg[4:0] rs,
                output reg[4:0] rd,
                output reg jalr,
                output reg blez,
                output reg bltz,
                output reg LBU,
                output reg LB,
                output reg MemWr,
                output reg link,
                output reg SB,
                output reg mult,
                output reg mfhi,
                output reg mflo,
                output reg mthi,
                output reg mtlo,
                output reg mfc0,
                output reg mtc0,
                output reg syscall,
                output reg eret,
                output reg[31:0] eret_pc,
                output reg[4:0] cpnum);

    always@(posedge clk) begin
        if(bubble!=0) //发生冒险，将此段寄存器中的所有控制信号均清零（相当于插入了一个气泡）
        begin
            PC=0;
            target=0;
            imm16=0;
            busA=0;
            busB=0;
            rt=5'b0;
            Branch_beq=0;
            Branch_bne=0;
            Jump=0;
            RegDst=0;
            ALUSrc=0;
            MemtoReg=0;
            ALUctr=0;
            lw=0;
            bgez=0;
            bgtz=0;
            RegWr=0;
            ExtOp=0;
            jal=0;
            jalr=0;
            shf=0;
            rs=0;
            rd=0;
            blez=0;
            bltz=0;
            LBU=0;
            LB=0;
            MemWr=0;
            link=0;
            SB=0;
            mult=0;
            mfhi=0;
            mflo=0;
            mthi=0;
            mtlo=0;
            mfc0=0;
            mtc0=0;
            syscall=0;
            eret=0;
            eret_pc=0;
            cpnum=0;
        end
        else begin //否则输出等于输入
            PC=PC_in;
            target=target_in;
            imm16=imm16_in;
            busA=busA_in;
            busB=busB_in;
            rt=rt_in;
            Branch_beq=Branch_beq_in;
            Branch_bne=Branch_bne_in;
            Jump=Jump_in;
            RegDst=RegDst_in;
            ALUSrc=ALUSrc_in;
            MemtoReg=MemtoReg_in;
            ALUctr=ALUctr_in;
            lw=lw_in;
            bgez=bgez_in;
            bgtz=bgtz_in;
            RegWr=RegWr_in;
            ExtOp=ExtOp_in;
            jal=jal_in;
            jalr=jalr_in;
            shf=shf_in;
            rs=rs_in;
            rd=rd_in;
            blez=blez_in;
            bltz=bltz_in;
            LBU=LBU_in;
            LB=LB_in;
            MemWr=MemWr_in;
            link=link_in;
            SB=SB_in;
            mult=mult_in;
            mfhi=mfhi_in;
            mflo=mflo_in;
            mthi=mthi_in;
            mtlo=mtlo_in;
            mfc0=mfc0_in;
            mtc0=mtc0_in;
            syscall=syscall_in;
            eret=eret_in;
            eret_pc=eret_pc_in;
            cpnum=cpnum_in;
        end
    end

endmodule