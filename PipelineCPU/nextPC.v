module NPC(input [31:0] pc,
            input [31:0] previous_pc,
            input [25:0] Target,
            input [15:0] imm16,
            input [31:0] bus_rs,
            input Branch_beq,
            input Branch_bne,
            input bgez,
            input bgtz,
            input blez,
            input bltz,
            input zbgez,
            input zbgtz,
            input Jalr,
            input Jal,
            input Zero,
            input Jump,
            output reg[31:0] nextpc,
            input eret,
            input syscall,
            input [31:0] eret_pc);

    wire[29:0] imm30;
    wire[31:0] imm32;
    wire[31:0] later_pc;

    signext #(16,30) signext1(imm16,imm30); //将16位立即数符号扩展成30位
    assign imm32={imm30,2'b00}; //30位立即数低位拼接两个0，形成分支指令的偏移地址

    assign later_pc=previous_pc+4;
    wire[31:0] normal_npc=pc+4; //顺序执行时下一条地址
    wire[31:0] branch_npc=later_pc+imm32; //分支指令的下一条地址
    wire[31:0] jump_npc={later_pc[31:26],Target[25:0],2'b00}; //跳转指令的下一条地址

    always@(*) begin
        if(Jump) //跳转指令jump
            nextpc=jump_npc;
        else if(Jal) //跳转指令jal
            nextpc=jump_npc;
        else if(Jalr) //跳转指令jalr，下一条地址需从寄存器组中取出，这里直接使用取出的结果
            nextpc=bus_rs;
        else if(Branch_beq==1&&Zero==1) //分支指令beq
            nextpc=branch_npc;
        else if(Branch_bne==1&&Zero==0) //分支指令bne
            nextpc=branch_npc;
        else if(bgez==1&&zbgez==1) //分支指令bgez
            nextpc=branch_npc;
        else if(bltz==1&&zbgez==0) //分支指令bltz
            nextpc=branch_npc;
        else if(bgtz==1&&zbgtz==1) //分支指令bgtz
            nextpc=branch_npc;
        else if(blez==1&&zbgtz==0) //分支指令blez
            nextpc=branch_npc;
        else if(eret==1) //对于eret指令，下一条指令地址需考虑到CP0的冒险问题，故在CP0的转发模块中计算，这里直接使用计算结果
            nextpc=eret_pc;
        else if(syscall==1) //对于syscall指令，需将下一条指令地址置为0
            nextpc=32'b0;
        else //顺序执行
            nextpc=normal_npc;
    end

endmodule