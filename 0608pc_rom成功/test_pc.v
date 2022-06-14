
module test_pc(); 

reg reset;
reg clk;
wire[31:0] ans;

always begin
    #5 clk = ~clk;
end
initial begin
    $readmemb("./Rom.data", rv32IRJCore0.ROM_InstrMem0.rom);
    $monitor("time:%4d   clk: %b   reset: %b\nans: %b\n", $stime, clk, reset, ans);
    reset = 1;
    clk = 0;
#8 reset = 0;

#52 $finish;
end


rv32IRJCore rv32IRJCore0(
    .reset_i_core(reset),
    .clk_i_core(clk),

    .instr_i_core(ans)
);
   
endmodule
