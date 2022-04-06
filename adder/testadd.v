module full_adder(sum,cout,a,b,cin);
	output sum,cout;
	input a,b,cin;
	assign sum = a^b^cin;
	assign cout = (a&b)|(cin&a)|(b&cin);
endmodule

module ripple_carry_15bits(sum,cout,OF,a,b,cin);
	output [14:0]sum;
	output cout;
	output reg OF;
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

module tb_ripple_carry_15bits();
	reg [14:0]A,B;

	wire [14:0]out;
    wire carry_out, ovf;
    reg carry_in;

	ripple_carry_15bits uut(out, carry_out, ovf, A, B, carry_in);

    initial 
	begin
		A = 15'b000001000000000; B = 15'b000001000000000; carry_in = 1'b0; //
		#10 A = 15'b110100000000011; B = 15'b001111000000000;
		#10 A = 15'b110100000000011; B = 15'b101111000000000;
		#10 A = 15'b111111111111111; B = 15'b101111111111111;//
		#10 A = 15'b000001000000000; B = 15'b000001000000000;//
		
	end
	initial begin
      $monitor("A=%b, B=%b, Output=%b, OF=%b",A,B,out,ovf);
    end
	initial begin
		#220 $finish;
	end
endmodule