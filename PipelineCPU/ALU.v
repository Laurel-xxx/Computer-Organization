module ALU(input [4:0] ALUctr,
			input [31:0] busA,
			input [31:0] busB,
			input [4:0] shamt,
			output reg[31:0] Result,
			output Zero,
			output zBgez,
			output zBgtz,
			output [63:0] mult_Result);

	multiply multiply1(busA,busB,mult_Result); //专门处理有符号数乘法指令

	assign Zero=(Result==0);
	assign zBgez=(Result[31]==0);
	assign zBgtz=(Result[31]==0&&Result!=0);

	always@(*) begin
		case(ALUctr)
			5'b00000 : Result <= busA + busB; //addu指令
			5'b00001 : Result <= busA - busB; //subu指令
			5'b00010 : //slt指令和slti指令
				begin
					if(busA[31]==busB[31]&&busA<busB) //符号相同
						Result=1;
					else if(busA[31]==1&&busB[31]==0) //A负B正
						Result=1;
					else
						Result=0;
				end
			5'b00011 : Result <= busA & busB; //and指令和andi指令
			5'b00100 : Result <= (busA | busB)^32'hffffffff; //nor指令
			5'b00101 : Result <= busA | busB; //or指令和ori指令
			5'b00110 : Result <= busA ^ busB; //xor指令和xori指令
			5'b00111 : Result <= busB << shamt; //sll指令
			5'b01000 : Result <= busB >> shamt; //srl指令
			5'b01001 : Result <= (busA < busB)?1:0; //sltu指令
			5'b01010 : Result <= busA; //jalr指令
			5'b01011 : Result <= busA; //jr指令
			5'b01100 : Result <= busB << busA; //sllv指令
			5'b01101 : Result <= ($signed(busB)) >>> shamt; //sra指令
			5'b01110 : Result <= ($signed(busB)) >>> busA; //srav指令
			5'b01111 : Result <= ($unsigned(busB)) >>> busA; //srlv指令
			5'b10000 : Result <= {busB[15:0],16'b0}; //lui指令
		endcase
	end

endmodule