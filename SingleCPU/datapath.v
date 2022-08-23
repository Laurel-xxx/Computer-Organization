module Datapath(input clk,
                input reset,
                input Branch,
                input Jump,
                input RegDst,
                input ALUSrc,
                input MemtoReg,
                input RegWr,
                input MemWr,
                input Extop,
                input [4:0] ALUctr,
                output [5:0] op,
                output [5:0] func);

    
    wire [31:0] pc,next_pc,busW,real_busW,busA,busB,imm32,Instruction,real_busB,Result,dout;
    wire [25:0] target;
    wire [15:0] imm16;
    wire [4:0] rd,rs,rt,shamt,real_Rw,Rw;
    wire zero,storebyte,jalr_jr,jal;

    im_4k Im(pc[11:2],Instruction); //根据pc的值从指令寄存器中取指令
    decoder Decoder(Instruction,op,rs,rt,rd,shamt,func,imm16,target); //译码，通过指令Instruction获取op,rs,rt,rd,shamt,func,imm16,target的值
    assign jalr_jr=((op==6'b000000)&&(func==6'b001001||func==6'b001000))?1:0; //判断此时是否是jalr或jr指令，并将信号添加至regfile中，便于计算下一条地址
    extend16to32 extend(imm16,imm32,Extop); //扩展16位立即数至32位
    
    assign jal=(op==6'b000011&&Jump==1)?1:0; //判断此时是否是jal指令
    assign storebyte=(op==6'b101000)?1:0; //判断此时是否是sb指令
    dm_4k dm(Result[11:0],busB,MemWr,clk,dout,storebyte); //数据存储器

    mux_5bit mux1(rt,rd,RegDst,Rw); //选择写寄存器
    mux_32bit mux2(Result,dout,MemtoReg,busW); //选择结果送给busW
    mux_32bit mux3(busW,pc+4,(jalr_jr==1||jal==1),real_busW); //虽然此时包括了jr指令，但在控制单元中设置RegWr为0即可避免写31号寄存器
    mux_5bit mux4(Rw,5'b11111,(jal==1||jalr_jr==1),real_Rw); //jal和jalr指令情况下，需将pc+4写进31号寄存器
    mux_32bit mux5(busB,imm32,ALUSrc,real_busB); //对ALU的B口输入进行选择，是32位立即数还是寄存器组的B口输出

    regfile regfile_1(Result,clk,reset,RegWr,real_Rw,rs,rt,real_busW,busA,busB,op); //寄存器组
    ALU alu(ALUctr,busA,real_busB,shamt,zero,Result); //定义ALU
    NPC NextPC(pc,next_pc,target,Jump,Branch,zero,imm16,op,func,busA,rt,jalr_jr); //计算下一个pc的值
    PC Pc(clk,reset,next_pc,pc); //PC模块，与时钟同步更新PC的值

endmodule