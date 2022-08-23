module multiply(input signed[31:0] A,
                input signed[31:0] B,
                output signed [63:0] mult_result);

    assign mult_result=A*B; //mult指令，有符号数相乘

endmodule