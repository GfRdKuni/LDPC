
module name_display ( clk, rst_n, lcd_en, lcd_rs, lcd_rw, lcd_db, lcd_rst );
  output [7:0] lcd_db;
  input clk, rst_n;
  output lcd_en, lcd_rs, lcd_rw, lcd_rst;
  wire   \*Logic1* , \*Logic0* , lcd_rst, N8, N9, N10, N11, N12, N13, N14, N17,
         N18, N19, N20, N21, N22, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93,
         n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105,
         n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
         n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149,
         n150, n151, n152;
  wire   [6:1] cnt_lcd;
  assign lcd_rs = \*Logic1* ;
  assign lcd_db[7] = \*Logic0* ;
  assign lcd_rw = \*Logic0* ;
  assign lcd_rst = rst_n;

  DFFRHQ \cnt_lcd_reg[0]  ( .D(n152), .CK(clk), .RN(n151), .Q(lcd_en) );
  DFFRHQ \cnt_lcd_reg[1]  ( .D(N17), .CK(clk), .RN(n151), .Q(cnt_lcd[1]) );
  DFFRHQ \cnt_lcd_reg[2]  ( .D(N18), .CK(clk), .RN(n151), .Q(cnt_lcd[2]) );
  DFFRHQ \cnt_lcd_reg[3]  ( .D(N19), .CK(clk), .RN(n151), .Q(cnt_lcd[3]) );
  DFFRHQ \cnt_lcd_reg[4]  ( .D(N20), .CK(clk), .RN(n151), .Q(cnt_lcd[4]) );
  DFFRHQ \cnt_lcd_reg[5]  ( .D(N21), .CK(clk), .RN(n151), .Q(cnt_lcd[5]) );
  DFFRHQ \cnt_lcd_reg[6]  ( .D(N22), .CK(clk), .RN(n151), .Q(cnt_lcd[6]) );
  DFFRHQ \lcd_db_reg[2]  ( .D(N10), .CK(clk), .RN(n151), .Q(lcd_db[2]) );
  DFFRHQ \lcd_db_reg[5]  ( .D(N13), .CK(clk), .RN(n151), .Q(lcd_db[5]) );
  DFFRHQ \lcd_db_reg[4]  ( .D(N12), .CK(clk), .RN(n151), .Q(lcd_db[4]) );
  DFFRHQ \lcd_db_reg[6]  ( .D(N14), .CK(clk), .RN(n151), .Q(lcd_db[6]) );
  DFFRHQ \lcd_db_reg[3]  ( .D(N11), .CK(clk), .RN(n151), .Q(lcd_db[3]) );
  DFFRHQ \lcd_db_reg[0]  ( .D(N8), .CK(clk), .RN(n151), .Q(lcd_db[0]) );
  DFFRHQ \lcd_db_reg[1]  ( .D(N9), .CK(clk), .RN(n151), .Q(lcd_db[1]) );
  LOGIC_0 U81 ( .LOGIC_0_PIN(\*Logic0* ) );
  LOGIC_1 U82 ( .LOGIC_1_PIN(\*Logic1* ) );
  INV U83 ( .A(lcd_rst), .Y(n151) );
  OAI211 U84 ( .A0(n71), .A1(n72), .B0(n73), .C0(n74), .Y(N9) );
  AOI222 U85 ( .A0(n75), .A1(n76), .B0(n77), .B1(n78), .C0(n79), .C1(n80), .Y(
        n74) );
  OAI2BB1 U86 ( .A0N(n81), .A1N(n72), .B0(n82), .Y(n77) );
  OAI32 U87 ( .A0(n83), .A1(cnt_lcd[2]), .A2(cnt_lcd[1]), .B0(n84), .B1(n85), 
        .Y(n81) );
  INV U88 ( .A(n86), .Y(n75) );
  NOR2 U89 ( .A(n87), .B(n88), .Y(n73) );
  AOI2BB2 U90 ( .B0(n89), .B1(n90), .A0N(n76), .A1N(n91), .Y(n71) );
  INV U91 ( .A(n92), .Y(N8) );
  NOR4B U92 ( .AN(n93), .B(n87), .C(n94), .D(n95), .Y(n92) );
  OAI32 U93 ( .A0(n96), .A1(cnt_lcd[3]), .A2(n91), .B0(n97), .B1(n85), .Y(n95)
         );
  AOI21 U94 ( .A0(n98), .A1(n76), .B0(n99), .Y(n97) );
  NOR3B U95 ( .AN(n100), .B(n101), .C(n102), .Y(n87) );
  AOI222 U96 ( .A0(n101), .A1(n103), .B0(n78), .B1(n104), .C0(n105), .C1(n106), 
        .Y(n93) );
  OAI221 U97 ( .A0(n91), .A1(n107), .B0(n98), .B1(n85), .C0(n108), .Y(n104) );
  AOI31 U98 ( .A0(n99), .A1(cnt_lcd[2]), .A2(n89), .B0(n109), .Y(n108) );
  XOR2 U99 ( .A(cnt_lcd[6]), .B(n110), .Y(N22) );
  NOR2B U100 ( .AN(n111), .B(n112), .Y(n110) );
  XOR2 U101 ( .A(n111), .B(cnt_lcd[5]), .Y(N21) );
  NOR3B U102 ( .AN(n113), .B(n78), .C(n72), .Y(n111) );
  OAI2BB2 U103 ( .B0(n114), .B1(n78), .A0N(n113), .A1N(n115), .Y(N20) );
  NOR2B U104 ( .AN(n113), .B(n72), .Y(n114) );
  XOR2 U105 ( .A(n113), .B(cnt_lcd[3]), .Y(N19) );
  NOR2B U106 ( .AN(n84), .B(n152), .Y(n113) );
  XOR2 U107 ( .A(cnt_lcd[2]), .B(n116), .Y(N18) );
  NOR2B U108 ( .AN(cnt_lcd[1]), .B(n152), .Y(n116) );
  XOR2 U109 ( .A(lcd_en), .B(cnt_lcd[1]), .Y(N17) );
  INV U110 ( .A(n117), .Y(N14) );
  NOR3B U111 ( .AN(n118), .B(n119), .C(n120), .Y(n117) );
  OAI221 U112 ( .A0(n121), .A1(n85), .B0(cnt_lcd[3]), .B1(n122), .C0(n123), 
        .Y(n120) );
  AOI21 U113 ( .A0(cnt_lcd[3]), .A1(n102), .B0(n90), .Y(n121) );
  MX2 U114 ( .A(n124), .B(n125), .S0(n99), .Y(n119) );
  NOR2B U115 ( .AN(n89), .B(cnt_lcd[2]), .Y(n125) );
  NOR2B U116 ( .AN(cnt_lcd[2]), .B(n126), .Y(n124) );
  MX2 U117 ( .A(n127), .B(n128), .S0(cnt_lcd[2]), .Y(N13) );
  OAI221 U118 ( .A0(n85), .A1(n129), .B0(cnt_lcd[4]), .B1(n86), .C0(n82), .Y(
        n128) );
  AOI2BB1 U119 ( .A0N(n85), .A1N(n130), .B0(n131), .Y(n86) );
  INV U120 ( .A(n80), .Y(n129) );
  NOR3B U121 ( .AN(n78), .B(n130), .C(n126), .Y(n127) );
  OR2 U122 ( .A(n132), .B(n133), .Y(N12) );
  MX2 U123 ( .A(n109), .B(n134), .S0(cnt_lcd[2]), .Y(n133) );
  OAI31 U124 ( .A0(n85), .A1(cnt_lcd[4]), .A2(cnt_lcd[3]), .B0(n135), .Y(n134)
         );
  NOR2B U125 ( .AN(n82), .B(n131), .Y(n135) );
  INV U126 ( .A(n136), .Y(n82) );
  NOR2B U127 ( .AN(n137), .B(n91), .Y(n136) );
  OAI32 U128 ( .A0(n96), .A1(n85), .A2(n138), .B0(n123), .B1(n107), .Y(n132)
         );
  NOR2 U129 ( .A(n99), .B(n84), .Y(n107) );
  OAI211 U130 ( .A0(n130), .A1(n122), .B0(n139), .C0(n140), .Y(N11) );
  AOI211 U131 ( .A0(n141), .A1(n84), .B0(n88), .C0(n94), .Y(n140) );
  NOR3B U132 ( .AN(cnt_lcd[3]), .B(n101), .C(n123), .Y(n94) );
  INV U133 ( .A(n106), .Y(n123) );
  NOR2B U134 ( .AN(n79), .B(n78), .Y(n106) );
  AOI211 U135 ( .A0(n102), .A1(n101), .B0(n85), .C0(n72), .Y(n88) );
  NAND2B U136 ( .AN(n76), .B(cnt_lcd[4]), .Y(n102) );
  NOR2B U137 ( .AN(cnt_lcd[3]), .B(n83), .Y(n141) );
  INV U138 ( .A(n89), .Y(n83) );
  MX2 U139 ( .A(n142), .B(n143), .S0(cnt_lcd[4]), .Y(n139) );
  NAND2 U140 ( .A(n144), .B(n99), .Y(n143) );
  OAI31 U141 ( .A0(n145), .A1(n100), .A2(n131), .B0(n76), .Y(n142) );
  NOR2B U142 ( .AN(n79), .B(n138), .Y(n131) );
  NOR2B U143 ( .AN(n138), .B(n91), .Y(n145) );
  INV U144 ( .A(n99), .Y(n138) );
  NOR2B U145 ( .AN(n101), .B(n72), .Y(n99) );
  INV U146 ( .A(n103), .Y(n122) );
  NOR2B U147 ( .AN(n89), .B(n96), .Y(n103) );
  INV U148 ( .A(n105), .Y(n130) );
  NOR2B U149 ( .AN(n72), .B(cnt_lcd[1]), .Y(n105) );
  OAI221 U150 ( .A0(n146), .A1(n85), .B0(cnt_lcd[2]), .B1(n118), .C0(n147), 
        .Y(N10) );
  AOI2BB2 U151 ( .B0(n79), .B1(n148), .A0N(n149), .A1N(n91), .Y(n147) );
  INV U152 ( .A(n144), .Y(n91) );
  NOR2 U153 ( .A(n80), .B(n90), .Y(n149) );
  NOR2 U154 ( .A(n78), .B(n98), .Y(n80) );
  INV U155 ( .A(n137), .Y(n98) );
  OAI2BB2 U156 ( .B0(n150), .B1(cnt_lcd[1]), .A0N(cnt_lcd[2]), .A1N(n115), .Y(
        n148) );
  AOI21 U157 ( .A0(n144), .A1(n115), .B0(n109), .Y(n118) );
  NOR2B U158 ( .AN(n137), .B(n126), .Y(n109) );
  INV U159 ( .A(n79), .Y(n126) );
  NOR2B U160 ( .AN(n89), .B(n112), .Y(n79) );
  NOR2B U161 ( .AN(n78), .B(n72), .Y(n115) );
  NOR2B U162 ( .AN(n89), .B(cnt_lcd[5]), .Y(n144) );
  NOR2B U163 ( .AN(cnt_lcd[6]), .B(n152), .Y(n89) );
  INV U164 ( .A(n100), .Y(n85) );
  NOR3B U165 ( .AN(n112), .B(n152), .C(cnt_lcd[6]), .Y(n100) );
  INV U166 ( .A(lcd_en), .Y(n152) );
  INV U167 ( .A(cnt_lcd[5]), .Y(n112) );
  AOI221 U168 ( .A0(n137), .A1(cnt_lcd[2]), .B0(n150), .B1(cnt_lcd[3]), .C0(
        n90), .Y(n146) );
  OAI2BB2 U169 ( .B0(cnt_lcd[1]), .B1(n96), .A0N(n78), .A1N(n84), .Y(n90) );
  NOR2B U170 ( .AN(cnt_lcd[1]), .B(n76), .Y(n84) );
  INV U171 ( .A(n150), .Y(n96) );
  NOR2B U172 ( .AN(n76), .B(n78), .Y(n150) );
  INV U173 ( .A(cnt_lcd[4]), .Y(n78) );
  INV U174 ( .A(cnt_lcd[2]), .Y(n76) );
  NOR2B U175 ( .AN(n72), .B(n101), .Y(n137) );
  INV U176 ( .A(cnt_lcd[1]), .Y(n101) );
  INV U177 ( .A(cnt_lcd[3]), .Y(n72) );
endmodule

