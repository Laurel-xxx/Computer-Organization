module PC(input clk,
            input reset,
            input [31:0] nextPC,
            output reg[31:0] pc);

    initial begin
        pc<=32'h0000_3000;
    end

    always@(posedge clk) begin
        if(reset)
            pc<=32'h0000_3000;
        else
            pc<=nextPC;
    end

endmodule