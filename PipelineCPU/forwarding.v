module forwarding(input clk,
                    input MemRead,
                    input [4:0] rs_EX,
                    input [4:0] rt_EX,
                    input [4:0] rw_MEM,
                    input [4:0] rw_WR,
                    input RegWr_MEM,
                    input RegWr_WR,
                    input ALUSrc,
                    output reg[1:0] ALUSrc_A,
                    output reg[1:0] ALUSrc_B,
                    output reg Din_rt,
                    input MemWr_EX,
                    input [4:0] rs_id,
                    input [4:0] rt_id,
                    output reg rs_sel,
                    output reg rt_sel,
                    output reg[4:0] rs_sel_id,
                    output reg[4:0] rt_sel_id);

    always@(*) begin
        if(MemRead) //上上条指令是load指令，故此时不影响当前指令的取值
            ALUSrc_A<=2'b00;
        else if(MemWr_EX==1&&(rw_MEM==rs_EX)&&(rw_MEM!=0)) //接收Mem段的转发结果
            ALUSrc_A<=2'b01;
        else if(RegWr_MEM==1&&(rw_MEM!=0)&&(rw_MEM==rs_EX)) //接收Mem段的转发结果
            ALUSrc_A<=2'b01;
        else if(RegWr_WR==1&&(rw_WR!=0)&&(rw_MEM!=rs_EX)&&(rw_WR==rs_EX)) //接收Wr段的转发结果
            ALUSrc_A<=2'b10;
        else if(MemWr_EX==1&&(rw_WR!=0)&&(rw_WR==rs_EX)) //接收Wr段的转发结果
            ALUSrc_A<=2'b10;
        else
            ALUSrc_A<=2'b00;
        if(ALUSrc==1) //此时ALUSrc_B的值为11，即后续选择立即数进行运算
            ALUSrc_B<=2'b11;
        else if(MemRead) //上上条指令是load指令，故此时不影响当前指令的取值
            ALUSrc_B<=2'b00;
        else if(RegWr_MEM==1&&(rw_MEM!=0)&&(rw_MEM==rt_EX)) //接收Mem段的转发结果
            ALUSrc_B<=2'b01;
        else if(RegWr_WR==1&&(rw_WR!=0)&&(rw_MEM!=rt_EX)&&(rw_WR==rt_EX)) //接收Wr段的转发结果
            ALUSrc_B<=2'b10;
        else
            ALUSrc_B<=2'b00;
        if(MemWr_EX==1&&(rw_MEM!=0)&&(rw_MEM==rt_EX))
            Din_rt<=1;
        else 
            Din_rt<=0;
    end

    always@(posedge clk) begin
        if(RegWr_WR==1&&(rw_WR!=0)&&(rw_WR==rs_id)) //Wr段的写寄存器是ID段需要取的寄存器
        begin
            rs_sel<=1;
            rs_sel_id<=rs_id;
        end    
        else 
        begin
            rs_sel<=0;
            rs_sel_id<=0;
        end
        if(RegWr_WR==1&&(rw_WR!=0)&&(rw_WR==rt_id)) ////Wr段的写寄存器是ID段需要取的寄存器
        begin
            rt_sel<=1;
            rt_sel_id<=rt_id;
        end
        else 
        begin
            rt_sel<=0;
            rt_sel_id<=0;
        end
    end

endmodule