module NPC(input [31:0] pc,
            output reg[31:0] nextpc,
            input [25:0] target,
            input Jump,
            input Branch,
            input Zero,
            input [15:0] imm16,
            input [5:0]op,
            input [5:0]func,
            input [31:0]busA,
            input [4:0]rt,
            input jalr_jr);

    wire[29:0] imm30;
    wire[31:0] imm32;

    signext #(16,30) signext1(imm16,imm30);
    assign imm32={imm30,2'b00};

    wire[31:0] normal_npc=pc+4; //顺序执行时下一条地址
    wire[31:0] branch_npc=pc+imm32; //分支指令的下一条地址
    
    always@(*) begin
        case(op)
            6'b000100:nextpc=(Zero&Branch)?branch_npc:normal_npc; //beq指令，相等则跳转
            6'b000101:nextpc=(!Zero&Branch)?branch_npc:normal_npc; //bne指令，不相等则跳转
            6'b000110:nextpc=(Branch&&(busA==0||busA[31]==1))?branch_npc:normal_npc; //blez指令,rs小于等于0则跳转
            6'b000111:nextpc=(Branch&&(busA!=0&&busA[31]==0))?branch_npc:normal_npc; //bgtz指令，rs大于0则跳转
            6'b000010:nextpc={pc[31:28],target[25:0],2'b00}+32'h0000_3000; //j指令，跳转至target处
            6'b000011:nextpc={pc[31:28],target[25:0],2'b00}+32'h0000_3000; //jal指令，跳转至target处
            6'b000001:
                begin //区分两者依靠的是rt的值
                    if(Branch&&rt==1) //bgez指令，rs大于等于0则跳转
                        nextpc=(busA[31]==0)?branch_npc:normal_npc;
                    else if(Branch&&rt==0) //bltz指令，rs小于0则跳转
                        nextpc=(busA[31]==1&&busA!=0)?branch_npc:normal_npc;
                end
            6'b000000:
                begin
                    if(jalr_jr) //jalr和jr指令，需跳转至寄存器rs内容的地址处，此时为busA
                    begin
                        nextpc=32'h0000_3000+busA;
                    end
                    else //其余的R型指令
                        nextpc=normal_npc;
                end
            default:nextpc=normal_npc;
        endcase
    end

endmodule