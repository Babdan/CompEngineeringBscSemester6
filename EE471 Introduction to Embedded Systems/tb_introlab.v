// Testbench for 4-to-1 MUX
module tb_introlab;
    reg [3:0] X, Y;
    reg S;
    wire [3:0] M;

    // Instantiate the MUX module
    introlab my_mux (
        .X(X),
        .Y(Y),
        .s(S),
        .M(M)
    );

    // Initialize inputs
    initial begin

        // Test case 1: Select input Y (s = 1)
        X = 4'b1010;
        Y = 4'b1100;
        S = 1;
        #20; // Wait for some time; Expected output: M = Y = 4'b1100

        // Test case 2: Select input X (s = 0)
        X = 4'b1010;
        Y = 4'b1100;
        S = 0;
        #20; // Wait for some time; Expected output: M = X = 4'b1010

    end
endmodule