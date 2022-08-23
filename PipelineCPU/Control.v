module Control(input [5:0] op,
                input [5:0] func,
                input [4:0] rs,
                input [4:0] rt,
                output RegDst,
                output ALUSrc,
                output MemtoReg,
                output RegWr,
                output MemWr,
                output Extop,
                output Branch_beq,
                output Branch_bne,
                output Bgez,
                output Bgtz,
                output Blez,
                output Bltz,
                output Jalr,
                output Jal,
                output lw,
                output LB,
                output LBU,
                output Jump,
                output [4:0] ALUctr,
                output link,
                output SB,
                output mfhi,
                output mflo,
                output mtlo,
                output mthi,
                output mult,
                output mfc0,
                output mtc0,
                output syscall,
                output eret);

    wire Rtype; //判断是否是R型指令
    wire[4:0] ALUOp,funcop; //主控制块和ALU局部控制块，最后通过是否是R型指令来对其进行选择

    assign  RegDst=!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0];
    assign  ALUSrc=(!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0])|(op[5]&!op[4]&!op[2]&op[1]&op[0])|(!op[5]&!op[4]&op[3]&!op[2]&op[1])|(op[5]&!op[4]&!op[3]&!op[1]&!op[0])|(op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0])|(!op[5]&!op[4]&op[3]&op[2]);
    assign  MemtoReg=(op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|(op[5]&!op[4]&!op[3]&!op[1]&!op[0]);
    assign  RegWr=((!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0])&&((!func[5]&!func[4]&func[3]&!func[2]&!func[1]&!func[0])==0)&&((!func[5]&!func[4]&func[3]&func[2]&!func[1]&!func[0])==0)&((!func[5]&func[4]&!func[3]&!func[2]&!func[1]&func[0])==0)&((!func[5]&func[4]&!func[3]&!func[2]&func[1]&func[0])==0)&((!func[5]&func[4]&!func[3]&!func[2]&!func[1]&!func[0])==0)&((!func[5]&func[4]&!func[3]&!func[2]&func[1]&!func[0])==0)&((!func[5]&func[4]&func[3]&!func[2]&!func[1]&!func[0])==0))|(!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0])|(!op[5]&!op[4]&op[3]&op[2])|(!op[4]&!op[3]&!op[2]&op[1]&op[0])|(!op[5]&!op[4]&op[3]&!op[2]&op[1])|(op[5]&!op[4]&!op[3]&!op[1]&!op[0]);
    assign  MemWr=(op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0])|(op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0]);
    assign  Extop=(!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0])|(!op[5]&!op[4]&op[3]&!op[2]&op[1]&!op[0])|(op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0])|(op[5]&!op[4]&!op[2]&op[1]&op[0])|(op[5]&!op[4]&!op[3]&!op[1]&!op[0])|(!op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0]);
    assign  Branch_beq=(!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0]);
    assign  Branch_bne=(!op[5]&!op[4]&!op[3]&op[2]&!op[1]&op[0]);
    assign  Bgez=(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&op[0])&(!rt[4]&!rt[3]&!rt[2]&!rt[1]&rt[0]);
    assign  Bgtz=(!op[5]&!op[4]&!op[3]&op[2]&op[1]&op[0]);
    assign  Blez=(!op[5]&!op[4]&!op[3]&op[2]&op[1]&!op[0]);
    assign  Bltz=(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&op[0])&(!rt[4]&!rt[3]&!rt[2]&!rt[1]&!rt[0]);
    assign  Jalr=(!func[5]&!func[4]&func[3]&!func[2]&!func[1])&(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);//jalr and jr
    assign  Jal=(!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]);//jal
    assign  lw=(op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]);
    assign  LB=(op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
    assign  LBU=(op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0]);
    assign  Jump=(!op[5]&!op[4]&!op[3]&!op[2]&op[1]&!op[0]);//j
    assign  ALUOp[0]=(!op[5]&!op[4]&!op[3]&op[2]&!op[1])|(!op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0])|(!op[5]&!op[4]&op[3]&op[2]&!op[1]);
    assign  ALUOp[1]=(!op[5]&!op[4]&op[3]&!op[2]&op[1]&!op[0])|(!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|(!op[5]&!op[4]&op[3]&op[2]&!op[0]);
    assign  ALUOp[2]=(!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0])|(!op[5]&!op[4]&op[3]&op[2]&op[1]&!op[0]);
    assign  ALUOp[3]=(!op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0])|(!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]);
    assign  ALUOp[4]=(!op[5]&!op[4]&op[3]&op[2]&op[1]&op[0]);
    assign  funcop[0]=(!func[5]&!func[4]&!func[3]&!func[2]&func[1]&func[0])|(!func[5]&!func[4]&!func[3]&func[2]&func[1]&!func[0])|(func[5]&!func[4]&!func[3]&func[2]&!func[1])|(func[5]&!func[4]&!func[2]&func[1]&func[0])|(!func[5]&!func[4]&!func[2]&!func[1]&!func[0]);
    assign  funcop[1]=(func[5]&!func[4]&func[3]&!func[2]&func[1]&!func[0])|(!func[5]&!func[4]&!func[3]&!func[2]&!func[1]&!func[0])|(func[5]&!func[4]&!func[3]&func[2]&!func[0])|(!func[5]&!func[4]&func[3]&!func[2]&!func[1])|(!func[5]&!func[4]&!func[3]&func[2]&func[1]);
    assign  funcop[2]=(!func[4]&!func[3]&func[2]&func[1]&!func[0])|(func[5]&!func[4]&!func[3]&func[2]&func[0])|(!func[5]&!func[4]&!func[3]&!func[1]&!func[0])|(!func[5]&!func[4]&!func[3]&func[1]&func[0]);
    assign  funcop[3]=(func[5]&!func[4]&func[3]&!func[2]&func[1]&func[0])|(!func[5]&!func[4]&!func[3]&func[2]&!func[1]&!func[0])|(!func[5]&!func[4]&!func[3]&!func[2]&func[1])|(!func[5]&!func[4]&func[3]&!func[2]&!func[1])|(!func[5]&!func[4]&!func[3]&func[2]&func[1]);
    assign  funcop[4]=0;
    assign  Rtype=!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0];
    assign  ALUctr=(Rtype==1)?funcop:ALUOp;
    assign  link=(!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|((!func[5]&!func[4]&func[3]&!func[2]&!func[1]&func[0])&(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]));
    assign  SB=(op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0]);
    assign  mfhi=(!func[5]&func[4]&!func[3]&!func[2]&func[1]&!func[0])&(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
    assign  mflo=(!func[5]&func[4]&!func[3]&!func[2]&!func[1]&!func[0])&(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
    assign  mtlo=(!func[5]&func[4]&!func[3]&!func[2]&func[1]&func[0])&(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
    assign  mthi=(!func[5]&func[4]&!func[3]&!func[2]&!func[1]&func[0])&(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
    assign  mult=(!func[5]&func[4]&func[3]&!func[2]&!func[1]&!func[0])&(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
    assign  mfc0=(!op[5]&op[4]&!op[3]&!op[2]&!op[1]&!op[0])&(!rs[4]&!rs[3]&!rs[2]&!rs[1]&!rs[0]);
    assign  mtc0=(!op[5]&op[4]&!op[3]&!op[2]&!op[1]&!op[0])&(!rs[4]&!rs[3]&rs[2]&!rs[1]&!rs[0]);
    assign  eret=(!func[5]&func[4]&func[3]&!func[2]&!func[1]&!func[0])&(!op[5]&op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
    assign  syscall=(!func[5]&!func[4]&func[3]&func[2]&!func[1]&!func[0])&(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);

endmodule