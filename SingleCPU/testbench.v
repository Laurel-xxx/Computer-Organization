module testbench;
	reg clk,rst;

	initial begin
        clk=1'b0;
        rst=1'b1;
        #40 rst=0;
    end

    always #20 clk=~clk;

    SingleCPU singlecpu(clk,rst);

endmodule