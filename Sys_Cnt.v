`timescale 1ns/1ps

module Sys_Cnt
#
(
    parameter GENM_ROW = 4
)
(
    input wire clk,
    input wire rst_n,
    input wire d_vld,
    output reg [GENM_ROW-1:0] EN
);
reg [$clog2(GENM_ROW)-1:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end
    else if (d_vld) begin
        if (counter == GENM_ROW - 1) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
    else begin
        counter <= counter;
    end
end

always@(*) begin
    case (counter)
        0: EN = 4'b0001;
        1: EN = 4'b0010;
        2: EN = 4'b0100;
        3: EN = 4'b1000;
        default: EN = 4'b0000;
    endcase
end

endmodule
