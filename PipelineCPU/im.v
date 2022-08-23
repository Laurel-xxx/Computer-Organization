module im_4k(input [11:2] addr,output [31:0] dout);

    reg [31:0]  instruction_memory[1023:0];

    assign dout=instruction_memory[addr];

    initial begin
        $readmemh("code.txt",instruction_memory);
    end

endmodule