module SingleCPU(input clk,input reset);

    wire[5:0] op,func;
    wire Branch,Jump,RegDst,ALUSrc,RegWr,MemtoReg,MemWr,Extop,Rtype;
    wire[4:0] ALUctr,ALUOp,funcop;
    Control control(op,func,RegDst,ALUSrc,MemtoReg,RegWr,MemWr,Extop,Branch,Jump,Rtype,ALUctr,ALUOp,funcop);
    Datapath datapath(clk,reset,Branch,Jump,RegDst,ALUSrc,MemtoReg,RegWr,MemWr,Extop,ALUctr,op,func);

endmodule