module multiplication(
input [31:0] a,b,
output [63:0] ab
);

wire [31:0] t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25,t26,t27,t28,t29,t30,t31;

assign t0 = (b[0]==1) ? a : 4'h0;
assign t1 = (b[1]==1) ? a : 4'h0;
assign t2 = (b[2]==1) ? a : 4'h0;
assign t3 = (b[3]==1) ? a : 4'h0;
assign t4 = (b[4]==1) ? a : 4'h0;
assign t5 = (b[5]==1) ? a : 4'h0;
assign t6 = (b[6]==1) ? a : 4'h0;
assign t7 = (b[7]==1) ? a : 4'h0;
assign t8 = (b[8]==1) ? a : 4'h0;
assign t9 = (b[9]==1) ? a : 4'h0;
assign t10 = (b[10]==1) ? a : 4'h0;
assign t11 = (b[11]==1) ? a : 4'h0;
assign t12 = (b[12]==1) ? a : 4'h0;
assign t13 = (b[13]==1) ? a : 4'h0;
assign t14 = (b[14]==1) ? a : 4'h0;
assign t15 = (b[15]==1) ? a : 4'h0;
assign t16 = (b[16]==1) ? a : 4'h0;
assign t17 = (b[17]==1) ? a : 4'h0;
assign t18 = (b[18]==1) ? a : 4'h0;
assign t19 = (b[19]==1) ? a : 4'h0;
assign t20 = (b[20]==1) ? a : 4'h0;
assign t21 = (b[21]==1) ? a : 4'h0;
assign t22 = (b[22]==1) ? a : 4'h0;
assign t23 = (b[23]==1) ? a : 4'h0;
assign t24 = (b[24]==1) ? a : 4'h0;
assign t25 = (b[25]==1) ? a : 4'h0;
assign t26 = (b[26]==1) ? a : 4'h0;
assign t27 = (b[27]==1) ? a : 4'h0;
assign t28 = (b[28]==1) ? a : 4'h0;
assign t29 = (b[29]==1) ? a : 4'h0;
assign t30 = (b[30]==1) ? a : 4'h0;
assign t31 = (b[31]==1) ? a : 4'h0;

assign ab=t0+(t1<<1)+(t2<<2)+(t3<<3)+(t4<<4)+(t5<<5)+(t6<<6)+(t7<<7)+(t8<<8)+(t9<<9)+(t10<<10)+(t11<<11)+(t12<<12)+(t13<<13)+(t14<<14)+(t15<<15)+(t16<<16)+(t17<<17)+(t18<<18)+(t19<<19)+(t20<<20)+(t21<<21)+(t22<<22)+(t23<<23)+(t24<<24)+(t25<<25)+(t26<<26)+(t27<<27)+(t28<<28)+(t29<<29)+(t30<<30)+(t31<<31);

endmodule