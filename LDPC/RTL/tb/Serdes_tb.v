`timescale 1ns / 1ps

module Serdes_tb;

// Parameters
parameter BATCH_DATA_WIDTH = 16;
parameter BATCH_SIZE = 4;
parameter FULL_DATA_WIDTH = BATCH_DATA_WIDTH * BATCH_SIZE;

// Testbench signals
reg clk;
reg rst_n;
reg [BATCH_DATA_WIDTH-1:0] din;
reg din_vld;
wire [FULL_DATA_WIDTH-1:0] dout;
wire dout_vld;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
end

// Instantiate DUT
Serdes #(
    .BATCH_DATA_WIDTH(BATCH_DATA_WIDTH),
    .BATCH_SIZE(BATCH_SIZE),
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH)
) u_serdes (
    .clk(clk),
    .rst_n(rst_n),
    .din(din),
    .din_vld(din_vld),
    .dout(dout),
    .dout_vld(dout_vld)
);

// Test stimulus
initial begin
    // Initialize signals
    rst_n = 0;
    din = 0;
    din_vld = 0;
    
    // Reset sequence
    #20;
    rst_n = 1;
    
    // Test case 1: Normal operation
    $display("Test case 1: Normal operation");
    for (integer i = 0; i < BATCH_SIZE; i = i + 1) begin
        @(posedge clk);
        din = i + 1;
        din_vld = 1;
        $display("Input data[%0d] = %h", i, din);
    end
    @(posedge clk);
    din_vld = 0;
    
    // Wait for output
    @(posedge dout_vld);
    $display("Output data = %h", dout);
    
    // Test case 2: Continuous data stream
    $display("\nTest case 2: Continuous data stream");
    for (integer i = 0; i < 2 * BATCH_SIZE; i = i + 1) begin
        @(posedge clk);
        din = i + 1;
        din_vld = 1;
        $display("Input data[%0d] = %h", i, din);
    end
    @(posedge clk);
    din_vld = 0;
    
    // Wait for outputs
//    repeat(2) begin
//        @(posedge dout_vld);
//        $display("Output data = %h", dout);
//    end
    
    // Test case 3: Random data with gaps
    $display("\nTest case 3: Random data with gaps");
    for (integer i = 0; i < 3 * BATCH_SIZE; i = i + 1) begin
        @(posedge clk);
        din = $random;
        din_vld = (i % 3 != 0); // Create gaps
        if (din_vld) begin
            $display("Input data[%0d] = %h", i, din);
        end
    end
    @(posedge clk);
    din_vld = 0;
    
    // Wait for outputs
//    repeat(3) begin
//        @(posedge dout_vld);
//        $display("Output data = %h", dout);
//    end
    
    // End simulation
    #100;
    $display("\nSimulation completed");
    $finish;
end

// Monitor
always @(posedge clk) begin
    if (dout_vld) begin
        $display("Time %0t: Output valid, data = %h", $time, dout);
    end
end

endmodule 