//full adder
module full_adder(sum,cout,a,b,cin);
	output sum,cout;
	input a,b,cin;
	assign sum = a^b^cin;
	assign cout = (a&b)|(cin&a)|(b&cin);
endmodule

// 5bit subtractor
module sub_5bits(d,bout,x,y,bin);
	output [4:0]d;
	output bout;
	input [4:0]x;
	input [4:0]y;
	input bin;
	wire [3:0]b;
	
	full_adder sub1(d[0],b[0],x[0],~y[0],1);
	full_adder sub2(d[1],b[1],x[1],~y[1],b[0]);
	full_adder sub3(d[2],b[2],x[2],~y[2],b[1]);
	full_adder sub4(d[3],b[3],x[3],~y[3],b[2]);
	full_adder sub5(d[4],bout,x[4],~y[4],b[3]);
endmodule

module ripple_carry_15bits(sum,cout,OF,a,b,cin);
	output [14:0]sum;
	output cout,OF;
	input [14:0]a;
	input [14:0]b;
	input cin;
	wire [13:0]c;
	
	full_adder fa1(sum[0],c[0],a[0],b[0],cin);
	full_adder fa2(sum[1],c[1],a[1],b[1],c[0]);
	full_adder fa3(sum[2],c[2],a[2],b[2],c[1]);
	full_adder fa4(sum[3],c[3],a[3],b[3],c[2]);
	full_adder fa5(sum[4],c[4],a[4],b[4],c[3]);
	full_adder fa6(sum[5],c[5],a[5],b[5],c[4]);
	full_adder fa7(sum[6],c[6],a[6],b[6],c[5]);
	full_adder fa8(sum[7],c[7],a[7],b[7],c[6]);
	full_adder fa9(sum[8],c[8],a[8],b[8],c[7]);
	full_adder fa10(sum[9],c[9],a[9],b[9],c[8]);
	full_adder fa11(sum[10],c[10],a[10],b[10],c[9]);
	full_adder fa12(sum[11],c[11],a[11],b[11],c[10]);
	full_adder fa13(sum[12],c[12],a[12],b[12],c[11]);
	full_adder fa14(sum[13],c[13],a[13],b[13],c[12]);
	full_adder fa15(sum[14],cout,a[14],b[14],c[13]);
	always @(*)
	begin
		if (c[13] == cout)
		begin
			OF = 1'b0;
		end
		else
		begin
			OF = 1'b1;
		end
	end	
endmodule

module mux_2to1(y,d,s);
	output reg y;
	input s;
	input [1:0]d;
	always @(*)
	begin
		case(s)
		1'b0 : y = d[0];
		1'b1 : y = d[1];
		default : y = 1'bz;
		endcase
	end
endmodule

module mux_4to1(out,in,sel);

	input [0:3] in; 
	input [0:1] sel;
	output out;

	wire a,b,c,d,n1,n2,a1,a2,a3,a4;

	not n(n1,sel[1]); 
	not nn(n2,sel[0]);
	and (a1,in[0],n1,n2);
	and (a2,in[1],n2,sel[1]);
	and (a3,in[2],sel[0],n1); 
	and (a4,in[3],sel[0],sel[1]);
	or or1(out,a1,a2,a3,a4);

 endmodule

module mux_16to1(out,in,sel); 

    input [0:15] in; 
    input [0:3] sel;
    output out;

    wire [0:3] ma;

    mux_4to1 mux1(ma[0],in[0:3],sel[2:3]);
    mux_4to1 mux2(ma[1],in[4:7],sel[2:3]);
    mux_4to1 mux3(ma[2],in[8:11],sel[2:3]);
    mux_4to1 mux4(ma[3],in[12:15],sel[2:3]);
    mux_4to1 mux5(out,ma,sel[0:1]);

endmodule

module barrel_shifter (Y, A, S, rl);
   output [15:0] Y;

   input [15:0]  A;
   input [3:0] 	 S;
   input rl;
   
   wire [15:0] Yr;
   wire [15:0] Yl;

	//right

   mux_16to1 muxr0(Yr[15],
			      {A[15], 15'b0}, 
			      S[3:0]);
   mux_16to1 muxr1(Yr[14], 
			      {A[14], A[15], 14'b0}, 
			      S[3:0]);
   mux_16to1 muxr2(Yr[13],
			      {A[13], A[14], A[15], 13'b0}, 
			      S[3:0]);
   mux_16to1 muxr3(Yr[12], 
			      {A[12], A[13], A[14], A[15], 12'b0}, 
			      S[3:0]);
   mux_16to1 muxr4(Yr[11], 
			      {A[11], A[12], A[13], A[14], A[15], 11'b0}, 
			      S[3:0]);
   mux_16to1 muxr5(Yr[10], 
			      {A[10], A[11], A[12], A[13], A[14], A[15], 10'b0}, 
			      S[3:0]);
   mux_16to1 muxr6(Yr[9], 
			      {A[9], A[10], A[11], A[12], A[13], A[14], A[15], 9'b0}, 
			      S[3:0]);
   mux_16to1 muxr7(Yr[8], 
			      {A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15], 8'b0}, 
			      S[3:0]);
   mux_16to1 muxr8(Yr[7], 
			      {A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14], 
			      A[15], 7'b0}, 
			      S[3:0]);
   mux_16to1 muxr9(Yr[6], 
			      {A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], 
			      A[14], A[15], 6'b0}, 
			      S[3:0]);
   mux_16to1 muxr10(Yr[5], 
			      {A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], 
			      A[13], A[14], A[15], 5'b0}, 
			      S[3:0]);
   mux_16to1 muxr11(Yr[4], 
			      {A[4], A[5], A[6], A[7], A[8], A[9], A[10], A[11], 
			      A[12], A[13], A[14], A[15], 4'b0}, 
			      S[3:0]);
   mux_16to1 muxr12(Yr[3], 
			      {A[3], A[4], A[5], A[6], A[7], A[8], A[9], A[10], 
			      A[11], A[12], A[13], A[14], A[15], 3'b0}, 
			      S[3:0]);
   mux_16to1 muxr13(Yr[2], 
			      {A[2], A[3], A[4], A[5], A[6], A[7], A[8], A[9], 
			      A[10], A[11], A[12], A[13], A[14], A[15], 2'b0}, 
			      S[3:0]);
   mux_16to1 muxr14(Yr[1], 
			      {A[1], A[2], A[3], A[4], A[5], A[6], A[7], A[8], 
			      A[9], A[10], A[11], A[12], A[13], A[14], A[15], 1'b0}, 
			      S[3:0]);
   mux_16to1 muxr15(Yr[0], 
			      {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7],
			      A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15]}, 
			      S[3:0]);
	//left (mux num != yl[])

	mux_16to1 muxl0(Yl[15], 
			      A[15:0], 
			      S[3:0]);
   mux_16to1  muxl1(Yl[14], 
			      {A[14:0], 1'b0}, 
			      S[3:0]);
   mux_16to1 muxl2(Yl[13],
			      {A[13:0], 2'b0}, 
			      S[3:0]);
   mux_16to1 muxl3(Yl[12], 
			      {A[12:0], 3'b0}, 
			      S[3:0]);
   mux_16to1 muxl4(Yl[11], 
			      {A[ 11:0], 4'b0}, 
			      S[3:0]);
   mux_16to1 muxl5(Yl[10], 
			      {A[10:0], 5'b0}, 
			      S[3:0]);
   mux_16to1 muxl6(Yl[9], 
			      {A[9:0], 6'b0}, 
			      S[3:0]);
   mux_16to1 muxl7(Yl[8], 
			      {A[8:0], 7'b0}, 
			      S[3:0]);
   mux_16to1 muxl8(Yl[7], 
			      {A[7:0], 8'b0}, 
			      S[3:0]);
   mux_16to1 muxl9(Yl[6], 
			      {A[6:0], 9'b0}, 
			      S[3:0]);
   mux_16to1 muxl10(Yl[5], 
			      {A[5:0], 10'b0}, 
			      S[3:0]);
   mux_16to1 muxl11(Yl[4], 
			      {A[4:0], 11'b0}, 
			      S[3:0]);
   mux_16to1 muxl12(Yl[3], 
			      {A[3:0], 12'b0}, 
			      S[3:0]);
   mux_16to1 muxl13(Yl[2], 
			      {A[2:0], 13'b0}, 
			      S[3:0]);
   mux_16to1 muxl14(Yl[1], 
			      {A[1:0], 14'b0}, 
			      S[3:0]);
   mux_16to1 muxl15(Yl[0], 
			      {A[0], 15'b0}, 
			      S[3:0]);

	//rl?

	mux_2to1 mux0(Y[0],{Yl[0],Yr[0]}, rl);
	mux_2to1 mux1(Y[1],{Yl[1],Yr[1]}, rl);
	mux_2to1 mux2(Y[2],{Yl[2],Yr[2]}, rl);
	mux_2to1 mux3(Y[3],{Yl[3],Yr[3]}, rl);
	mux_2to1 mux4(Y[4],{Yl[4],Yr[4]}, rl);
	mux_2to1 mux5(Y[5],{Yl[5],Yr[5]}, rl);
	mux_2to1 mux6(Y[6],{Yl[6],Yr[6]}, rl);
	mux_2to1 mux7(Y[7],{Yl[7],Yr[7]}, rl);
	mux_2to1 mux8(Y[8],{Yl[8],Yr[8]}, rl);
	mux_2to1 mux9(Y[9],{Yl[9],Yr[9]}, rl);
	mux_2to1 mux10(Y[10],{Yl[10],Yr[10]}, rl);
	mux_2to1 mux11(Y[11],{Yl[11],Yr[11]}, rl);
	mux_2to1 mux12(Y[12],{Yl[12],Yr[12]}, rl);
	mux_2to1 mux13(Y[13],{Yl[13],Yr[13]}, rl);
	mux_2to1 mux14(Y[14],{Yl[14],Yr[14]}, rl);
	mux_2to1 mux15(Y[15],{Yl[15],Yr[15]}, rl);
	

endmodule

module priority_encoder(Y, A, X);  
	input [15:0]X;

	output reg [3:0]A;
	output reg [12:0]Y


	always@(*)  
	begin
		casex(X)  
			16'b1xxxxxxxxxxxxxxx:begin
				A = 4'd0;
				Y = {X[15:3]};
			end

			16'b01xxxxxxxxxxxxxx:begin
				A = 4'd1;  
				Y = {X[14:2]};
			end

			16'b001xxxxxxxxxxxxx:begin
				A = 4'd2;
				Y = {X[13:1]};
			end

			16'b0001xxxxxxxxxxxx:begin
				A = 4'd3;
				Y = {X[12:0]};
			end

			16'b00001xxxxxxxxxxx:begin
				A = 4'd4;
				Y = {X[11:0], 1'd0};
			end

			16'b000001xxxxxxxxxx:begin
				A = 4'd5;
				Y = {X[10:0], 2'd0};
			end

			16'b0000001xxxxxxxxx:begin
				A = 4'd6;
				Y = {X[9:0], 3'd0};
			end

			16'b00000001xxxxxxxx:begin
				A = 4'd7;
				Y = {X[8:0], 4'd0};
			end

			16'b000000001xxxxxxx:begin
				A = 4'd8;
				Y = {X[:70], 5'd0};
			end

			16'b0000000001xxxxxx:begin
				A = 4'd9;
				Y = {X[6:0], 6'd0};
			end

			16'b00000000001xxxxx:begin
				A = 4'd10;
				Y = {X[5:0], 7'd0};
			end

			16'b000000000001xxxx:begin
				A = 4'd11;
				Y = {X[4:0], 8'd0};
			end

			16'b0000000000001xxx:begin
				A = 4'd12;
				Y = {X[3:0], 9'd0};
			end

			16'b00000000000001xx:begin
				A = 4'd13;
				Y = {X[2:0], 10'd0};
			end

			16'b000000000000001x:begin
				A = 4'd14;
				Y = {X[1:0], 11'd0};
			end
			16'b0000000000000001:begin
				A = 4'd15;
				Y = {X[0], 12'd0};
			end
			default:begin
				A = 4'd0;
				Y = {13'd0};
			end
		endcase
	end  
endmodule

module rounder (sigout, ov, sigin);

input [12:0] sigin;
output reg [10:0] sigout;
output reg ov;

always @ (*) begin
    ov = 1'b0;
    case (sigin[1])
    1'b0: sigout[10:0] = sigin[12:2];
    1'b1: {ov, sigout[10:0]} = sigin[12:2] + 1'b1;
    endcase
    
end

endmodule


module hp_adder(hp_sum, exceptions, hp_inA, hp_inB, op);

    input [15:0] hp_inA, hp_inB;
    output [15:0] hp_sum;
    output [1:0] exceptions;

	input op;

	reg [4:0] ea, eb;
	reg [12:0] ma, mb;

    ea = hp_inA[14:10]; //exponent of a 
	eb = hp_inB[14:10]; //exponent of b

	always @(*)
	begin
		if(op)
		begin
			hp_inB[15] = ~hp_inB;
		end
		else
		begin
			hp_inB[15] = ~hp_inB;
		end
	end




	always @(*)
	begin
		if(hp_inA[14:0] == 15'd0)
		begin
			ma = {1'b0, hp_inA[9:0], 2'b0};
		end
		else
		begin
			ma = {1'b1, hp_inA[9:0], 2'b0};
		end
		if(hp_inB[14:0] == 15'd0)
		begin
			mb = {1'b0, hp_inA[9:0], 2'b0};
		end
		else
		begin
			mb = {1'b1, hp_inA[9:0], 2'b0};
		end
	end

    wire [4:0] ex_diff;
    wire bor_out;
    wire bor_in = 1'b0;





    //bs_in? 
    sub_5bits sub_ex(ex_diff, bor_out, ea, eb, bor_in);
    reg [14:0] adder_in_A = 13'd0;
    reg [12:0] bs_in = A = 13'd0;


	reg [4:0] big_exp;
    always @(*)
	begin
		case(ex_diff[4])
		1'b0 :begin
			adder_in_A = {2'b0, ma};
			big_exp = ea;
		end
		1'b1 : begin
			adder_in_A = {2'b0, mb};
			big_exp = eb;
		end
		default : adder_in_A = 15'bz;
		endcase
	end

    always @(*)
	begin
		case(ex_diff[4])
		1'b0 : bs_in = mb;
		1'b1 : bs_in = ma;
		default : bs_in = 13'bz;
		endcase
	end


    //ex_diff-> ctrl??
    reg [3:0] crtl;
	always @(*)
	begin
		if(ex_diff>=5'd13)
		begin
			ctrl = 4'd13;
		end
		else
		begin
			ctrl = ex_diff[3:0];
		end
	end

	reg sign_A = 1'b0;
	reg sign_B = 1'b0;

	always @(*)
	begin
		case(ex_diff[4])
		1'b0 :begin 
			sign_A = hp_inA[15];
			sign_B = hp_inB[15];
		end
		1'b1 : begin
			sign_A = hp_inB[15];
			sign_B = hp_inA[15];
		end
		default : begin
			sign_A = 1'bz;
			sign_B = 1'bz;
		end
		endcase
	end

    // always @(*)
	// begin
	// 	case(ex_diff[4])
	// 	1'b0 : sign_B = hp_inB[15];
	// 	1'b1 : sign_B = hp_inA[15];
	// 	default : sign_B = 1'bz;
	// 	endcase
	// end

    wire [15:0] bs_out;

    barrel_shifter bs(.Y(bs_out), .A({bs_in[12:0], 3'b0} ), .S(ctrl), .rl(1'b0));

	reg [14:0] adder_in_B = {2'b00, bs_out[15:3]};

	always @(*)
	begin
		if(sign_A)
		begin
			adder_in_A = ~adder_in_A + 1'b1;
		end
		else
		begin
			adder_in_A = adder_in_A;
		end
	end

	always @(*)
	begin
		if(sign_B)
		begin
			adder_in_B = ~adder_in_B + 1'b1;
		end
		else
		begin
			adder_in_B = adder_in_B;
		end
	end


	reg [14:0] adder_out;
	reg adder_cout;
	wire ovf;

	ripple_carry_15bits adder_1(adder_out,adder_cout,adder_in_A,adder_in_B, 1'b0);

	wire [12:0] norm_out;
	wire [3:0] shamt;

	priority_encoder pri_enc_1({adder_out, 1'b0}, shamt, norm_out);

	wire[12:0] round_out;
	wire round_OF;


	rounder rnd_1(round_out, round_OF, norm_out);

	wire [9:0] final_mant;
	wire [4:0] final_exp;

	always @(*)
	begin
		case(round_OF)
		1'b0 : begin
			final_mant = round_out[12:3];
			final_exp = big_exp + shamt;
		end

		1'b1 :begin
			final_mant = {round_OF, round_out[12:4];
			final_exp = big_exp + shamt + 1;
		end
		default : begin
			final_mant = 10'bz;
			final_exp = 5'bz;
		end
		endcase
	end

	



	



	


	
endmodule

module tb_hp_adder();
	reg [15:0]A,B;
	reg operation;

	wire [15:0]out;
	wire [1:0]E;

	hp_adder uut(.hp_sum(out), .exceptions(E), .hp_inA(A), .hp_inB(B), .op(operation));
	initial 
	begin
		A = 16'd0; B = 16'd4095; operation = 1'b0;
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
		#10 A = 16'b0101001010101010; B = 16'b1110000101010101;
		#10 A = 16'b1101001010101010; B = 16'b0110000101010101;
		#10 A = 16'b0010101111111111; B = 16'b0110001111111111;
		#10 A = 16'b1010101111111111; B = 16'b1110001111111111;	
	end
	initial begin
      $monitor("A=%d, B=%d, Output=%b, Exception=%b",A,B,out,E);
    end
	initial begin
		#220 $finish;
	end
	endmodule

	

