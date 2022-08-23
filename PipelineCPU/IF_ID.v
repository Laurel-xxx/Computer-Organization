module IF_ID(input clk,
                    input bubble,
                    input [31:0] PC_in,
                    input [31:0] instruction_in,
                    output reg[31:0] instruction,
                    output reg[31:0] PC,
                    input stall);

    initial begin
        PC<=32'b0;
        instruction<=32'b0;
    end

    always@(posedge clk) begin
        if(stall) //流水线阻塞，便于下一个周期重新译码、取数
            begin
                PC<=PC;
                instruction<=instruction;
            end
        else if(bubble!=0) //插入气泡
            begin
                PC<=32'b0;
                instruction<=32'b0;
            end
        else //输出等于输入，段寄存器起到暂时保存的作用
            begin
                PC<=PC_in;
                instruction<=instruction_in;
            end
    end

endmodule