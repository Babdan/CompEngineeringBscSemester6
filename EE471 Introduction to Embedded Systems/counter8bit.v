module counter8bit(input clk, input reset, input stop, output reg [7:0] count);
    // Inputs: clk (clock), reset (asynchronous reset), stop (to pause counting)
    // Output: count (8-bit counter value)

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            count <= 8'b0;  // Reset the count value to 0
        end else begin
            if (stop)
                count <= count;  // Hold the count value if stop is asserted
            else
                count <= count + 1;  // Increment count on each positive clock edge
        end
    end
endmodule
