`timescale 1ns/1ps
module ROM
#(
    parameter GENM_ROW = 4,
    parameter GENM_COL = 2,
    parameter FULL_DATA_WIDTH = 16
)
(
    input wire clk,
    input wire rst_n,
    input wire [GENM_ROW-1:0] is_idle,
    input wire [GENM_ROW-1:0] is_done,
    input wire [GENM_ROW-1:0] en,
    input wire dout_vld,
    output wire [FULL_DATA_WIDTH - 1:0] rom_out_data0,
    output wire [FULL_DATA_WIDTH - 1:0] rom_out_data1,
    output wire [FULL_DATA_WIDTH - 1:0] rom_out_data2,
    output wire [FULL_DATA_WIDTH - 1:0] rom_out_data3
);

    reg [FULL_DATA_WIDTH - 1:0] Rom_reg0 [GENM_COL - 1:0];
    reg [FULL_DATA_WIDTH - 1:0] Rom_reg1 [GENM_COL - 1:0];
    reg [FULL_DATA_WIDTH - 1:0] Rom_reg2 [GENM_COL - 1:0];
    reg [FULL_DATA_WIDTH - 1:0] Rom_reg3 [GENM_COL - 1:0];
    reg [$clog2(GENM_COL)-1:0] addr0;
    reg [$clog2(GENM_COL)-1:0] addr1;
    reg [$clog2(GENM_COL)-1:0] addr2;
    reg [$clog2(GENM_COL)-1:0] addr3;

    assign rom_out_data0 = Rom_reg0[addr0];
    assign rom_out_data1 = Rom_reg1[addr1];
    assign rom_out_data2 = Rom_reg2[addr2];
    assign rom_out_data3 = Rom_reg3[addr3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr0 <= 0;
        end
        else if (is_idle[0] && dout_vld && en[0] || is_done[0]) begin
            if (addr0 == GENM_COL - 1) begin
                addr0 <= 0;
            end
            else begin
                addr0 <= addr0 + 1;
            end
        end
        else begin
            addr0 <= addr0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr1 <= 0;
        end
        else if (is_idle[1] && dout_vld && en[1] || is_done[1]) begin
            if (addr1 == GENM_COL - 1) begin
                addr1 <= 0;
            end
            else begin
                addr1 <= addr1 + 1;
            end
        end
        else begin
            addr1 <= addr1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr2 <= 0;
        end
        else if (is_idle[2] && dout_vld && en[2] || is_done[2]) begin
            if (addr2 == GENM_COL - 1) begin
                addr2 <= 0;
            end
            else begin
                addr2 <= addr2 + 1;
            end
        end
        else begin
            addr2 <= addr2;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr3 <= 0;
        end
        else if (is_idle[3] && dout_vld && en[3] || is_done[3]) begin
            if (addr3 == GENM_COL - 1) begin
                addr3 <= 0;
            end
            else begin
                addr3 <= addr3 + 1;
            end
        end
        else begin
            addr3 <= addr3;
        end
    end

    // Initialize ROM content
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Rom_reg0[0] <= 'h3281;
            Rom_reg0[1] <= 'hfe09;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Rom_reg1[0] <= 'h1234;
            Rom_reg1[1] <= 'h6a7b;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Rom_reg2[0] <= 'hCFAD;
            Rom_reg2[1] <= 'h5689;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Rom_reg3[0] <= 'hBEEF;
            Rom_reg3[1] <= 'h637A;
        end
    end

endmodule