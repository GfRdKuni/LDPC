`timescale 1ns/1ps
module Accumulator #
(
    parameter GENM_ROW = 4
)
(
    input wire clk,
    input wire rst_n,
    input wire acc_vld,
    input wire acc_data,
    output wire acc_result,
    output reg acc_result_vld
);

    reg internal_acc;
    reg [$clog2(GENM_ROW)-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end
        else if (acc_vld) begin
            if (cnt == GENM_ROW - 1) begin
                cnt <= 0;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
        else begin
            cnt <= cnt;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_result_vld <= 1'b0;
        end
        else if (acc_vld && cnt == GENM_ROW - 1) begin
            acc_result_vld <= 1'b1;
        end
        else begin
            acc_result_vld <= 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            internal_acc <= 1'b0;
        end
        else if (acc_result_vld && acc_vld) begin
            internal_acc <= acc_data;
        end
        else if (acc_result_vld && ~acc_vld) begin
            internal_acc <= 1'b0;
        end
        else if (acc_vld) begin
            internal_acc <= acc_data ^ internal_acc;
        end
        else begin
            internal_acc <= internal_acc;
        end
    end

    assign acc_result = internal_acc;

endmodule