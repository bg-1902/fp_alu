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
module tb_radix4_booth_multiplier();
	reg [11:0]A,B;
	wire [23:0]out;
	
	radix4_booth_multiplier uut(.acc(out), .M(A), .Q(B));
	initial 
	begin
		A = 12'd5; B = 12'd7;
	end
	initial begin
      $monitor("A=%d, B=%d, Output=%d" ,A,B,out);
    end
	initial begin
		#220 $finish;
	end

	endmodule

// module tb_partialproduct();
//     reg [11:0]M;
//     reg [2:0]Q;
//     wire [11:0]out;

//     partialproduct uut(.pp_out(out), .q(Q), .m(M));

//     initial begin
//         M = 12'd7;  Q = 3'd0;
//         #10 Q = 3'd1;
//         #10 Q = 3'd2;
//         #10 Q = 3'd3;
//         #10 Q = 3'd4;
//         #10 Q = 3'd5;
//         #10 Q = 3'd6;
//         #10 Q = 3'd7;
//     end
//     initial begin
//       $monitor("M=%b, Q=%d, Output=%b" ,M,Q,out);
//      end
//     initial begin
//         #100 $finish;
//     end
//     endmodule



