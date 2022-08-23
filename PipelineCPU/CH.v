module CH(input clk,
                        input bgez,
                        input bgtz,
                        input blez,
                        input bltz,
                        input Jalr,
                        input Jal,
                        input Jump,
                        input Branch_beq,
                        input Branch_bne,
                        input eret,
                        input syscall,
                        output [1:0] bubble,
                        output [1:0] bubble_noblock);

    reg[1:0] bubble_j_b,bubble_e_s;

    assign bubble=bubble_j_b; //j型指令和分支指令的气泡数
    assign bubble_noblock=bubble_e_s; //eret和syscall指令的气泡数

    initial begin //初始化气泡信号
        bubble_j_b=0;
        bubble_e_s=0;
    end

    always@(posedge clk) begin
        if(bubble_j_b!=0)
            bubble_j_b<=bubble_j_b-1;
        if(bubble_e_s!=0)
            bubble_e_s<=bubble_e_s-1;
        if(Jump) //jump、jal、jalr、beq、bne、bgez、bltz、bgtz、blez指令均浪费3个时间片，因此这里插入3个气泡
            bubble_j_b=2'b11;
        else if(Jal)
            bubble_j_b=2'b11;
        else if(Jalr)
            bubble_j_b=2'b11;
        else if(Branch_beq==1)
            bubble_j_b=2'b11;
        else if(Branch_bne==1)
            bubble_j_b=2'b11;
        else if(bgez==1)
            bubble_j_b=2'b11;
        else if(bltz==1)
            bubble_j_b=2'b11;
        else if(bgtz==1)
            bubble_j_b=2'b11;
        else if(blez==1)
            bubble_j_b=2'b11;
        if(eret==1||syscall==1) //eret和syscall指令，也会浪费3个时间片，插入3个气泡
            bubble_e_s=2'b11;
    end

endmodule