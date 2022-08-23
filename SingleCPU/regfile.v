module regfile(input [31:0] addr,
                input clk,
                input reset,
                input RegWr,
                input [4:0] rd,
                input [4:0] rs,
                input [4:0] rt,
                input [31:0] busW,
                output [31:0] busA,
                output [31:0] busB,
                input [5:0] op);

    reg[31:0] regFile[31:0];
    
    integer i;
    initial begin
        for(i=0;i<32;i=i+1)
	        regFile[i]<=0;
    end

    assign busA=regFile[rs];
    assign busB=regFile[rt];

    always@(posedge clk) begin
        if(reset) begin
            for(i=0;i<32;i=i+1)
                regFile[i]<=0;
        end
        else begin
        if(RegWr) begin
            case(op)
                6'b100000: //lb指令，使用符号位扩展
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
                6'b100100: //lbu指令，使用零扩展
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
                default: regFile[rd]<=busW; //lw指令
	       endcase
        end
    end
end

endmodule