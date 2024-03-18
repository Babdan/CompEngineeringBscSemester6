module counter8bit14-204 (
    input clk,
    input load,
    input reset,
    input enable,
    input [7:0] data_in,
    output reg [7:0] count
);

// Declare internal signals
reg [7:0] preload_value;

always @ (posedge clk) begin
    // Reset the counter if the reset signal is asserted
    if (reset)
        count <= 8'b0;
    // Load the value on data input when load signal is 1
    else if (load)
        count <= data_in;
    // Count up when enable signal is 1
    else if (enable)
        count <= count + 1;
    // Wrap-around when count reaches 204 to 14
    if (count == 8'd204)
        count <= 8'd14;
end

endmodule
