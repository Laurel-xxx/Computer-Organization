module Load_Use(input clk,
                input MemRead,
                input [4:0] rs_ID,
                input [4:0] rt_ID,
                input [4:0] rt_EX,
                output [1:0] bubble,
                output stall);

    reg[1:0] bubble_load_use;
    reg stall_load_use;

    initial begin
        bubble_load_use=0;
        stall_load_use=0;
    end

    assign bubble=bubble_load_use;
    assign stall=stall_load_use;

    always@(posedge clk or MemRead) begin
        if(MemRead&&((rt_EX==rt_ID)||(rt_EX==rs_ID))) //上一条是load指令，发生load-use数据冒险,阻塞信号和bubble信号都置1
        begin
            bubble_load_use<=2'b01;
            stall_load_use<=1;
        end
        else if(bubble_load_use!=0||stall_load_use!=0) //每个时钟周期到来，阻塞信号和bubble信号都需要减1
        begin
            if(bubble_load_use!=0)
                bubble_load_use<=bubble_load_use-1;
            if(stall_load_use!=0)
                stall_load_use<=stall_load_use-1;
        end
    end

endmodule