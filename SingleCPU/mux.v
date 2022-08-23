module mux_32bit(input [31:0] a,input [31:0] b,input select,output [31:0] result);

    assign result=(select==1)?b:a;

endmodule

module mux_5bit(input [4:0] a,input [4:0] b,input select,output [4:0] result);

    assign result=(select==1)?b:a;

endmodule