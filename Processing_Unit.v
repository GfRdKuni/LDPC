`timescale 1ns/1ps

module Processing_Unit
#
(
    parameter FULL_DATA_WIDTH = 16,
    parameter GENM_ROW = 4,
    parameter GENM_COL = 2,
    parameter IDLE = 2'b00,
    parameter CALC = 2'b01,
    parameter DONE = 2'b10
)
(
    input wire clk,
    input wire rst_n,
    input wire [FULL_DATA_WIDTH-1:0] din,
    input wire din_vld,
    input wire [FULL_DATA_WIDTH-1:0] rom_in_data,
    input wire EN,
    output wire is_idle,
    output reg dout_vld,
    output wire [$clog2(FULL_DATA_WIDTH)-1:0] cnt_out,
    output reg dout_data,
    output wire is_done
);
    reg [FULL_DATA_WIDTH-1:0] din_reg;
    reg [FULL_DATA_WIDTH-1:0] GenM_reg;
    reg [$clog2(FULL_DATA_WIDTH)-1:0] cnt_reg;
    wire [FULL_DATA_WIDTH-1:0] prod;
    wire xor_0_0, xor_0_1, xor_0_2, xor_0_3, xor_0_4, xor_0_5, xor_0_6, xor_0_7;
    reg xor_0_0_q, xor_0_1_q, xor_0_2_q, xor_0_3_q, xor_0_4_q, xor_0_5_q, xor_0_6_q, xor_0_7_q;
    wire xor_1_0, xor_1_1, xor_1_2, xor_1_3;
    reg xor_1_0_q, xor_1_1_q, xor_1_2_q, xor_1_3_q;
    wire xor_2_0, xor_2_1;
    wire xor_3_0;
    reg din_vld_q, din_vld_q_q;
    reg [1:0] state; // 2'b00: IDLE, 2'b01: CALC, 2'b10: DONE
    wire start_calc;
    reg [$clog2(GENM_COL)-1:0] cnt_G;
   

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            din_reg <= {FULL_DATA_WIDTH{1'b0}};
        end
        else if (din_vld && EN && state == IDLE) begin
            din_reg <= din;
        end
        else begin
            din_reg <= din_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            GenM_reg <= {FULL_DATA_WIDTH{1'b0}};
        end
        else if ((din_vld && EN && state == IDLE) || (state == DONE)) begin
            GenM_reg <= rom_in_data;
        end
        else if (dout_vld && (state == CALC) && cnt_reg != FULL_DATA_WIDTH-1) begin // Left circle shift the GenM
            GenM_reg <= {GenM_reg[GENM_ROW-2:0], GenM_reg[GENM_ROW-1]};
        end
        else begin
            GenM_reg <= GenM_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_reg <= {($clog2(FULL_DATA_WIDTH)){1'b0}};
        end
        else if (dout_vld && (state == CALC)) begin
            if (cnt_reg == FULL_DATA_WIDTH-1) begin
                cnt_reg <= {($clog2(FULL_DATA_WIDTH)){1'b0}};
            end
            else begin
                cnt_reg <= cnt_reg + 1;
            end
        end
        else begin
            cnt_reg <= cnt_reg;
        end
    end

    assign prod = din_reg & GenM_reg;
    assign xor_0_0 = prod[0] ^ prod[1];
    assign xor_0_1 = prod[2] ^ prod[3];
    assign xor_0_2 = prod[4] ^ prod[5];
    assign xor_0_3 = prod[6] ^ prod[7];
    assign xor_0_4 = prod[8] ^ prod[9];
    assign xor_0_5 = prod[10] ^ prod[11];
    assign xor_0_6 = prod[12] ^ prod[13];
    assign xor_0_7 = prod[14] ^ prod[15];
    
    assign start_calc = (din_vld && EN && state == IDLE) || 
                       (dout_vld && (state == CALC) && cnt_reg != FULL_DATA_WIDTH-1) || 
                       (state == DONE);
    DFF #(
        .DATA_WIDTH(9)
    ) u_dff_0 (
        .clk(clk),
        .rst_n(rst_n),
        .en(1'b1),
        .din({start_calc, xor_0_0, xor_0_1, xor_0_2, xor_0_3, xor_0_4, xor_0_5, xor_0_6, xor_0_7}),
        .dout({din_vld_q, xor_0_0_q, xor_0_1_q, xor_0_2_q, xor_0_3_q, xor_0_4_q, xor_0_5_q, xor_0_6_q, xor_0_7_q})
    );

    assign xor_1_0 = xor_0_0_q ^ xor_0_1_q;
    assign xor_1_1 = xor_0_2_q ^ xor_0_3_q;
    assign xor_1_2 = xor_0_4_q ^ xor_0_5_q;
    assign xor_1_3 = xor_0_6_q ^ xor_0_7_q;

    DFF #(
        .DATA_WIDTH(5)
    ) u_dff_1 (
        .clk(clk),
        .rst_n(rst_n),
        .en(1'b1),
        .din({din_vld_q, xor_1_0, xor_1_1, xor_1_2, xor_1_3}),
        .dout({din_vld_q_q, xor_1_0_q, xor_1_1_q, xor_1_2_q, xor_1_3_q})
    );

    assign xor_2_0 = xor_1_0_q ^ xor_1_1_q;
    assign xor_2_1 = xor_1_2_q ^ xor_1_3_q;

    assign xor_3_0 = xor_2_0 ^ xor_2_1;

    DFF #(
        .DATA_WIDTH(2)
    ) u_dff_2 (
        .clk(clk),
        .rst_n(rst_n),
        .en(1'b1),
        .din({din_vld_q_q, xor_3_0}),
        .dout({dout_vld, dout_data})
    );

    
    assign cnt_out = cnt_reg;
    assign is_idle = (state == IDLE);
    assign is_done = (state == DONE);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_G <= {($clog2(GENM_COL)){1'b0}};
        end
        else if (dout_vld && cnt_reg == FULL_DATA_WIDTH-1) begin
            if (cnt_G == GENM_COL-1) begin
                cnt_G <= {($clog2(GENM_COL)){1'b0}};
            end
            else begin
                cnt_G <= cnt_G + 1;
            end
        end
        else begin
            cnt_G <= cnt_G;
        end
    end

    // Two-stage FSM
    reg [1:0] next_state;

    always @(*) begin
        case (state)
            IDLE: begin
                if (din_vld && EN) begin
                    next_state = CALC;
                end
                else begin
                    next_state = IDLE;
                end
            end
            CALC: begin
                if (cnt_G == GENM_COL-1 && cnt_reg == FULL_DATA_WIDTH-1 && dout_vld) begin
                    next_state = IDLE;
                end
                else if (dout_vld && cnt_reg == FULL_DATA_WIDTH-1 && cnt_G != GENM_COL-1) begin
                    next_state = DONE;
                end
                else begin
                    next_state = CALC;
                end
            end
            DONE: begin
                next_state = CALC;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end
endmodule