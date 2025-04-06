`timescale 1ns / 1ps

module LDPC_encoder // LDPC encoder
#
(
    parameter BATCH_DATA_WIDTH = 4, // data width of each batch
    parameter BATCH_SIZE = 4, // number of batches
    parameter FULL_DATA_WIDTH = BATCH_DATA_WIDTH * BATCH_SIZE, // full data width, 16
    parameter PARITY_WIDTH = GENM_COL * GENM_ROW, // parity width, 32
    parameter INPUT_WIDTH = GENM_ROW * FULL_DATA_WIDTH, // input width, 64
    parameter GENM_ROW = 4, // number of rows of generator matrix
    parameter GENM_COL = 2, // number of columns of generator matrix
    parameter CODE_WIDTH = INPUT_WIDTH + PARITY_WIDTH, // code width
    parameter DOUT_WIDTH = 8;
    parameter ACC_WIDTH = FULL_DATA_WIDTH, // accumulation width
    // LDPC attribute
    // n = CODE_WIDTH = 96, k = INPUT_WIDTH = 64, r = PARITY_WIDTH = 32
    // code rate = 64/96 = 2/3
)
(
    input wire clk,
    input wire rst_n,
    input wire [BATCH_DATA_WIDTH-1:0] din,
    input wire din_vld,
    output wire din_ready,
    output wire [DOUT_WIDTH-1:0] dout,
    output wire dout_vld
);
wire dout_vld_Serdes;
wire [BATCH_DATA_WIDTH * BATCH_SIZE-1:0] dout_data;
wire [GENM_ROW-1:0] en;
wire [GENM_ROW-1:0] dout_int;
wire [GENM_ROW-1:0] dout_int_vld;
wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out0;
wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out1;
wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out2;
wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out3;
wire [GENM_ROW-1:0] dout_int;
wire [GENM_ROW-1:0] update_Genm;
wire [GENM_ROW-1:0] is_idle;
wire [GENM_ROW-1:0] is_done;
wire [FULL_DATA_WIDTH-1:0] rom_in_data0;
wire [FULL_DATA_WIDTH-1:0] rom_in_data1;
wire [FULL_DATA_WIDTH-1:0] rom_in_data2;
wire [FULL_DATA_WIDTH-1:0] rom_in_data3;
wire [ACC_WIDTH-1:0] acc_data;
wire [ACC_WIDTH-1:0] acc_vld;
wire [ACC_WIDTH-1:0] acc_result;
wire [ACC_WIDTH-1:0] acc_result_vld;
// Serdes
Serdes#(
    .BATCH_DATA_WIDTH(BATCH_DATA_WIDTH),
    .BATCH_SIZE(BATCH_SIZE),
) u_serdes(
    .clk(clk),
    .rst_n(rst_n), 
    .din(din),
    .din_vld(din_vld),
    .is_idle(is_idle),
    .dout(dout_data),
    .dout_vld(dout_vld_Serdes),
    .din_ready(din_ready)
);

// Processing Unit
Processing_Unit#(
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH),
) u_processing_unit_0(
    .clk(clk), // clock
    .rst_n(rst_n), // reset
    .din(dout_data), // input data, Update the input data, when dout_vld_Serdes & en[0]
    .din_vld(dout_vld_Serdes), // input data valid, shift the GenM, when dout_vld_Serdes; Add the cnt_out[0] when dout_vld_Serdes
    .rom_in_data(rom_in_data0), // rom input data, Update the GenM, when dout_vld_Serdes & en[0]
    .EN(en[0]), // enable
    .dout_vld(dout_int_vld[0]), // output data valid, Activate Acc 
    .cnt_out(cnt_out0), // counter output, Select Acc
    .dout_data(dout_int[0]), // output data
    .is_idle(is_idle[0]), // idle signal
    .is_done(is_done[0]) // done signal
);

Processing_Unit#(
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH),
) u_processing_unit_1(
    .clk(clk), // clock
    .rst_n(rst_n), // reset
    .din(dout_data), // input data, Update the input data, when dout_vld_Serdes & en[1]
    .din_vld(dout_vld_Serdes), // input data valid, shift the GenM, when dout_vld_Serdes; Add the cnt_out[1] when dout_vld_Serdes
    .rom_in_data(rom_in_data1), // rom input data, Update the GenM, when dout_vld_Serdes & en[1]
    .EN(en[1]), // enable
    .dout_vld(dout_int_vld[1]), // output data valid, Activate Acc 
    .cnt_out(cnt_out1), // counter output, Select Acc
    .dout_data(dout_int[1]), // output data
    .is_idle(is_idle[1]), // idle signal
    .is_done(is_done[1]) // done signal
);

Processing_Unit#(
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH),
) u_processing_unit_2(
    .clk(clk), // clock
    .rst_n(rst_n), // reset
    .din(dout_data), // input data, Update the input data, when dout_vld_Serdes & en[2]
    .din_vld(dout_vld_Serdes), // input data valid, shift the GenM, when dout_vld_Serdes; Add the cnt_out[2] when dout_vld_Serdes
    .rom_in_data(rom_in_data2), // rom input data, Update the GenM, when dout_vld_Serdes & en[2]
    .EN(en[2]), // enable
    .dout_vld(dout_int_vld[2]), // output data valid, Activate Acc 
    .cnt_out(cnt_out2), // counter output, Select Acc
    .dout_data(dout_int[2]), // output data
    .is_idle(is_idle[2]), // idle signal
    .is_done(is_done[2]) // done signal
);

Processing_Unit#(
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH),
) u_processing_unit_3(
    .clk(clk), // clock
    .rst_n(rst_n), // reset
    .din(dout_data), // input data, Update the input data, when dout_vld_Serdes & en[3]
    .din_vld(dout_vld_Serdes), // input data valid, shift the GenM, when dout_vld_Serdes; Add the cnt_out[3] when dout_vld_Serdes
    .rom_in_data(rom_in_data3), // rom input data, Update the GenM, when dout_vld_Serdes & en[3]
    .EN(en[3]), // enable
    .dout_vld(dout_int_vld[3]), // output data valid, Activate Acc 
    .cnt_out(cnt_out3), // counter output, Select Acc
    .dout_data(dout_int[3]), // output data
    .is_idle(is_idle[3]), // idle signal
    .is_done(is_done[3]) // done signal
);

// System Counter
Sys_Cnt#(
    .GENM_ROW(GENM_ROW),
) u_sys_cnt(
    .clk(clk),
    .rst_n(rst_n),
    .d_vld(dout_vld_Serdes),
    .EN(en)
);

// ROM
ROM#(
    .GENM_ROW(GENM_ROW),
    .GENM_COL(GENM_COL),
) u_rom(
    .clk(clk),
    .rst_n(rst_n),
    .dout_vld(dout_vld_Serdes),
    .en(en),
    .is_idle(is_idle),
    .is_done(is_done),
    .rom_out_data0(rom_in_data0),
    .rom_out_data1(rom_in_data1),
    .rom_out_data2(rom_in_data2),
    .rom_out_data3(rom_in_data3)
);

// CrossBar
Crossbar u_CB
(
    .cnt_out({cnt_out3,cnt_out2,cnt_out1,cnt_out0}),
    .dout_int(dout_int),
    .acc_vld(acc_vld),
    .acc_data(acc_data)
);

// Generate block for accumulators
genvar i;
generate
    for (i = 0; i < ACC_WIDTH; i = i + 1) begin : acc_gen
        Accumulator u_acc (
            .clk(clk),
            .rst_n(rst_n),
            .acc_result(acc_result[i]),
            .acc_result_vld(acc_result_vld[i]),
            .acc_vld(acc_vld[i]),
            .acc_data(acc_data[i])
        );
    end
endgenerate

// Output Buffer
Output_Buffer u_OB(
    .clk(clk),
    .rst_n(rst_n),
    .acc_result(acc_result),
    .acc_result_vld(acc_result_vld),
    .dout(dout),
    .dout_vld(dout_vld)
);
endmodule

