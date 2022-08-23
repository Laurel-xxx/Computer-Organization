module extend16to32 #(parameter a = 16,b = 32)(input[a-1:0] imm_in,output[b-1:0] imm_out,input Extop); //16位扩展成32位

    wire[b-a-1:0] ex_sign;
    assign ex_sign=(Extop==0)?16'h0000:{16{imm_in[a-1]}};
    assign imm_out={ex_sign,imm_in};

endmodule

module signext #(parameter before = 16,after = 30)(input [before - 1:0] x,output [after - 1:0] y); //特定用于符号扩展，专门为NPC模块设计

    assign y = {{after-before{x[before - 1]}},x};

endmodule