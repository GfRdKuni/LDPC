`timescale 1ns/1ps
module Output_Buffer #(
    parameter integer FULL_DATA_WIDTH    = 16,  // Number of accumulators, total bits to collect
    parameter integer DOUT_WIDTH  = 16    // Parallel output width, should match FULL_DATA_WIDTH to output all bits
)(
    input  wire                     clk,
    input  wire                     rst_n,             // Asynchronous active low reset
    input  wire [FULL_DATA_WIDTH-1:0]      acc_result,        // Output from each accumulator (1 bit/accumulator)
    input  wire [FULL_DATA_WIDTH-1:0]      acc_result_vld,    // Valid indicator for each accumulator output
    output reg  [DOUT_WIDTH-1:0]    dout,              // Parallel output data
    output reg                      dout_vld,           // Output valid pulse (1 clock cycle)
    output wire [FULL_DATA_WIDTH-1:0]      led_filled
);

    // Internal Registers
    reg [FULL_DATA_WIDTH-1:0]      buffer_data;   // Buffer to store collected bits
    reg [FULL_DATA_WIDTH-1:0]      buffer_filled;  // Counter for collected bits (0 to FULL_DATA_WIDTH-1)
    wire is_full;                                    // Flag indicating buffer is full
    
    assign led_filled = buffer_filled;

    // buffer_data Sampling
    // For each bit position:
    // - If acc_result_vld is high, update with new acc_result
    // - If acc_result_vld is low, keep the existing value
    // This allows multiple bits to be updated in the same cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer_data <= {FULL_DATA_WIDTH{1'b0}};
        end else begin
            buffer_data[0] <= acc_result_vld[0] ? acc_result[0] : buffer_data[0];
            buffer_data[1] <= acc_result_vld[1] ? acc_result[1] : buffer_data[1];
            buffer_data[2] <= acc_result_vld[2] ? acc_result[2] : buffer_data[2];
            buffer_data[3] <= acc_result_vld[3] ? acc_result[3] : buffer_data[3];
            buffer_data[4] <= acc_result_vld[4] ? acc_result[4] : buffer_data[4];
            buffer_data[5] <= acc_result_vld[5] ? acc_result[5] : buffer_data[5];
            buffer_data[6] <= acc_result_vld[6] ? acc_result[6] : buffer_data[6];
            buffer_data[7] <= acc_result_vld[7] ? acc_result[7] : buffer_data[7];
            buffer_data[8] <= acc_result_vld[8] ? acc_result[8] : buffer_data[8];
            buffer_data[9] <= acc_result_vld[9] ? acc_result[9] : buffer_data[9];
            buffer_data[10] <= acc_result_vld[10] ? acc_result[10] : buffer_data[10];
            buffer_data[11] <= acc_result_vld[11] ? acc_result[11] : buffer_data[11];
            buffer_data[12] <= acc_result_vld[12] ? acc_result[12] : buffer_data[12];
            buffer_data[13] <= acc_result_vld[13] ? acc_result[13] : buffer_data[13];
            buffer_data[14] <= acc_result_vld[14] ? acc_result[14] : buffer_data[14];
            buffer_data[15] <= acc_result_vld[15] ? acc_result[15] : buffer_data[15];
        end
    end

    // Revised logic without a for-loop, using bitwise OR to accumulate valid bits.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: clear buffer_filled to all zeros
            buffer_filled <= {FULL_DATA_WIDTH{1'b0}};
        end 
        else if (is_full) begin
            // When the buffer is full, atomically clear buffer_filled
            buffer_filled <= {FULL_DATA_WIDTH{1'b0}};
        end 
        else begin
            // Update buffer_filled: set a bit if it is already set or if the corresponding
            // bit in acc_result_vld is high.
            buffer_filled <= buffer_filled | acc_result_vld; // Modified: Replace for-loop with bitwise OR.
        end
    end


    

    // is_full Generation
    // Set is_full high for one cycle when we have collected FULL_DATA_WIDTH bits
    assign is_full = &buffer_filled;

    // Parallel Output dout
    // When buffer is full, output all collected bits
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= {DOUT_WIDTH{1'b0}};
        end 
        else if (is_full) begin
            dout <= buffer_data;  // Output all collected bits
        end
        else begin
            dout <= dout;
        end
    end

    // Output Valid Signal dout_vld
    // Generate a one-cycle pulse when new data is available
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_vld <= 1'b0;
        end 
        else begin
            dout_vld <= is_full;
        end
    end

endmodule
