module myDFF (clk, D, Q, RST, CLR);
    input clk, D, RST, CLR;  // Clock, data input, reset, and clear signals
    output reg Q;           // Output Q (flip-flop state)

    always @(posedge clk or posedge RST) begin
        if (RST)              // If reset signal is asserted (active high)
            Q <= 1'b0;        // Set Q to logic low (reset)
        else if (CLR)         // If clear signal is asserted
            Q <= 1'b0;        // Set Q to logic low (clear)
        else
            Q <= Q + D;       // Otherwise, capture input D on positive clock edge
    end
endmodule
