module m21(Y, D0, D1, S);

output Y;
input D0, D1, S;
wire T1, T2, Sbar;

and (T1, D1, S), (T2, D0, Sbar);
not (Sbar, S);
or (Y, T1, T2);

endmodule
module partialproduct(pp_out, q, m);
	input [11:0] m;
	input [2:0] q;

	output reg [11:0] pp_out = 12'd0;

	always @(*)
	begin
		case(q)
		3'd0: pp_out = 12'd0;
		3'd1: pp_out = m;
		3'd2: pp_out = m;
		3'd3: pp_out = m<<1;
		3'd4: pp_out = ~(m<<1)+12'd1;
		3'd5: pp_out = ~m+12'd1;
		3'd6: pp_out = ~m + 12'd1;
		3'd7: pp_out = 12'd0;
		default: pp_out = 12'bz;
		endcase
	end
endmodule

module radix4_booth_multiplier(acc, M, Q);
	output [23:0]acc;
	// wire [23:0] acc1, acc2, acc3, acc4, acc5;

	input [11:0] M, Q;
	wire [11:0]pprod1,pprod2,pprod3,pprod4,pprod5,pprod6;
	wire [23:0] pprod1x,pprod2x,pprod3x,pprod4x,pprod5x,pprod6x;

	partialproduct pp1 (.pp_out(pprod1),.q({Q[1:0],1'b0}),.m(M));
	assign pprod1x =  $signed(pprod1);
	partialproduct pp2(pprod2,Q[3:1],M);
	assign pprod2x =  $signed({pprod2,2'd0});
	partialproduct pp3(pprod3,Q[5:3],M);
	assign pprod3x =  $signed({pprod3,4'd0});
	partialproduct pp4(pprod4,Q[7:5],M);
	assign pprod4x =  $signed({pprod4,6'd0});
	partialproduct pp5(pprod5,Q[9:7],M);
	assign pprod5x =  $signed({pprod5,8'd0});
	partialproduct pp6(pprod6,Q[11:9],M);
	assign pprod6x =  $signed({pprod6,10'd0});
	assign acc = pprod1x + pprod2x + pprod3x + pprod4x+ pprod5x + pprod6x;
	
endmodule



module hp_multiplier(hp_product,ex_flag,hp_inA,hp_inB);
	output reg[15:0]hp_product;
	output reg [1:0]ex_flag;
	input [15:0]hp_inA;
	input [15:0]hp_inB;

	reg exp_OF, exp_UF;
	
	wire A_s;
	wire B_s;
	wire [4:0]A_exp;
	wire [4:0]B_exp;
	
	assign A_s = hp_inA[15];
	assign B_s = hp_inB[15];
	assign A_exp = hp_inA[14:10];
	assign B_exp = hp_inB[14:10];
	
	
	wire product_s;
	assign product_s = A_s ^ B_s;
	
	wire [6:0]product_exp_temp;
	wire [6:0]product_exp;
	
	assign product_exp_temp = {2'b0, A_exp} + {2'b0, B_exp};
	assign product_exp = product_exp_temp - 7'd15;


	

	//booth_multiplier
	reg [11:0] ma,mb;

	// control flags
	reg [1:0] cf;


	always @(*)
	begin
		if(hp_inA[14:0] == 15'd0)
		begin
			//ma = {1'b0, hp_inA[9:0], 2'b0};
			cf = 2'b01;
		end
		else if(hp_inB[14:0] == 15'd0)
		begin
			//mb = {1'b0, hp_inA[9:0], 2'b0};
			cf = 2'b10;
		end
		else if(hp_inA[14:10] == 5'd31 || hp_inB[14:10] == 5'd31)
		begin
			cf = 2'b00;
		end
		else 
		begin
			if(hp_inA[14:10] == 5'd0)
			begin
				ma = {2'b00, hp_inA[9:0]};
				cf = 2'b11;
			end
			else 
			begin
				ma = {2'b01, hp_inA[9:0]};
				cf = 2'b11;
			end
			if(hp_inB[14:10] == 5'd0)
			begin
				mb = {2'b00, hp_inB[9:0]};
				cf = 2'b11;
			end
			else 
			begin
				mb = {2'b01, hp_inB[9:0]};
				cf = 2'b11;
			end
		end


	end

	wire [23:0]product_temp;
	radix4_booth_multiplier mult1(product_temp,ma,mb);

	reg [9:0] product_temp_norm;
	reg [6:0]product_exp_norm;
	 always @(*)
	 begin
	 	if(product_temp[21]==1)
	 	begin
	 		product_temp_norm = product_temp[20:11];
	 		product_exp_norm = product_exp + 7'd1;
			
	 	end
	 	else
		begin
	 		product_temp_norm = product_temp[19:10];
			product_exp_norm = product_exp;
		end
	 end
	always @(*)
	begin
		if($signed(product_exp_norm)>=31)
		begin
			exp_OF = 1'b1;
			exp_UF = 1'b0;
		end
		else if($signed(product_exp_norm)<0)
		begin
			exp_OF = 1'b0;
			exp_UF = 1'b1;
		end
		else
		begin
			exp_OF = 1'b0;
			exp_UF = 1'b0;
		end
	end


	always @(*)
	begin
		case(cf)
		2'b00:begin
			hp_product = 16'b0111110101010101;
			ex_flag = 2'b11;
		end

		2'b01: begin
			hp_product = 16'd0;
			ex_flag = 2'b00;
		end

		2'b10: begin
			hp_product = 16'd0;
			ex_flag = 2'b00;
		end

		2'b11: begin
			hp_product = {product_s,product_exp_norm[4:0],product_temp_norm};
			ex_flag = {exp_UF, exp_OF};
		end
		default: begin
			hp_product = 16'bz;
			ex_flag = 2'b11;
		end
	endcase
	end



endmodule


module tb_hp_multiplier();
	reg [15:0]A,B;
	wire [15:0]out;
	wire [1:0]E;
	hp_multiplier uut(.hp_product(out), .ex_flag(E), .hp_inA(A), .hp_inB(B));
	initial 
	begin
		A = 16'd0; B = 16'd4095;
		#10 A = 16'd8191; B = 16'd0;
		#10 A = 16'd0; B = 16'd0;
		#10 A = 16'b0111110101010101; B = 16'd4095;
		#10 A = 16'd8191; B  = 16'b1111110000011111;
		#10 A = 16'b1111110101010101; B = 16'd4095;
		#10 A = 16'd8191; B  = 16'b0111110000011111;
		#10 A = 16'd8191; B  = 16'b1111110000000000;
		#10 A = 16'b1111110000000000; B = 16'd4095;
		#10 A = 16'd8191; B  = 16'b0111110000000000;
		#10 A = 16'b0111110000000000; B = 16'd4095;
		#10 A = 16'b0111101010101010; B = 16'b0111100101010101;
		#10 A = 16'b1111101010101010; B = 16'b1111100101010101;
		#10 A = 16'b0000011010101010; B = 16'b0000010101010101;
		#10 A = 16'b1000011010101010; B = 16'b1000010101010101;
		#10 A = 16'b0101001010101010; B = 16'b0110000101010101;
		#10 A = 16'b1101001010101010; B = 16'b1110000101010101;
		#10 A = 16'b0010001010101010; B = 16'b0010000101010101;
		#10 A = 16'b1101001010101010; B = 16'b0110000101010101;
		#10 A = 16'b0010101111111111; B = 16'b0110001111111111;
		#10 A = 16'b1000011111111111; B = 16'b1000011111111111;
		#10 A = 16'b0100100000000000; B = 16'b0101100000000000;
		#10 A = 16'b0100100100000000; B = 16'b0100010100000000;// 10 * 5
		#10 A = 16'b0000001000000000; B = 16'b0000001000000000;
		#10 A = 16'b0000001000000000; B = 16'b0100001000000000;
	end
	initial begin
      $monitor("A=%b, B=%b, Output=%b, Exception=%b",A,B,out,E);
    end
	initial begin
		#300 $finish;
	end
	endmodule