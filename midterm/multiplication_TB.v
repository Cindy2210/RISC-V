
module multiplication_TB();

reg [31:0] tb_multiplicand;
reg [31:0] tb_multiplier;

wire [63:0] product;

initial begin
    tb_multiplicand = 32'b0111;
    tb_multiplier = 32'b0111;

#10 $display("time:%4d\nmultiplicand: %b\nmultiplier: %b\nproduct: %b\n", $stime, tb_multiplicand, tb_multiplier, product);
#13
    tb_multiplicand = 32'b1111;
    tb_multiplier = 32'b1111111;

#20 $display("time:%4d\nmultiplicand: %b\nmultiplier: %b\nproduct: %b\n", $stime, tb_multiplicand, tb_multiplier, product);

#23    
    tb_multiplicand = 32'h55;
    tb_multiplier = 32'h99;

#30 $display("time:%4d\nmultiplicand: %b\nmultiplier: %b\nproduct: %b\n", $stime, tb_multiplicand, tb_multiplier, product);

#60 $finish;
end

//always begin
//    #5 clk = ~clk;
//end

multiplication multi(
    .a(tb_multiplicand),
    .b(tb_multiplier),

    .ab(product)
);
   
endmodule
