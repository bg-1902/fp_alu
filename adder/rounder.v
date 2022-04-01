module rounder (sigin, sigout, ov);

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

