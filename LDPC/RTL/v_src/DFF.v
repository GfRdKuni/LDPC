`timescale 1ns/1ps

module DFF
#
(
    parameter DATA_WIDTH = 1
)
(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= 0;
        end
        else if (en) begin
            dout <= din;
        end
        else begin
            dout <= dout;
        end
    end
endmodule