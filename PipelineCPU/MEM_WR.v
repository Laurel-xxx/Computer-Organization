module MEM_WR(input clk,
                input bubble,
                input MemtoReg_in,
                input RegWr_in,
                input [31:0] Dout_in,
                input [31:0] Result_in,
                input [31:0] PC_in,
                input [4:0] rw_in,
                input link_in,
                input LB_in,
                input LBU_in,
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
                input [4:0] cpnum_in,
                input [4:0] rs_in,
                input [4:0] rt_in,
                output reg[31:0] Dout,
                output reg[31:0] Result,
                output reg[31:0] PC,
                output reg[4:0] rw,
                output reg MemtoReg,
                output reg RegWr,
                output reg link,
                output reg LB,
                output reg LBU,
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
                output reg[4:0] cpnum,
                output reg[4:0] rs,
                output reg[4:0] rt);

    initial begin //初始化一下
        rw<=0;
        PC<=0;
        Dout<=0;
        Result<=0;
        MemtoReg<=0;
        RegWr<=0;
        link<=0;
        LB<=0;
        LBU<=0;
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
        cpnum=0;
        rs=0;
        rt=0;
    end

    always@(posedge clk) begin
        if(bubble!=0) //发生冒险，将此段寄存器中的所有控制信号均清零（相当于插入了一个气泡）
        begin
            rw<=0;
            PC<=0;
            Dout<=0;
            Result<=0;
            MemtoReg<=0;
            RegWr<=0;
            link<=0;
            LB<=0;
            LBU<=0;
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
            cpnum=0;
        end
        else begin //否则输出等于输入
            rw<=rw_in;
            PC<=PC_in;
            Dout<=Dout_in;
            Result<=Result_in;
            MemtoReg<=MemtoReg_in;
            RegWr<=RegWr_in;
            link<=link_in;
            LB<=LB_in;
            LBU<=LBU_in;
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
            cpnum=cpnum_in;
            rs=rs_in;
            rt=rt_in;
        end
    end

endmodule