//----4 bit binary input to 7 segment decoder
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
