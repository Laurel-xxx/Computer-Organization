module RegFile(input clk,
                input [31:0] pc,
                input RegWr,
                input [4:0] rd,
                input [4:0] rs,
                input [4:0] rt,
                input [31:0] busW,
                output [31:0] busA,
                output [31:0] busB,
                input LB,
                input LBU,
                input [31:0] addr,
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
                input [63:0] mult_Result,
                input mfc0,
                input mtc0,
                input syscall,
                input eret,
                output [31:0] eret_PC,
                input [4:0] cpnum,
                input [4:0] rs_in,
                input [4:0] rt_in,
                input [4:0] cpnum_mem,
                output [31:0] CP0_out);

    reg[31:0] regFile[31:0]; //定义寄存器组
    reg[31:0] CP0[31:0];    //定义协处理器的寄存器
    reg[31:0] HI,LO;        //定义HI和LO寄存器

    assign busA=regFile[rs]; //输出寄存器组的A口值
    assign busB=regFile[rt]; //输出寄存器组的B口值

    assign eret_PC=CP0[14]; //eret指令跳转的地址
    assign CP0_out=CP0[cpnum_mem]; //输出协处理器的寄存器的值

    //assign bus_rs_id=(rs_sel==1)?regFile[rs_sel_id]:32'b0;
    //assign bus_rt_id=(rt_sel==1)?regFile[rt_sel_id]:32'b0;
    mux_32bit mux1(32'b0,regFile[rs_sel_id],rs_sel,bus_rs_id); //处理转发
    mux_32bit mux2(32'b0,regFile[rt_sel_id],rt_sel,bus_rt_id); //处理转发

    integer i;
    initial begin   //寄存器组赋初值
        for(i=0;i<32;i=i+1)
	        regFile[i]<=0;
    end

    initial begin   //协处理器的寄存器赋初值
        for(i=0;i<32;i=i+1)
	        CP0[i]<=0;
    end

    always@(posedge clk) begin
        if(RegWr&&LB) //lb指令，使用符号位扩展
            begin
                if(addr[1:0]==2'b00)
                    regFile[rd]<={{24{busW[7]}},busW[7:0]};
                else if(addr[1:0]==2'b01)
                    regFile[rd]<={{24{busW[15]}},busW[15:8]};
                else if(addr[1:0]==2'b10)
                    regFile[rd]<={{24{busW[23]}},busW[23:16]};
                else if(addr[1:0]==2'b11)
                    regFile[rd]<={{24{busW[31]}},busW[31:24]};
            end
        else if(RegWr&&LBU) //lbu指令，使用零扩展
            begin
                if(addr[1:0]==2'b00)
                    regFile[rd]<={{24'b0},busW[7:0]};
                else if(addr[1:0]==2'b01)
                    regFile[rd]<={{24'b0},busW[15:8]};
                else if(addr[1:0]==2'b10)
                    regFile[rd]<={{24'b0},busW[23:16]};
                else if(addr[1:0]==2'b11)
                    regFile[rd]<={{24'b0},busW[31:24]};
            end
        else if(RegWr&&(LB==0)&&(LBU==0)) //lw指令
            begin
                regFile[rd]<=busW;
            end
        if(mflo) //mflo指令
            regFile[rd]<=LO;
        if(mfhi) //mfhi指令
            regFile[rd]<=HI;
        if(mthi) //mthi指令
            HI<=regFile[rs_in];
        if(mtlo) //mtlo指令
            LO<=regFile[rs_in];
        if(mult) //mult指令，将乘法结果赋给HI寄存器拼接LO寄存器
            {HI,LO}<=mult_Result;
        if(mfc0) //mfc0指令
            regFile[rt_in]<=CP0[cpnum];
        if(mtc0) //mtc0指令
            CP0[cpnum]<=regFile[rt_in];
        if(syscall) //syscall指令，对协处理器的寄存器做修改
            begin
                CP0[14]<=pc;
                CP0[13][6:2]<=5'b01000;
                CP0[12][1]<=1;
            end
        if(eret) //eret指令
            begin
                CP0[12][1]<=0;
            end
    end

endmodule