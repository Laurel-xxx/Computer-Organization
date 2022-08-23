module forwarding_forB(input clk,
                    input MemRead,
                    input [4:0] rs_EX,
                    input [4:0] rt_EX,
                    input [4:0] rw_MEM,
                    input [4:0] rw_WR,
                    input RegWr_MEM,
                    input RegWr_WR,
                    output reg[1:0] ALUSrc_B);

    always@(*) begin
        if(MemRead) //当前指令上上条指令是load指令，不受影响
            ALUSrc_B<=2'b00;
        else if(RegWr_MEM==1&&(rw_MEM!=0)&&(rw_MEM==rt_EX)) //当前指令的源操作数是上一条指令的目的操作数
            ALUSrc_B<=2'b01;
        else if(RegWr_WR==1&&(rw_WR!=0)&&(rw_MEM!=rt_EX)&&(rw_WR==rt_EX)) //当前指令的源操作数是上上条指令的目的操作数
            ALUSrc_B<=2'b10;
        else //不受影响
            ALUSrc_B<=2'b00;
    end

endmodule