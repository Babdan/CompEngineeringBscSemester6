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
