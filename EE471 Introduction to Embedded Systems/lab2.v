//------Lab2 Comparator
module lab2_comparator(
    input [3:0] V,
    output z
);
    assign z = (V > 4'd9) ? 1'd1: 4'd0;
endmodule

//-----Lab2 Circuit A
module lab2_circuit_a(
    input [3:0] V,
    output reg [3:0] A  // Change 'output' to 'output reg'
);
    always @(V)
    begin
        case(V)
            4'b1010: A = 4'b0000; // 10 -> 0
            4'b1011: A = 4'b0001; // 11 -> 1
            4'b1100: A = 4'b0010; // 12 -> 2
            4'b1101: A = 4'b0011; // 13 -> 3
            4'b1110: A = 4'b0100; // 14 -> 4
            4'b1111: A = 4'b0101; // 15 -> 5
            default: A = 4'bXXXX; // Don't care
        endcase
    end
endmodule