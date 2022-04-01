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