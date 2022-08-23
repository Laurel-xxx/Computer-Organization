module testbench;
    reg clk,rst;

    initial begin
        clk=1'b1;
        rst=1'b1;
        #40 rst=0;
    end

    always #20 clk=~clk;

    PipelineCPU pipelinecpu(clk,rst);

endmodule