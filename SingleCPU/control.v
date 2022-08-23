module Control(input [5:0] op,
            input [5:0] func,
            output RegDst,
            output ALUSrc,
            output MemtoReg,
            output RegWr,
            output MemWr,
            output Extop,
            output Branch,
            output Jump,
            output Rtype,
            output [4:0] ALUctr,
            output [4:0] ALUOp,
            output [4:0] funcop);

    assign  MemWr=(op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0])|(op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0]);
    assign  Branch=(!op[5]&!op[4]&!op[3]&op[2]&!op[1])|(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&op[0])|(!op[5]&!op[4]&!op[3]&op[2]&op[1]);
    assign  Jump=!op[5]&!op[4]&!op[3]&!op[2]&op[1];
    assign  MemtoReg=(op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|(op[5]&!op[4]&!op[3]&!op[1]&!op[0]);
    assign  Rtype=!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0];
    assign  RegDst=!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0];
    assign  ALUSrc=(!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0])|(op[5]&!op[4]&!op[2]&op[1]&op[0])|(!op[5]&!op[4]&op[3]&!op[2]&op[1])|(op[5]&!op[4]&!op[3]&!op[1]&!op[0])|(op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0])|(!op[5]&!op[4]&op[3]&op[2]);
    assign  RegWr=((!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0])&&((!func[5]&!func[4]&func[3]&!func[2]&!func[1]&!func[0])==0))|(!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0])|(!op[5]&!op[4]&op[3]&op[2])|(!op[4]&!op[3]&!op[2]&op[1]&op[0])|(!op[5]&!op[4]&op[3]&!op[2]&op[1])|(op[5]&!op[4]&!op[3]&!op[1]&!op[0]);
    assign  Extop=(!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0])|(!op[5]&!op[4]&op[3]&!op[2]&op[1]&!op[0])|(op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0])|(op[5]&!op[4]&!op[2]&op[1]&op[0])|(op[5]&!op[4]&!op[3]&!op[1]&!op[0])|(!op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0]);
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
    mux_5bit mux6(ALUOp,funcop,Rtype,ALUctr);//对主控制模块和局部控制模块进行选择，专为R型指令设置

endmodule