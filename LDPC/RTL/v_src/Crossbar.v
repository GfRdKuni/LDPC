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
    input wire [GENM_ROW-1:0] dout_vld,
    output reg [47:0] acc_vld,
    output reg [ACC_WIDTH-1:0] acc_data
);



always @(*) begin
    acc_vld[2:0] = (cnt_out[3:0] == 0 && dout_vld[0]) + (cnt_out[7:4] == 0 && dout_vld[1]) + (cnt_out[11:8] == 0&&dout_vld[2]) + (cnt_out[15:12] == 0&&dout_vld[3]); // count the number of input ports that connect to the 0th output port
    acc_vld[5:3] = (cnt_out[3:0] == 1 && dout_vld[0]) + (cnt_out[7:4] == 1 && dout_vld[1]) + (cnt_out[11:8] == 1&&dout_vld[2]) + (cnt_out[15:12] == 1&&dout_vld[3]); // count the number of input ports that connect to the 1st output port
    acc_vld[8:6] = (cnt_out[3:0] == 2 && dout_vld[0]) + (cnt_out[7:4] == 2 && dout_vld[1]) + (cnt_out[11:8] == 2&&dout_vld[2]) + (cnt_out[15:12] == 2&&dout_vld[3]); // count the number of input ports that connect to the 2nd output port
    acc_vld[11:9] = (cnt_out[3:0] == 3 && dout_vld[0]) + (cnt_out[7:4] == 3 && dout_vld[1]) + (cnt_out[11:8] == 3&&dout_vld[2]) + (cnt_out[15:12] == 3&&dout_vld[3]); // count the number of input ports that connect to the 3rd output port
    acc_vld[14:12] = (cnt_out[3:0] == 4 && dout_vld[0]) + (cnt_out[7:4] == 4 && dout_vld[1]) + (cnt_out[11:8] == 4&&dout_vld[2]) + (cnt_out[15:12] == 4&&dout_vld[3]); // count the number of input ports that connect to the 4th output port
    acc_vld[17:15] = (cnt_out[3:0] == 5 && dout_vld[0]) + (cnt_out[7:4] == 5 && dout_vld[1]) + (cnt_out[11:8] == 5&&dout_vld[2]) + (cnt_out[15:12] == 5&&dout_vld[3]); // count the number of input ports that connect to the 5th output port
    acc_vld[20:18] = (cnt_out[3:0] == 6 && dout_vld[0]) + (cnt_out[7:4] == 6 && dout_vld[1]) + (cnt_out[11:8] == 6&&dout_vld[2]) + (cnt_out[15:12] == 6&&dout_vld[3]); // count the number of input ports that connect to the 6th output port
    acc_vld[23:21] = (cnt_out[3:0] == 7 && dout_vld[0]) + (cnt_out[7:4] == 7 && dout_vld[1]) + (cnt_out[11:8] == 7&&dout_vld[2]) + (cnt_out[15:12] == 7&&dout_vld[3]); // count the number of input ports that connect to the 7th output port
    acc_vld[26:24] = (cnt_out[3:0] == 8 && dout_vld[0]) + (cnt_out[7:4] == 8 && dout_vld[1]) + (cnt_out[11:8] == 8&&dout_vld[2]) + (cnt_out[15:12] == 8&&dout_vld[3]); // count the number of input ports that connect to the 8th output port
    acc_vld[29:27] = (cnt_out[3:0] == 9 && dout_vld[0]) + (cnt_out[7:4] == 9 && dout_vld[1]) + (cnt_out[11:8] == 9&&dout_vld[2]) + (cnt_out[15:12] == 9&&dout_vld[3]); // count the number of input ports that connect to the 9th output port
    acc_vld[32:30] = (cnt_out[3:0] == 10 && dout_vld[0]) + (cnt_out[7:4] == 10 && dout_vld[1]) + (cnt_out[11:8] == 10&&dout_vld[2]) + (cnt_out[15:12] == 10&&dout_vld[3]); // count the number of input ports that connect to the 10th output port
    acc_vld[35:33] = (cnt_out[3:0] == 11 && dout_vld[0]) + (cnt_out[7:4] == 11 && dout_vld[1]) + (cnt_out[11:8] == 11&&dout_vld[2]) + (cnt_out[15:12] == 11&&dout_vld[3]); // count the number of input ports that connect to the 11th output port
    acc_vld[38:36] = (cnt_out[3:0] == 12 && dout_vld[0]) + (cnt_out[7:4] == 12 && dout_vld[1]) + (cnt_out[11:8] == 12&&dout_vld[2]) + (cnt_out[15:12] == 12&&dout_vld[3]); // count the number of input ports that connect to the 12th output port
    acc_vld[41:39] = (cnt_out[3:0] == 13 && dout_vld[0]) + (cnt_out[7:4] == 13 && dout_vld[1]) + (cnt_out[11:8] == 13&&dout_vld[2]) + (cnt_out[15:12] == 13&&dout_vld[3]); // count the number of input ports that connect to the 13th output port
    acc_vld[44:42] = (cnt_out[3:0] == 14 && dout_vld[0]) + (cnt_out[7:4] == 14 && dout_vld[1]) + (cnt_out[11:8] == 14&&dout_vld[2]) + (cnt_out[15:12] == 14&&dout_vld[3]); // count the number of input ports that connect to the 14th output port
    acc_vld[47:45] = (cnt_out[3:0] == 15 && dout_vld[0]) + (cnt_out[7:4] == 15 && dout_vld[1]) + (cnt_out[11:8] == 15&&dout_vld[2]) + (cnt_out[15:12] == 15&&dout_vld[3]); // count the number of input ports that connect to the 15th output port
end

always @(*) begin
    acc_data[0] = (cnt_out[3:0] == 0 && dout_int[0])^(cnt_out[7:4] == 0 && dout_int[1])^(cnt_out[11:8] == 0&&dout_int[2])^(cnt_out[15:12] == 0&&dout_int[3]); // Sum the data from the input ports that connect to the 0th output port
    acc_data[1] = (cnt_out[3:0] == 1 && dout_int[0])^(cnt_out[7:4] == 1 && dout_int[1])^(cnt_out[11:8] == 1&&dout_int[2])^(cnt_out[15:12] == 1&&dout_int[3]); // Sum the data from the input ports that connect to the 1st output port
    acc_data[2] = (cnt_out[3:0] == 2 && dout_int[0])^(cnt_out[7:4] == 2 && dout_int[1])^(cnt_out[11:8] == 2&&dout_int[2])^(cnt_out[15:12] == 2&&dout_int[3]); // Sum the data from the input ports that connect to the 2nd output port
    acc_data[3] = (cnt_out[3:0] == 3 && dout_int[0])^(cnt_out[7:4] == 3 && dout_int[1])^(cnt_out[11:8] == 3&&dout_int[2])^(cnt_out[15:12] == 3&&dout_int[3]); // Sum the data from the input ports that connect to the 3rd output port
    acc_data[4] = (cnt_out[3:0] == 4 && dout_int[0])^(cnt_out[7:4] == 4 && dout_int[1])^(cnt_out[11:8] == 4&&dout_int[2])^(cnt_out[15:12] == 4&&dout_int[3]); // Sum the data from the input ports that connect to the 4th output port
    acc_data[5] = (cnt_out[3:0] == 5 && dout_int[0])^(cnt_out[7:4] == 5 && dout_int[1])^(cnt_out[11:8] == 5&&dout_int[2])^(cnt_out[15:12] == 5&&dout_int[3]); // Sum the data from the input ports that connect to the 5th output port
    acc_data[6] = (cnt_out[3:0] == 6 && dout_int[0])^(cnt_out[7:4] == 6 && dout_int[1])^(cnt_out[11:8] == 6&&dout_int[2])^(cnt_out[15:12] == 6&&dout_int[3]); // Sum the data from the input ports that connect to the 6th output port
    acc_data[7] = (cnt_out[3:0] == 7 && dout_int[0])^(cnt_out[7:4] == 7 && dout_int[1])^(cnt_out[11:8] == 7&&dout_int[2])^(cnt_out[15:12] == 7&&dout_int[3]); // Sum the data from the input ports that connect to the 7th output port  
    acc_data[8] = (cnt_out[3:0] == 8 && dout_int[0])^(cnt_out[7:4] == 8 && dout_int[1])^(cnt_out[11:8] == 8&&dout_int[2])^(cnt_out[15:12] == 8&&dout_int[3]); // Sum the data from the input ports that connect to the 8th output port
    acc_data[9] = (cnt_out[3:0] == 9 && dout_int[0])^(cnt_out[7:4] == 9 && dout_int[1])^(cnt_out[11:8] == 9&&dout_int[2])^(cnt_out[15:12] == 9&&dout_int[3]); // Sum the data from the input ports that connect to the 9th output port
    acc_data[10] = (cnt_out[3:0] == 10 && dout_int[0])^(cnt_out[7:4] == 10 && dout_int[1])^(cnt_out[11:8] == 10&&dout_int[2])^(cnt_out[15:12] == 10&&dout_int[3]); // Sum the data from the input ports that connect to the 10th output port
    acc_data[11] = (cnt_out[3:0] == 11 && dout_int[0])^(cnt_out[7:4] == 11 && dout_int[1])^(cnt_out[11:8] == 11&&dout_int[2])^(cnt_out[15:12] == 11&&dout_int[3]); // Sum the data from the input ports that connect to the 11th output port
    acc_data[12] = (cnt_out[3:0] == 12 && dout_int[0])^(cnt_out[7:4] == 12 && dout_int[1])^(cnt_out[11:8] == 12&&dout_int[2])^(cnt_out[15:12] == 12&&dout_int[3]); // Sum the data from the input ports that connect to the 12th output port
    acc_data[13] = (cnt_out[3:0] == 13 && dout_int[0])^(cnt_out[7:4] == 13 && dout_int[1])^(cnt_out[11:8] == 13&&dout_int[2])^(cnt_out[15:12] == 13&&dout_int[3]); // Sum the data from the input ports that connect to the 13th output port
    acc_data[14] = (cnt_out[3:0] == 14 && dout_int[0])^(cnt_out[7:4] == 14 && dout_int[1])^(cnt_out[11:8] == 14&&dout_int[2])^(cnt_out[15:12] == 14&&dout_int[3]); // Sum the data from the input ports that connect to the 14th output port
    acc_data[15] = (cnt_out[3:0] == 15 && dout_int[0])^(cnt_out[7:4] == 15 && dout_int[1])^(cnt_out[11:8] == 15&&dout_int[2])^(cnt_out[15:12] == 15&&dout_int[3]); // Sum the data from the input ports that connect to the 15th output port
end

endmodule
