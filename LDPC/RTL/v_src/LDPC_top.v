`timescale 1ns / 1ps

module LDPC_top(
    input clk,
    input rst_n,
    input [3:0] din,
    input din_vld,
    output led_ready,
    output [15:0] led,           // Output from Output_Buffer, 16 bits
    output led_vld,
    output [3:0] led_idle,      // 4-bit idle status output
    output led_serdes_vld,      // dout_vld_serdes signal
    output [3:0] led_en,        // 4-bit enable signal
    output led_din_vld_pulse,   // din_vld_pulse signal
    output [1:0] led_write_cnt, // write counter output
    output led_is_full,         // is_full signal
    output [15:0] led_filled,   // led_filled signal
    output [3:0] led_is_done   // led_is_done signal
);

// Turn din_vld to one clock cycle
reg din_vld_dly;  // Delayed version of din_vld
wire din_vld_pulse; // Single-cycle pulse version of din_vld

// Generate single-cycle pulse
assign din_vld_pulse = din_vld && !din_vld_dly;
assign led_din_vld_pulse = din_vld_pulse;  // Connect pulse to LED output

// Update delayed version of din_vld
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        din_vld_dly <= 1'b0;
    else
        din_vld_dly <= din_vld;
end

LDPC_encoder encoder(
    .clk(clk),
    .rst_n(rst_n),
    .din(din),
    .din_vld(din_vld_pulse),  // Use single-cycle pulse
    .din_ready(led_ready),
    .dout(led),
    .dout_vld(led_vld),
    .led_idle(led_idle),      // Connect 4-bit idle signal to output
    .led_serdes_vld(led_serdes_vld),  // Connect serdes valid signal
    .led_en(led_en),          // Connect 4-bit enable signal
    .led_write_cnt(led_write_cnt),  // Connect write counter to output
    .led_is_full(led_is_full),  // Connect is_full to output
    .led_filled(led_filled),  // Connect led_filled to output
    .led_is_done(led_is_done)  // Connect led_is_done to output
);

endmodule
