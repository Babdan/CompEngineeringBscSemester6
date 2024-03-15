module introlab (		// 4-bit MUX
    input wire [3:0] X, // 4-bit input X
    input wire [3:0] Y, // 4-bit input Y
    input wire S,       // select input
    output wire [3:0] M // 4-bit output M
);
    assign M[0] = (~S & X[0]) | (S & Y[0]);
    assign M[1] = (~S & X[1]) | (S & Y[1]);
    assign M[2] = (~S & X[2]) | (S & Y[2]);
    assign M[3] = (~S & X[3]) | (S & Y[3]);
endmodule