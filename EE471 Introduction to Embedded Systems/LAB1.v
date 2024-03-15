//--Lab1 4 bit wide 2 to 1 mux
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

//---------8  bit right shift--------------
//input [7:0] in
//output [7:0] in
//assign out = {2{in[7]}, in[7:2]};

//---------testbench 4-bit mux--------------
// Testbench for 4-to-1 MUX using generate block
module tb_introlab_generate;
    reg [3:0] X, Y;
    reg s;
    wire [3:0] M;

    // Instantiate the MUX module with generate block
    introlab_generate my_mux (
        .X(X),
        .Y(Y),
        .s(s),
        .M(M)
    );

    // Initialize inputs
    initial begin
        $dumpfile("introlab_generate_tb.vcd");
        $dumpvars(0, tb_introlab_generate);

        // Test case 1: Select input Y (s = 1)
        X = 4'b1010;
        Y = 4'b1100;
        s = 1;
        #10; // Wait for some time
        // Expected output: M = Y = 4'b1100

        // Test case 2: Select input X (s = 0)
        X = 4'b1010;
        Y = 4'b1100;
        s = 0;
        #10; // Wait for some time
        // Expected output: M = X = 4'b1010

        // Add more test cases as needed

        $finish; // End simulation
    end
endmodule

//----4-to-1 multiplexer using 3x 2to1 mux
module my421mux (s1, s0, u, v ,w, x, m);
	input s0, s1;
	input [3:0] u, v, w, x;
	output [3:0] m;
	
	wire [3:0] wire1, wire2;
	introlab my1(.X(u), .Y(v), .S(s0), .M(wire1));
	introlab my2(.X(w), .Y(x), .S(s0), .M(wire2));
	introlab my3(.X(wire1), .Y(wire2), .S(s1), .M(m));
endmodule

//----Lab1 4 bit binary input to 7 segment decoder
module seg_decoder_fourbit(input [3:0] SW, output reg [6:0] HEX0);

always @(SW)
begin
    case(SW)
        4'b0000: HEX0 = 7'b1000000; // Display '0'
        4'b0001: HEX0 = 7'b1111001; // Display '1'
        4'b0010: HEX0 = 7'b0100100; // Display '2'
        4'b0011: HEX0 = 7'b0110000; // Display '3'
        4'b0100: HEX0 = 7'b0011001; // Display '4'
        4'b0101: HEX0 = 7'b0010010; // Display '5'
        4'b0110: HEX0 = 7'b0000010; // Display '6'
        4'b0111: HEX0 = 7'b1111000; // Display '7'
        4'b1000: HEX0 = 7'b0000000; // Display '8'
        4'b1001: HEX0 = 7'b0011000; // Display '9'
        4'b1010: HEX0 = 7'b0001000; // Display 'A'
        4'b1011: HEX0 = 7'b0000011; // Display 'b'
        4'b1100: HEX0 = 7'b1000110; // Display 'C'
        4'b1101: HEX0 = 7'b0100001; // Display 'd'
        4'b1110: HEX0 = 7'b0000110; // Display 'E'
        4'b1111: HEX0 = 7'b0001110; // Display 'F' - Corrected
        default: HEX0 = 7'b1111111; // Default to display nothing
    endcase
end

endmodule


//----Lab1 2 input 7 segment decoder, only showing d (00), (01)E or (10)1. (11 is nothing)
module seg_decoder_twoinput(input [1:0] SW, output reg [6:0] HEX0);

always @(SW)
begin
    case(SW)
        2'b00: HEX0 = 7'b0100001; // Display 'd'
        2'b01: HEX0 = 7'b0000110; // Display 'E'
        2'b10: HEX0 = 7'b1111001; // Display '1'
        2'b11: HEX0 = 7'b1111111; // Display nothing
        default: HEX0 = 7'b0000000; // Default to display nothing
    endcase
end

endmodule

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




//QSF CODES USED:
#============================================================
# HEX0
#============================================================
set_location_assignment PIN_AE26 -to HEX0[0]
set_location_assignment PIN_AE27 -to HEX0[1]
set_location_assignment PIN_AE28 -to HEX0[2]
set_location_assignment PIN_AG27 -to HEX0[3]
set_location_assignment PIN_AF28 -to HEX0[4]
set_location_assignment PIN_AG28 -to HEX0[5]
set_location_assignment PIN_AH28 -to HEX0[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[6]

#============================================================
# HEX1
#============================================================
set_location_assignment PIN_AJ29 -to HEX1[0]
set_location_assignment PIN_AH29 -to HEX1[1]
set_location_assignment PIN_AH30 -to HEX1[2]
set_location_assignment PIN_AG30 -to HEX1[3]
set_location_assignment PIN_AF29 -to HEX1[4]
set_location_assignment PIN_AF30 -to HEX1[5]
set_location_assignment PIN_AD27 -to HEX1[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[6]

#============================================================
# SW
#============================================================
set_location_assignment PIN_AB12 -to SW[0]
set_location_assignment PIN_AC12 -to SW[1]
