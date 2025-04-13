`timescale 1ns / 1ps

module LDPC_encoder // LDPC encoder
#
(
    parameter BATCH_DATA_WIDTH = 4, // data width of each batch
    parameter BATCH_SIZE = 4, // number of batches
    parameter FULL_DATA_WIDTH = BATCH_DATA_WIDTH * BATCH_SIZE, // full data width, 16
    parameter GENM_ROW = 4, // number of rows of generator matrix
    parameter GENM_COL = 2, // number of columns of generator matrix
    parameter PARITY_WIDTH = GENM_COL * GENM_ROW, // parity width, 32
    parameter INPUT_WIDTH = GENM_ROW * FULL_DATA_WIDTH, // input width, 64
    parameter CODE_WIDTH = INPUT_WIDTH + PARITY_WIDTH, // code width
    parameter DOUT_WIDTH = 16,
    parameter ACC_WIDTH = FULL_DATA_WIDTH // accumulation width
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
    output wire dout_vld,
    output wire [3:0] led_idle,  // 4-bit idle status output
    output wire led_serdes_vld,  // dout_vld_serdes signal
    output wire [3:0] led_en,    // 4-bit enable signal
    output wire [1:0] led_write_cnt,  // write counter output
    output wire led_is_full,  // is_full signal
    output wire [FULL_DATA_WIDTH-1:0] led_filled,  // led_filled signal
    output wire [GENM_ROW-1:0] led_is_done  // led_is_done signal
);
wire dout_vld_Serdes;
wire [BATCH_DATA_WIDTH * BATCH_SIZE-1:0] dout_data;
wire [GENM_ROW-1:0] en;
wire [GENM_ROW-1:0] dout_int_vld;
wire [GENM_ROW-1:0] dout_int;
wire [GENM_ROW-1:0] update_Genm;
wire [GENM_ROW-1:0] is_idle;
wire [GENM_ROW-1:0] is_done;
wire [GENM_ROW-1:0] one_group_done;
wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out0;
wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out1;
wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out2;
wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out3;
wire [FULL_DATA_WIDTH-1:0] rom_in_data0;
wire [FULL_DATA_WIDTH-1:0] rom_in_data1;
wire [FULL_DATA_WIDTH-1:0] rom_in_data2;
wire [FULL_DATA_WIDTH-1:0] rom_in_data3;
wire [ACC_WIDTH-1:0] acc_data;
wire [47:0] acc_vld;
wire [ACC_WIDTH-1:0] acc_result;
wire [ACC_WIDTH-1:0] acc_result_vld;

// Add synchronization signal
wire all_done = &is_done;  // All PUs are done when all is_done signals are high
assign led_is_done = is_done;
// Serdes
Serdes#(
    .BATCH_DATA_WIDTH(BATCH_DATA_WIDTH),
    .BATCH_SIZE(BATCH_SIZE)
) u_serdes(
    .clk(clk),
    .rst_n(rst_n), 
    .din(din),
    .din_vld(din_vld),
    .is_idle(is_idle),
    .dout(dout_data),
    .dout_vld(dout_vld_Serdes),
    .din_ready(din_ready),
    .led_write_cnt(led_write_cnt),  // Connect write counter to output
    .led_is_full(led_is_full)  // Connect is_full to output
);

// Processing Unit instances with all_done signal
Processing_Unit#(
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH)
) u_processing_unit_0(
    .clk(clk),
    .rst_n(rst_n),
    .din(dout_data),
    .din_vld(dout_vld_Serdes),
    .rom_in_data(rom_in_data0),
    .EN(en[0]),
    .all_done(all_done),  // Connect all_done signal
    .is_idle(is_idle[0]),
    .dout_vld(dout_int_vld[0]),
    .cnt_out(cnt_out0),
    .dout_data(dout_int[0]),
    .is_done(is_done[0]),
    .one_group_done(one_group_done[0])
);

Processing_Unit#(
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH)
) u_processing_unit_1(
    .clk(clk),
    .rst_n(rst_n),
    .din(dout_data),
    .din_vld(dout_vld_Serdes),
    .rom_in_data(rom_in_data1),
    .EN(en[1]),
    .all_done(all_done),  // Connect all_done signal
    .is_idle(is_idle[1]),
    .dout_vld(dout_int_vld[1]),
    .cnt_out(cnt_out1),
    .dout_data(dout_int[1]),
    .is_done(is_done[1]),
    .one_group_done(one_group_done[1])
);

Processing_Unit#(
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH)
) u_processing_unit_2(
    .clk(clk),
    .rst_n(rst_n),
    .din(dout_data),
    .din_vld(dout_vld_Serdes),
    .rom_in_data(rom_in_data2),
    .EN(en[2]),
    .all_done(all_done),  // Connect all_done signal
    .is_idle(is_idle[2]),
    .dout_vld(dout_int_vld[2]),
    .cnt_out(cnt_out2),
    .dout_data(dout_int[2]),
    .is_done(is_done[2]),
    .one_group_done(one_group_done[2])
);

Processing_Unit#(
    .FULL_DATA_WIDTH(FULL_DATA_WIDTH)
) u_processing_unit_3(
    .clk(clk),
    .rst_n(rst_n),
    .din(dout_data),
    .din_vld(dout_vld_Serdes),
    .rom_in_data(rom_in_data3),
    .EN(en[3]),
    .all_done(all_done),  // Connect all_done signal
    .is_idle(is_idle[3]),
    .dout_vld(dout_int_vld[3]),
    .cnt_out(cnt_out3),
    .dout_data(dout_int[3]),
    .is_done(is_done[3]),
    .one_group_done(one_group_done[3])
);

// System Counter
Sys_Cnt#(
    .GENM_ROW(GENM_ROW)
) u_sys_cnt(
    .clk(clk),
    .rst_n(rst_n),
    .d_vld(dout_vld_Serdes),
    .EN(en)
);

// ROM
ROM#(
    .GENM_ROW(GENM_ROW),
    .GENM_COL(GENM_COL)
) u_rom(
    .clk(clk),
    .rst_n(rst_n),
    .dout_vld(dout_vld_Serdes),
    .en(en),
    .is_idle(is_idle),
    .is_done(one_group_done),
    .rom_out_data0(rom_in_data0),
    .rom_out_data1(rom_in_data1),
    .rom_out_data2(rom_in_data2),
    .rom_out_data3(rom_in_data3)
);

// CrossBar
(* keep_hierarchy="yes" *) Crossbar u_CB
(
    .cnt_out({cnt_out3,cnt_out2,cnt_out1,cnt_out0}),
    .dout_int(dout_int),
    .dout_vld(dout_int_vld),
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
            .acc_vld(acc_vld[3*i+2:3*i]),
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
    .dout_vld(dout_vld),
    .led_filled(led_filled)
);

// Connect internal signals to output
assign led_idle = is_idle;
assign led_serdes_vld = dout_vld_Serdes;
assign led_en = en;

endmodule

