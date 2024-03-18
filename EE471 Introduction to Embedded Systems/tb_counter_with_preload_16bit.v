`timescale 1ns / 1ns // Set timescale

module tb_counter_with_preload_16bit();

    // Declare signals
    reg clk;
    reg load;
    reg reset;
    reg enable;
    reg [15:0] data_in;
    wire [15:0] count;

    // Instantiate the counter module
    counter_with_preload_16bit dut (
        .clk(clk),
        .load(load),
        .reset(reset),
        .enable(enable),
        .data_in(data_in),
        .count(count)
    );

    // Clock generation
    always begin
        clk = 1'b0;
        #5 clk = 1'b1;
        #5;
    end

    // Test stimulus
    initial begin
        // Reset
        reset = 1;
        #10;
        reset = 0;

        // Test loading value
        load = 1;
        data_in = 8'h0A; // Load value 10
        #10;
        load = 0;

        // Test enabling and counting
        enable = 1;
        #100; // Wait for some cycles
        enable = 0;

        // Additional tests can be added here
        // For example: load another value and enable again
    end

endmodule
