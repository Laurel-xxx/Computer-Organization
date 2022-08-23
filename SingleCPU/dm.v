module dm_4k(input [11:0] addr,
				input [31:0] din,
				input WrEn,
				input clk,
				output [31:0] dout,
				input storebyte);

	reg[31:0] RAM[1023:0];

	assign dout = RAM[addr[11:2]];

	always@(posedge clk) begin
    	if(WrEn) begin
			if(storebyte) begin //sb指令，为了使32位存储器适配字节编址，故使用12位地址中的高10位用于选择地址，低2位用于片选字节
				if(addr[1:0]==2'b00)
					RAM[addr[11:2]][7:0]<=din[7:0]; //此时只需要接收输入din中的低8位，即一个字节
				else if(addr[1:0]==2'b01)
					RAM[addr[11:2]][15:8]<=din[7:0];
				else if(addr[1:0]==2'b10)
					RAM[addr[11:2]][23:16]<=din[7:0];
				else if(addr[1:0]==2'b11)
					RAM[addr[11:2]][31:24]<=din[7:0];
			end
			else begin //sw指令
				RAM[addr[11:2]]<=din;
			end
		end
	end

endmodule