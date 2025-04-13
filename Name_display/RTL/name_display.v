module name_display(
 input clk,
 input rst_n,
 output lcd_en, // LED enable
 output lcd_rs, // register select
                        // 0 : write command register
                        // 1 : write data register
 output lcd_rw, // Read/Write Signal
                        // 0 : write
                        // 1 : No function
 output reg [7:0] lcd_db,
 output lcd_rst);
 
 reg  [7:0] DB_tmp1;
 reg  [7:0] DB_tmp2;
 reg  [6:0] cnt_lcd; 
 wire  rst;
// ------------
// Text LCD Main Circuit
// ------------

assign rst = rst_n;
assign lcd_rw = 1'b0;
assign lcd_rs = 1'b1;
assign lcd_rst = rst;
assign lcd_en = cnt_lcd[0];

always @(posedge clk or posedge rst)
   if (rst) lcd_db <= 0;
   else if (lcd_en & cnt_lcd[6]) lcd_db <= DB_tmp1;
   else if (lcd_en & ~cnt_lcd[6]) lcd_db <= DB_tmp2;
   else lcd_db <= 0;
       
always @(posedge clk or posedge rst)
   if (rst) cnt_lcd <= 0;
   else  cnt_lcd <= cnt_lcd + 1;
      

always @(cnt_lcd) begin
    case (cnt_lcd[5:1])
        5'h00: DB_tmp0 = 8'h0a;  //*
        5'h01: DB_tmp0 = 8'h0a;  //*
        5'h02: DB_tmp0 = 8'h00;  //Space
        5'h03: DB_tmp0 = 8'h37;  //W
        5'h04: DB_tmp0 = 8'h45;  //e
        5'h05: DB_tmp0 = 8'h4c;  //l
        5'h06: DB_tmp0 = 8'h43;  //c
        5'h07: DB_tmp0 = 8'h4f;  //o
        5'h08: DB_tmp0 = 8'h4d;  //m
        5'h09: DB_tmp0 = 8'h45;  //e
        5'h0A: DB_tmp0 = 8'h00;  //Space
        5'h0B: DB_tmp0 = 8'h34;  //T
        5'h0C: DB_tmp0 = 8'h4f;  //o
        5'h0D: DB_tmp0 = 8'h00;  //Space
        5'h0E: DB_tmp0 = 8'h0a;  //*
        5'h0F: DB_tmp0 = 8'h0a;  //*
        5'h10: DB_tmp0 = 8'h26;  //F
        5'h11: DB_tmp0 = 8'h55;  //u
        5'h12: DB_tmp0 = 8'h44;  //d
        5'h13: DB_tmp0 = 8'h41;  //a
        5'h14: DB_tmp0 = 8'h4e;  //n
        5'h15: DB_tmp0 = 8'h00;  //Space
        5'h16: DB_tmp0 = 8'h35;  //U
        5'h17: DB_tmp0 = 8'h4e;  //n
        5'h18: DB_tmp0 = 8'h49;  //i
        5'h19: DB_tmp0 = 8'h56;  //v
        5'h1A: DB_tmp0 = 8'h45;  //e
        5'h1B: DB_tmp0 = 8'h52;  //r
        5'h1C: DB_tmp0 = 8'h53;  //s
        5'h1D: DB_tmp0 = 8'h49;  //i
        5'h1E: DB_tmp0 = 8'h54;  //t
        5'h1F: DB_tmp0 = 8'h59;  //y
        default: DB_tmp0 = 8'h00;  //Space
    endcase
end

always @(cnt_lcd) begin
    case (cnt_lcd[5:1])
        5'h00: DB_tmp1 = 8'h0b;  //+
        5'h01: DB_tmp1 = 8'h0b;  //+
        5'h02: DB_tmp1 = 8'h32;  //R
        5'h03: DB_tmp1 = 8'h55;  //u
        5'h04: DB_tmp1 = 8'h49;  //i
        5'h05: DB_tmp1 = 8'h4b;  //k
        5'h06: DB_tmp1 = 8'h41;  //a
        5'h07: DB_tmp1 = 8'h4e;  //n
        5'h08: DB_tmp1 = 8'h47;  //g
        5'h09: DB_tmp1 = 8'h00;  //Space
        5'h0a: DB_tmp1 = 8'h00;  //Space
        5'h0b: DB_tmp1 = 8'h27;  //G
        5'h0c: DB_tmp1 = 8'h55;  //u
        5'h0d: DB_tmp1 = 8'h4f;  //o
        5'h0e: DB_tmp1 = 8'h0b;  //+
        5'h0f: DB_tmp1 = 8'h0b;  //+
        default: DB_tmp1 = 8'h00;  //Space
    endcase
end
             
endmodule
