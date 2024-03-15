//----Lab2 Topmodule:
module lab2_topmodule_binary_to_decimal(
    input [3:0] SW,
    output [6:0] HEX0,
    output [6:0] HEX1
);
    wire z;
    wire [3:0] A;
    wire [3:0] M;

    // Instantiate the comparator
    lab2_comparator comp(
        .V(SW),
        .z(z)
    );

    // Instantiate circuit A
    lab2_circuit_a circ_a(
        .V(SW),
        .A(A)
    );

    // Instantiate the 4-bit wide 2-to-1 multiplexer
    introlab mux(
        .X(SW),
        .Y(A),
        .S(z),
        .M(M)
    );

    // Instantiate the 4-bit binary input to 7-segment decoder
    seg_decoder_fourbit decoder(
        .SW(M),
        .HEX0(HEX0)
    );

    // Assign HEX1 to display '1' when z is 1 and '0' otherwise
    assign HEX1 = z ? 7'b1111001 : 7'b1000000; // '1' and '0' in 7-segment display
endmodule
