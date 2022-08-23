module forwarding_CP0(input [4:0] rs_ex,
                        input [4:0] rt_ex,
                        input [4:0] rd_mem,
                        input mfc0_mem,
                        input [4:0] rd_wr,
                        input mfc0_wr,
                        input ALUSrc_ex,
                        input eret_id,
                        input [4:0] cpnum_ex,
                        input mtc0_ex,
                        output reg ALUSrc_CP0_A,
                        output reg ALUSrc_CP0_B,
                        output reg eret_pc_change);

    initial begin //初始化转发信号，初值为不进行转发
        ALUSrc_CP0_A=0;
        ALUSrc_CP0_B=0;
    end

    //ALUSrc_CP0_A为1表示ALU的A口需要用CP0寄存器的输出值，ALUSrc_CP0_B为1表示ALU的B口需要用CP0寄存器的输出值，需要进行转发操作
    always@(*) begin
        if(mfc0_mem&&(rs_ex==rd_mem)) //是mfc0指令且其目的操作数是随后第一条指令所用的源操作数rs
            ALUSrc_CP0_A=1;
        else if(mfc0_wr&&(rs_ex==rd_wr)) //是mfc0指令且其目的操作数是随后第二条指令所用的源操作数rs
            ALUSrc_CP0_A=1;
        else 
            ALUSrc_CP0_A=0;
        if(ALUSrc_ex==1)
            ALUSrc_CP0_B=0;
        else if(mfc0_mem&&(rt_ex==rd_mem)) //是mfc0指令且其目的操作数是随后第一条指令所用的源操作数rt
            ALUSrc_CP0_B=1;
        else if(mfc0_wr&&(rt_ex==rd_wr)) //是mfc0指令且其目的操作数是随后第二条指令所用的源操作数rt
            ALUSrc_CP0_B=1;
        else 
            ALUSrc_CP0_B=0;
        if(eret_id==1&&(cpnum_ex==5'b01110)&&mtc0_ex) //mtc0指令，且其目的操作数刚好是CPO[14]，是随后的eret指令的源操作数，此时需要设置控制信号方便后续转发
            eret_pc_change=1;
        else
            eret_pc_change=0;
    end

endmodule