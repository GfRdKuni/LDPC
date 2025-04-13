`timescale 1ns/1ps

// LDPC Encoder Testbench (SystemVerilog)
// Compile with: vlog -sv LDPC_encoder_tb.sv

module LDPC_encoder_tb;

    // Clock and reset signals
    reg        clk;       // 100 MHz clock
    reg        rst_n;     // Active-low reset

    // DUT interface signals
    reg  [3:0] din;       // 4-bit input data
    reg        din_vld;   // Input data valid signal
    wire       din_ready; // DUT indicates it is ready for new input
    wire [7:0] dout;      // 8-bit output data
    wire       dout_vld;  // Output data valid signal

    // Test vector and expected results storage
    reg [3:0] tx_data   [0:31];   // 32 nibbles (forming two 64-bit blocks)
    reg [7:0] expected_output [0:7]; // Expected output: 8 bytes (4 bytes per block)
    reg [7:0] actual_output [0:7];   // Actual output from DUT: 8 bytes

    // Statistics counters
    integer mismatch_count = 0;
    integer error_count    = 0;
    integer total_packets  = 0;

    // Output index counter
    integer output_index = 0;

    // Log file handle
    integer log_file;

    // Instantiate the DUT
    LDPC_encoder uut (
        .clk       (clk),
        .rst_n     (rst_n),
        .din       (din),
        .din_vld   (din_vld),
        .din_ready (din_ready),
        .dout      (dout),
        .dout_vld  (dout_vld)
    );

    // Clock generation: 100 MHz (period = 10 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Open log file
    initial begin
        log_file = $fopen("LDPC_encoder_simulation.log", "w");
        if (!log_file) begin
            $display("Error: Could not open log file");
            $finish;
        end
        $fdisplay(log_file, "=== LDPC Encoder Simulation Log ===");
        $fdisplay(log_file, "Time: %t", $time);
    end

    // Waveform dump for debugging
    initial begin
        $dumpfile("LDPC_encoder_tb.vcd");
        $dumpvars(0, LDPC_encoder_tb);
    end

    //--------------------------------------------------------------------------
    // Software LDPC parity calculation function.
    // Mirrors the DUT's generator matrix logic.
    //--------------------------------------------------------------------------
    function [31:0] calculate_ldpc_output;
        input [63:0] data;
        reg [15:0] rom_reg[0:3][0:1];  // ROM registers: 4 rows x 2 columns
        reg        gen_matrix[0:63][0:31];  // Generator matrix: 64 rows x 32 columns
        reg [31:0] parity_bits;
        integer i, j, k;
        begin
            // Initialize ROM registers with predefined constants
            rom_reg[0][0] = 16'hBEEF;  rom_reg[1][0] = 16'hCFAD;
            rom_reg[2][0] = 16'h1234;  rom_reg[3][0] = 16'h3281;
            rom_reg[0][1] = 16'h637A;  rom_reg[1][1] = 16'h5689;
            rom_reg[2][1] = 16'h6A7B;  rom_reg[3][1] = 16'hFE09;

            // Generate first 16 columns using first ROM set
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    for (k = 0; k < 16; k = k + 1) begin
                        gen_matrix[i*16 + k][j] = rom_reg[i][0][15 - k];
                    end
                    // Rotate right by 1 bit
                    rom_reg[i][0] = {rom_reg[i][0][0], rom_reg[i][0][15:1]};
                end
            end

            // Generate next 16 columns using second ROM set
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 16; j < 32; j = j + 1) begin
                    for (k = 0; k < 16; k = k + 1) begin
                        gen_matrix[i*16 + k][j] = rom_reg[i][1][15 - k];
                    end
                    rom_reg[i][1] = {rom_reg[i][1][0], rom_reg[i][1][15:1]};
                end
            end

            // Calculate parity bits by XOR'ing the selected input bits
            parity_bits = 32'h0;
            for (i = 0; i < 32; i = i + 1) begin
                for (j = 0; j < 64; j = j + 1) begin
                    if (data[63 - j] & gen_matrix[j][i])
                        parity_bits[i] = parity_bits[i] ^ 1'b1;
                end
            end

            calculate_ldpc_output = parity_bits;
        end
    endfunction

    //--------------------------------------------------------------------------
    // Output capture
    //--------------------------------------------------------------------------
    always @(posedge clk) begin
        if (dout_vld) begin
            // Store output data
            actual_output[output_index] = dout;
            $display("[%0t] Output[%0d]: %h", $time, output_index, dout);
            $fdisplay(log_file, "[%0t] Output[%0d]: %h", $time, output_index, dout);
            output_index = output_index + 1;
        end
    end

    //--------------------------------------------------------------------------
    // Error detection: monitor for invalid input conditions
    //--------------------------------------------------------------------------
    always @(posedge clk) begin
        // Detect data input when module is not ready
        if (din_vld && !din_ready) begin
            $display("[%0t] ERROR: Data input when DUT is not ready", $time);
            $display("  Input data: %h", din);
            $fdisplay(log_file, "[%0t] ERROR: Data input when DUT is not ready", $time);
            $fdisplay(log_file, "  Input data: %h", din);
            error_count = error_count + 1;
        end
        
        // Detect data input during reset
        if (din_vld && !rst_n) begin
            $display("[%0t] ERROR: Data input during reset", $time);
            $display("  Input data: %h", din);
            $fdisplay(log_file, "[%0t] ERROR: Data input during reset", $time);
            $fdisplay(log_file, "  Input data: %h", din);
            error_count = error_count + 1;
        end
        
        // Detect output valid when not expected
        if (dout_vld && output_index > 8) begin
            $display("[%0t] ERROR: Unexpected output valid signal", $time);
            $display("  Output data: %h", dout);
            $fdisplay(log_file, "[%0t] ERROR: Unexpected output valid signal", $time);
            $fdisplay(log_file, "  Output data: %h", dout);
            error_count = error_count + 1;
        end
    end

    //--------------------------------------------------------------------------
    // Main test sequence
    //--------------------------------------------------------------------------
    initial begin
        integer i, send_idx;
        reg [63:0] block1, block2;
        reg [31:0] parity1, parity2;

        // Initialize counters
        mismatch_count = 0;
        error_count = 0;
        total_packets = 0;
        output_index = 0;

        // --- Reset the DUT ---
        $display("\n[Test Case 1] Reset Test");
        $fdisplay(log_file, "\n[Test Case 1] Reset Test");
        rst_n   = 0;
        din     = 4'h0;
        din_vld = 0;
        #100;
        rst_n   = 1;
        #20;

        // --- Generate random test vectors ---
        for (i = 0; i < 32; i = i + 1)
            tx_data[i] = $urandom_range(0, 15);

        // --- Compute expected parity outputs for two 64-bit blocks ---
        for (i = 0; i < 16; i = i + 1) begin
            block1[i*4 +: 4] = tx_data[i];
            block2[i*4 +: 4] = tx_data[i+16];
        end
        parity1 = calculate_ldpc_output(block1);
        parity2 = calculate_ldpc_output(block2);
        for (i = 0; i < 4; i = i + 1) begin
            expected_output[i]   = parity1[i*8 +: 8];
            expected_output[i+4] = parity2[i*8 +: 8];
        end

        // --- Test Case 2: Normal transmission (Frame 1) ---
        $display("\n[Test Case 2] Normal Data Transmission - Frame 1");
        $fdisplay(log_file, "\n[Test Case 2] Normal Data Transmission - Frame 1");
        for (send_idx = 0; send_idx < 16; send_idx = send_idx + 1) begin
            // Wait for DUT ready with timeout
            fork
                begin: wait_ready
                    wait (din_ready);
                end
                begin: timeout
                    #10000;
                    $error("Timeout waiting for din_ready (Frame 1 idx=%0d)", send_idx);
                    $fdisplay(log_file, "ERROR: Timeout waiting for din_ready (Frame 1 idx=%0d)", send_idx);
                    $finish;
                end
            join_any
            disable fork;

            @(negedge clk);
            din     = tx_data[send_idx];
            din_vld = 1;
            @(negedge clk);
            din_vld = 0;
            $display("[%0t] Sent Frame1[%0d]: %h", $time, send_idx, tx_data[send_idx]);
            $fdisplay(log_file, "[%0t] Sent Frame1[%0d]: %h", $time, send_idx, tx_data[send_idx]);
        end

        // --- Test Case 3: Continuous input (Frame 2) ---
        $display("\n[Test Case 3] Continuous Input Test - Frame 2");
        $fdisplay(log_file, "\n[Test Case 3] Continuous Input Test - Frame 2");
        for (send_idx = 16; send_idx < 32; send_idx = send_idx + 1) begin
            wait (din_ready);
            @(negedge clk);
            din     = tx_data[send_idx];
            din_vld = 1;
            @(negedge clk);
            din_vld = 0;
            #2;  // Simulate tight back-to-back input
            $display("[%0t] Sent Frame2[%0d]: %h", $time, send_idx-16, tx_data[send_idx]);
            $fdisplay(log_file, "[%0t] Sent Frame2[%0d]: %h", $time, send_idx-16, tx_data[send_idx]);
        end

        // --- Wait for all outputs ---
        $display("\n[Waiting for Outputs]");
        $fdisplay(log_file, "\n[Waiting for Outputs]");
        while (output_index < 8) begin
            @(posedge clk);
        end

        // --- Compare actual outputs with expected outputs ---
        $display("\n[Result Comparison]");
        $fdisplay(log_file, "\n[Result Comparison]");
        for (i = 0; i < 8; i = i + 1) begin
            if (actual_output[i] !== expected_output[i]) begin
                $display("  >>> ERROR: Output mismatch at index %0d", i);
                $display("    Actual: %h", actual_output[i]);
                $display("    Expected: %h", expected_output[i]);
                $fdisplay(log_file, "  >>> ERROR: Output mismatch at index %0d", i);
                $fdisplay(log_file, "    Actual: %h", actual_output[i]);
                $fdisplay(log_file, "    Expected: %h", expected_output[i]);
                mismatch_count = mismatch_count + 1;
            end else begin
                $display("  Output[%0d] matches: %h", i, actual_output[i]);
                $fdisplay(log_file, "  Output[%0d] matches: %h", i, actual_output[i]);
            end
        end

        // --- Display final statistics ---
        $display("\n[Test Statistics]");
        $display("  Total packets processed : %0d", total_packets);
        $display("  Total input errors      : %0d", error_count);
        $display("  Total output mismatches : %0d", mismatch_count);
        
        $fdisplay(log_file, "\n[Test Statistics]");
        $fdisplay(log_file, "  Total packets processed : %0d", total_packets);
        $fdisplay(log_file, "  Total input errors      : %0d", error_count);
        $fdisplay(log_file, "  Total output mismatches : %0d", mismatch_count);
        $fdisplay(log_file, "\n=== Simulation Completed ===");
        $fdisplay(log_file, "End Time: %t", $time);

        #100;
        $fclose(log_file);
        $stop;
    end

endmodule
