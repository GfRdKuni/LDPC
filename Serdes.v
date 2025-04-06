`timescale 1ns / 1ps

module Serdes 
#
(
    parameter BATCH_DATA_WIDTH = 4, // data width of each batch
    parameter BATCH_SIZE = 4, // number of batches
    parameter FULL_DATA_WIDTH = BATCH_DATA_WIDTH * BATCH_SIZE, // full data width
    parameter GENM_ROW = 4 // number of rows of generator matrix
)
(
    input wire clk, // clock
    input wire rst_n, // reset
    input wire[BATCH_DATA_WIDTH-1:0] din, // input data (one batch)
    input wire din_vld, // input data valid, high valid, indicate the input data is valid
    input wire [GENM_ROW-1:0] is_idle, // enable, high valid, indicate the system is idle
    output reg [FULL_DATA_WIDTH-1:0] dout, // output data (all batches concatenated)
    output reg dout_vld, // output data valid
    output wire din_ready // input data ready, high valid, indicate the system is ready to receive input data
);

// Internal signals
reg [$clog2(BATCH_SIZE)-1:0] write_addr; // write address
reg [BATCH_DATA_WIDTH-1:0] Internal_Mem [BATCH_SIZE-1:0]; // internal memory
reg is_full; // full flag

// Write address counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_addr <= 0;
    end
    else if (din_vld && din_ready) begin
        if (write_addr == BATCH_SIZE - 1) begin
            write_addr <= 0;
        end
        else begin
            write_addr <= write_addr + 1;
        end
    end
    else begin
        write_addr <= write_addr;
    end
end

// Memory write logic
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for (integer i = 0; i < BATCH_SIZE; i = i + 1) begin
            Internal_Mem[i] <= 0;
        end
    end
    else if (din_vld && din_ready) begin
        Internal_Mem[write_addr] <= din;
    end
    else begin
        Internal_Mem[0] <= Internal_Mem[0];
        Internal_Mem[1] <= Internal_Mem[1];
        Internal_Mem[2] <= Internal_Mem[2];
        Internal_Mem[3] <= Internal_Mem[3];
    end
end

// Output valid signal generation
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        dout_vld <= 1'b0;
    end
    else begin
        dout_vld <= is_full;
    end
end

// Output data generation
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        dout <= {FULL_DATA_WIDTH{1'b0}};
    end
    else if (is_full) begin
        dout <= {Internal_Mem[3], Internal_Mem[2], Internal_Mem[1], Internal_Mem[0]};
    end
    else begin
        dout <= dout;
    end
end

// Full flag generation
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        is_full <= 1'b0;
    end
    else if (write_addr == BATCH_SIZE - 1 && din_vld && din_ready) begin    
        is_full <= 1'b1;
    end
    else begin
        is_full <= 1'b0;
    end
end

// Input data ready signal generation
assign din_ready = |is_idle;

endmodule












