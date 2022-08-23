module PipelineCPU(input clk,input reset);

    //IF signals
    wire[31:0] pc_if,instruction_in,npc;
    wire[1:0] bubble_load,bubble_contr;
    wire bubble;

    //ID signals
    wire Branch_beq_id,Branch_bne_id,bgez_id,bgtz_id,blez_id,bltz_id,lw_id,LB_id,LBU_id,link_id,SB_id,Jalr_id,Jal_id,Jump_id,RegDst_id,
        RegWr_id,MemtoReg_id,MemWr_id,ALUSrc_id,ExtOp_id,mfhi_id,mflo_id,mtlo_id,mthi_id,mult_id,mfc0_id,mtc0_id,syscall_id,eret_id;
    wire[4:0] rs_id,rt_id,rd_id,shf_id,ALUctr_id,cpnum_id;
    wire[5:0] op,func;
    wire[25:0] target_id;
    wire[15:0] imm16_id;
    wire[31:0] pc_id,instruction,busA_id,busB_id,real_busA_id,real_busB_id,eret_pc_id,CP0_out;

    //EX signals
    wire[15:0] imm16_ex;
    wire[25:0] target_ex;
    wire[4:0] rt_ex,rs_ex,rd_ex,ALUctr_ex,shf_ex,rw_ex,cpnum_ex;
    wire[31:0] pc_ex,busA_ex,busB_ex,bus_rs_ex,Result_ex,imm32_ex,real_busA_ex,real_busB_ex,real_busB_ex_1,real_busB_sel_1,eret_pc_ex,final_busA_ex,final_busB_ex,real_eret_pc_id;
    wire MemWr_ex,Branch_beq_ex,Branch_bne_ex,Jump_ex,MemtoReg_ex,RegWr_ex,Zero_ex,RegDst_ex,zbgez_ex,zbgtz_ex,LB_ex,LBU_ex,Jal_ex,Jalr_ex,
        link_ex,bgez_ex,bgtz_ex,blez_ex,bltz_ex,mfhi_ex,mflo_ex,mtlo_ex,mthi_ex,mult_ex,mfc0_ex,mtc0_ex,syscall_ex,eret_ex,ALUSrc_ex,lw_ex,ExtOp_ex;
    wire[1:0] ALUSrc_A,ALUSrc_B,ALUSrc_B_1;
    wire[63:0] mult_Result_ex;
    wire SB_ex,MemRead,stall,eret_pc_change,ALUSrc_CP0_A,ALUSrc_CP0_B,mfhi_lo_mem,mfhi_lo_wr;

    //MEM signals
    wire[31:0] pc_mem,Result_mem,bus_rs_mem,busB_mem,Dout_mem,eret_pc_mem;
    wire[15:0] imm16_mem;
    wire MemtoReg_mem,RegWr_mem,link_mem,Branch_beq_mem,Branch_bne_mem,MemWr_mem,Jump_mem,Zero_mem,LBU_mem,LB_mem,Jalr_mem,Jal_mem,bgez_mem,bgtz_mem,blez_mem,
        bltz_mem,zbgez_mem,zbgtz_mem,lw_mem,mfhi_mem,mflo_mem,mthi_mem,mtlo_mem,mult_mem,mfc0_mem,mtc0_mem,syscall_mem,eret_mem,SB_mem;
    wire[25:0] target_mem;
    wire[63:0] mult_Result_mem;
    wire[4:0] rw_mem,rs_mem,rt_mem,cpnum_mem;

    //WR signals
    wire MemtoReg_wr,RegWr_wr,link_wr,LB_Wr,LBU_Wr,bubble_all,Din_sel,MemRead_Normal,rs_sel,rt_sel,mfhi_wr,mflo_wr,mthi_wr,mtlo_wr,mult_wr,mfc0_wr,mtc0_wr,syscall_wr,eret_wr;
    wire[31:0] Dout_wr,Result_wr,pc_wr,real_busW_wr,busW_wr,real_busB_next,bus_rs_id,bus_rt_id,real_busA_sel,real_busB_sel;
    wire[4:0] rw_wr,real_rw_wr,cpnum_wr,rs_sel_id,rt_sel_id,rs_wr,rt_wr;
    wire[63:0] mult_Result_wr;

    //bubble signals
    wire bubble_nob;
    wire[1:0] bubble_noblock;
    assign bubble=((bubble_load!=0)|(bubble_contr!=0)|(bubble_noblock!=0))?1:0;
    assign bubble_all=((bubble_contr!=0)|(bubble_noblock!=0))?1:0;
    assign bubble_nob=(bubble_noblock!=0)?1:0;

    ControlHazard controlhazard(clk,bgez_mem,bgtz_mem,blez_mem,bltz_mem,zbgez_mem,zbgtz_mem,Jalr_mem,Jal_mem,
    Zero_mem,Jump_mem,Branch_beq_mem,Branch_bne_mem,eret_mem,syscall_mem,bubble_contr,bubble_noblock); //定义控制冒险模块

    PC pc1(clk,reset,bubble,npc,pc_if); //定义pc模块
    NPC npc1(pc_if,pc_mem,target_mem,imm16_mem,bus_rs_mem,Branch_beq_mem,Branch_bne_mem,bgez_mem,bgtz_mem,blez_mem,bltz_mem,zbgez_mem,zbgtz_mem,Jalr_mem,Jal_mem,Zero_mem,Jump_mem,npc,eret_mem,syscall_mem,eret_pc_mem); //定义NPC下地址计算模块

    im_4k im1(pc_if[11:2],instruction_in); //定义指令存储器

    IF_ID if_id(clk,bubble,pc_if,instruction_in,instruction,pc_id,stall); //定义IF_ID段寄存器

    Decoder decoder(clk,instruction,real_busW_wr,real_rw_wr,RegWr_wr,imm16_id,busA_id,
    busB_id,rs_id,rt_id,rd_id,shf_id,target_id,op,func,LB_Wr,LBU_Wr,Result_wr,
    rs_sel,rt_sel,bus_rs_id,bus_rt_id,rs_sel_id,rt_sel_id,mfhi_wr,mflo_wr,mthi_wr,mtlo_wr,mult_wr,
    mult_Result_wr,mfc0_wr,mtc0_wr,syscall_wr,eret_wr,eret_pc_id,pc_wr,cpnum_wr,cpnum_id,rs_wr,rt_wr,
    cpnum_mem,CP0_out); //定义译码模块

    Control control(op,func,rs_id,rt_id,RegDst_id,ALUSrc_id,MemtoReg_id,
    RegWr_id,MemWr_id,ExtOp_id,Branch_beq_id,Branch_bne_id,bgez_id,bgtz_id,blez_id,
    bltz_id,Jalr_id,Jal_id,lw_id,LB_id,LBU_id,Jump_id,ALUctr_id,link_id,SB_id,
    mfhi_id,mflo_id,mtlo_id,mthi_id,mult_id,mfc0_id,mtc0_id,syscall_id,eret_id); //定义控制器

    ID_EX id_ex(clk,bubble,pc_id,target_id,imm16_id,busA_id,busB_id,rt_id,Branch_beq_id,Branch_bne_id,Jump_id,RegDst_id,ALUSrc_id,MemtoReg_id,
    ALUctr_id,lw_id,bgez_id,bgtz_id,RegWr_id,ExtOp_id,Jal_id,shf_id,rs_id,rd_id,Jalr_id,blez_id,bltz_id,LBU_id,LB_id,MemWr_id,link_id,SB_id,
    mult_id,mfhi_id,mflo_id,mthi_id,mtlo_id,mfc0_id,mtc0_id,syscall_id,eret_id,real_eret_pc_id,cpnum_id,pc_ex,target_ex,imm16_ex,busA_ex,busB_ex,rt_ex,Branch_beq_ex,Branch_bne_ex,Jump_ex,RegDst_ex,
    ALUSrc_ex,MemtoReg_ex,ALUctr_ex,lw_ex,bgez_ex,bgtz_ex,RegWr_ex,ExtOp_ex,Jal_ex,shf_ex,rs_ex,rd_ex,Jalr_ex,blez_ex,bltz_ex,LBU_ex,LB_ex,MemWr_ex,link_ex,SB_ex,
    mult_ex,mfhi_ex,mflo_ex,mthi_ex,mtlo_ex,mfc0_ex,mtc0_ex,syscall_ex,eret_ex,eret_pc_ex,cpnum_ex); //定义ID_EX段寄存器

    assign MemRead=(LB_ex||LBU_ex||lw_ex)?1:0; //译码和取数时判断上一条指令是否为load指令
    assign MemRead_Normal=(LB_mem|LBU_mem|lw_mem)?1:0; //译码和取数时判断上上条指令是否为load指令

    Load_Use load_use(clk,MemRead,rs_id,rt_id,rt_ex,bubble_load,stall); //定义load-use模块用于处理冒险
    extend16to32 ext_1(imm16_ex,imm32_ex,ExtOp_ex); //16位立即数扩展为32位

    forwarding_CP0 forw_cp0(rs_ex,rt_ex,rw_mem,mfc0_mem,rw_wr,mfc0_wr,ALUSrc_ex,
    eret_id,cpnum_ex,mtc0_ex,ALUSrc_CP0_A,ALUSrc_CP0_B,eret_pc_change); //定义CP0寄存器的转发模块

    forwarding forw(clk,MemRead_Normal,rs_ex,rt_ex,rw_mem,rw_wr,RegWr_mem,RegWr_wr,ALUSrc_ex,ALUSrc_A,ALUSrc_B,Din_sel,MemWr_ex,
    rs_id,rt_id,rs_sel,rt_sel,rs_sel_id,rt_sel_id); //定义转发模块

    forwarding_forB forw_forB(clk,MemRead_Normal,rs_ex,rt_ex,rw_mem,rw_wr,RegWr_mem,RegWr_wr,ALUSrc_B_1); //定义转发模块

    assign real_busA_ex=(ALUSrc_A==2'b00)?busA_ex:(ALUSrc_A==2'b01)?Result_mem:busW_wr; //根据ALUSrc_A的值进行数据选择
    assign real_busB_ex=(ALUSrc_B==2'b00)?busB_ex:(ALUSrc_B==2'b01)?Result_mem:(ALUSrc_B==2'b10)?busW_wr:imm32_ex; //根据ALUSrc_B的值进行数据选择

    assign real_busA_sel=(rs_sel==1&&ALUSrc_A==2'b00)?bus_rs_id:real_busA_ex; //用于保存rs寄存器中取出的值
    assign real_busB_sel=(rt_sel==1&&ALUSrc_B==2'b00)?bus_rt_id:real_busB_ex; //用于保存rt寄存器中取出的值
    
    assign real_busB_ex_1=(ALUSrc_B_1==2'b00)?busB_ex:(ALUSrc_B_1==2'b01)?Result_mem:busW_wr;
    assign real_busB_sel_1=(rt_sel==1&&ALUSrc_B==2'b00)?bus_rt_id:real_busB_ex_1;
    assign real_busB_next=(Din_sel==0)?real_busB_sel_1:Result_mem;

    assign final_busA_ex=(ALUSrc_CP0_A==1)?CP0_out:real_busA_sel; //ALU最终的A口输入
    assign final_busB_ex=(ALUSrc_CP0_B==1)?CP0_out:real_busB_sel; //ALU最终的B口输入

    mux_32bit mux5(eret_pc_id,real_busB_sel,eret_pc_change,real_eret_pc_id); //CP0转发解决冒险

    ALU alu(ALUctr_ex,final_busA_ex,final_busB_ex,shf_ex,Result_ex,Zero_ex,zbgez_ex,zbgtz_ex,mult_Result_ex); //定义ALU运算器

    mux_5bit mux4(rt_ex,rd_ex,RegDst_ex,rw_ex);

    assign bus_rs_ex=real_busA_sel; //rs寄存器中取出的值

    EX_MEM ex_mem(clk,bubble_all,MemWr_ex,Branch_beq_ex,Branch_bne_ex,Jump_ex,MemtoReg_ex,target_ex,imm16_ex,Result_ex,RegWr_ex,Zero_ex,
    rw_ex,pc_ex,bus_rs_ex,real_busB_next,bgez_ex,bgtz_ex,blez_ex,bltz_ex,zbgez_ex,zbgtz_ex,LB_ex,LBU_ex,Jal_ex,Jalr_ex,link_ex,SB_ex,lw_ex,
    mult_ex,mfhi_ex,mflo_ex,mthi_ex,mtlo_ex,mfc0_ex,mtc0_ex,syscall_ex,eret_ex,mult_Result_ex,eret_pc_ex,cpnum_ex,rs_ex,rt_ex,
    MemWr_mem,Branch_beq_mem,Branch_bne_mem,Jump_mem,MemtoReg_mem,RegWr_mem,Zero_mem,rw_mem,pc_mem,Result_mem,bus_rs_mem,busB_mem,target_mem,imm16_mem,
    bgez_mem,bgtz_mem,blez_mem,bltz_mem,zbgez_mem,zbgtz_mem,LBU_mem,LB_mem,Jalr_mem,Jal_mem,link_mem,SB_mem,lw_mem,
    mult_mem,mfhi_mem,mflo_mem,mthi_mem,mtlo_mem,mfc0_mem,mtc0_mem,syscall_mem,eret_mem,mult_Result_mem,eret_pc_mem,cpnum_mem,rs_mem,rt_mem); //定义EX_MEM寄存器

    dm_4k dm(Result_mem[11:0],busB_mem,MemWr_mem,clk,SB_mem,Dout_mem); //定义数据存储器

    MEM_WR mem_wr(clk,bubble_nob,MemtoReg_mem,RegWr_mem,Dout_mem,Result_mem,pc_mem,rw_mem,link_mem,LB_mem,LBU_mem,mult_mem,mfhi_mem,mflo_mem,
    mthi_mem,mtlo_mem,mfc0_mem,mtc0_mem,syscall_mem,eret_mem,mult_Result_mem,cpnum_mem,rs_mem,rt_mem,Dout_wr,Result_wr,pc_wr,rw_wr,MemtoReg_wr,
    RegWr_wr,link_wr,LB_Wr,LBU_Wr,mult_wr,mfhi_wr,mflo_wr,mthi_wr,mtlo_wr,mfc0_wr,mtc0_wr,syscall_wr,eret_wr,mult_Result_wr,cpnum_wr,rs_wr,rt_wr); //定义MEM_WR段寄存器

    mux_5bit mux1(rw_wr,5'b11111,link_wr,real_rw_wr); //31号寄存器进行选择
    mux_32bit mux2(Result_wr,Dout_wr,MemtoReg_wr,busW_wr);
    mux_32bit mux3(busW_wr,pc_wr+8,link_wr,real_busW_wr);

endmodule