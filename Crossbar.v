`timescale 1ns / 1ps

module Crossbar#
(
    parameter GENM_ROW = 4,           // Number of rows in generator matrix
    parameter FULL_DATA_WIDTH = 16,   // Full data width
    parameter ACC_WIDTH = 16          // Width of accumulator data
)
(
    input wire [$clog2(FULL_DATA_WIDTH) * GENM_ROW -1:0] cnt_out,
    input wire [GENM_ROW-1:0] dout_int,
    output reg [ACC_WIDTH-1:0] acc_vld,
    output reg [ACC_WIDTH-1:0] acc_data
);

genvar i;
generate
    for (i = 0; i < ACC_WIDTH; i = i + 1) begin : acc_gen
        // Valid signal generation
        always @(*) begin
            if (cnt_out[3:0] == i || cnt_out[7:4] == i || cnt_out[11:8] == i || cnt_out[15:12] == i) begin
                acc_vld[i] = 1'b1;
            end
            else begin
                acc_vld[i] = 1'b0;
            end
        end

        // Data routing
        always @(*) begin
            if (acc_vld[i]) begin
                if (cnt_out[3:0] == i) begin
                    acc_data[i] = dout_int[0];
                end
                else if (cnt_out[7:4] == i) begin
                    acc_data[i] = dout_int[1];
                end
                else if (cnt_out[11:8] == i) begin
                    acc_data[i] = dout_int[2];
                end
                else begin 
                    acc_data[i] = dout_int[3];
                end
            end
            else begin
                acc_data[i] = 1'b0;
            end
        end
    end
endgenerate

endmodule
