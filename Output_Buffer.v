`timescale 1ns/1ps
module Output_Buffer #(
    parameter integer FULL_DATA_WIDTH    = 16,  // Number of accumulators
    parameter integer DOUT_WIDTH  = 8    // Parallel output width
)(
    input  wire                     clk,
    input  wire                     rst_n,             // Asynchronous active low reset
    input  wire [FULL_DATA_WIDTH-1:0]      acc_result,        // Output from each accumulator (1 bit/accumulator)
    input  wire [FULL_DATA_WIDTH-1:0]      acc_result_vld,    // Valid indicator (one-hot)
    output reg  [DOUT_WIDTH-1:0]    dout,              // Parallel output
    output reg                      dout_vld           // Output valid pulse (1 clock cycle)
);

    //—— Internal Registers —————————————————————————————————————————
    reg [DOUT_WIDTH-1:0]            buffer_data;   // Collected 8-bit data
    reg [$clog2(DOUT_WIDTH)-1:0]      buffer_count;  // Number of collected data 0…DOUT_WIDTH
    reg is_full;

    //—— buffer_data Sampling ————————————————————————————————————
    // If acc_result_vld[i] is high in each cycle, store acc_result[i] to buffer_data[buffer_count]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer_data <= {DOUT_WIDTH{1'b0}};
        end else begin
            // Assume only one-hot at a time
            for (integer i = 0; i < FULL_DATA_WIDTH; i = i + 1) begin
                if (acc_result_vld[i]) begin
                    buffer_data[buffer_count] <= acc_result[i];
                end
            end
        end
    end

    //—— buffer_count Counting ————————————————————————————————————
    // Increment by 1 for each valid data received, reset to 0 when reaching DOUT_WIDTH
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer_count <= {($clog2(DOUT_WIDTH)){1'b0}};
        end 
        else if (|acc_result_vld) begin
            if (buffer_count == DOUT_WIDTH - 1) begin
                buffer_count <= {($clog2(DOUT_WIDTH)){1'b0}};
            end
            else begin
                buffer_count <= buffer_count + 1;
            end
        end
        else begin
            buffer_count <= buffer_count;
        end
    end

    //—— is_full Generation ——————————————————————————————————————
    // Set is_full when buffer is full and new data is coming
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            is_full <= 1'b0;
        end
        else if (buffer_count == DOUT_WIDTH - 1 && |acc_result_vld) begin
            is_full <= 1'b1;
        end
        else begin
            is_full <= 1'b0;
        end
    end 
    

    //—— Parallel Output dout —————————————————————————————————————
    // When buffer is full, latch buffer_data to dout
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= {DOUT_WIDTH{1'b0}};
        end 
        else if (is_full) begin
            dout <= buffer_data;
        end
        else begin
            dout <= dout;
        end
    end

    //—— Output Valid Signal dout_vld —————————————————————————————
    // Pull high for one cycle when buffer is full
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_vld <= 1'b0;
        end 
        else begin
            dout_vld <= is_full;
        end
    end

endmodule
