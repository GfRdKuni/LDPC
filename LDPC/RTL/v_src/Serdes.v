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
    output wire din_ready, // input data ready, high valid, indicate the system is ready to receive input data
    output wire [1:0] led_write_cnt, // write counter output for LED
    output wire led_is_full  // is_full signal for LED
);

// Internal signals
reg [BATCH_DATA_WIDTH-1:0] reg0; // first register
reg [BATCH_DATA_WIDTH-1:0] reg1; // second register
reg [BATCH_DATA_WIDTH-1:0] reg2; // third register
reg [BATCH_DATA_WIDTH-1:0] reg3; // fourth register
reg [1:0] write_cnt; // write counter
reg is_full; // full flag

// Connect write counter to output
assign led_write_cnt = write_cnt;
assign led_is_full = is_full;

// Write counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_cnt <= 2'b00;
    end
    else if (din_vld && din_ready) begin
        if (write_cnt == 2'b11) begin
            write_cnt <= 2'b00;
        end
        else begin
            write_cnt <= write_cnt + 1'b1;
        end
    end
    else begin
        write_cnt <= write_cnt;
    end
end

// Register write logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg0 <= {BATCH_DATA_WIDTH{1'b0}};
        reg1 <= {BATCH_DATA_WIDTH{1'b0}};
        reg2 <= {BATCH_DATA_WIDTH{1'b0}};
        reg3 <= {BATCH_DATA_WIDTH{1'b0}};
    end
    else if (din_vld && din_ready) begin
        case (write_cnt)
            2'b00: reg0 <= din;
            2'b01: reg1 <= din;
            2'b10: reg2 <= din;
            2'b11: reg3 <= din;
            default: begin
                reg0 <= reg0;
                reg1 <= reg1;
                reg2 <= reg2;
                reg3 <= reg3;
            end
        endcase
    end
    else begin
        reg0 <= reg0;
        reg1 <= reg1;
        reg2 <= reg2;
        reg3 <= reg3;
    end
end

// Output valid signal generation
// DFF#(
//     .DATA_WIDTH(1)
// ) u_dff_dout_vld(
//     .clk(clk),
//     .rst_n(rst_n),
//     .en(1'b1),
//     .din(is_full),
//     .dout(dout_vld)
// );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout_vld <= 1'b0;
    end
    else if (is_full) begin
        dout_vld <= 1'b1;
    end
    else begin
        dout_vld <= 1'b0;
    end
end

// Output data generation
DFF#(
    .DATA_WIDTH(FULL_DATA_WIDTH)
) u_dff_dout(
    .clk(clk),
    .rst_n(rst_n),
    .en(is_full),
    .din({reg3, reg2, reg1, reg0}),
    .dout(dout)
);

// Full flag generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        is_full <= 1'b0;
    end
    else if (write_cnt == 2'b11 && din_vld && din_ready) begin
        is_full <= 1'b1;
    end
    else begin
        is_full <= 1'b0;
    end
end

// Input data ready signal generation
assign din_ready = |is_idle;

endmodule












