module PC(input clk,
            input reset,
            input bubble,
            input [31:0] nextPC,
            output reg[31:0] pc);

    always@(posedge clk) begin
        if(reset)           //复位信号
            pc<=32'h0000_3034;
        else if(bubble!=0) //插入气泡，即进行空操作
            pc<=pc;
        else
            pc<=nextPC;
    end

endmodule