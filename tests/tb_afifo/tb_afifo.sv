`timescale 1ns / 1ps

module tb_afifo #(
    parameter DATA_WIDTH = 32,
    parameter CLK_PERIOD = 10,
    parameter STEP       = 13
);

logic clk_r = 0;
logic clk_w = 0;
logic arst;
logic we_i;
logic re_i;
logic full;
logic empty;
logic [DATA_WIDTH-1:0] data_w;
logic [DATA_WIDTH-1:0] data_r;

`ifdef USE_POWER_PINS
wire VPWR = 1;
wire VGND = 0;
`endif

afifo #(
    .DATA_WIDTH(DATA_WIDTH)
) UUT (
    .clk_w  (clk_w),
    .clk_r  (clk_r),
    .arst   (arst),
    .we_i   (we_i),
    .re_i   (re_i),
    .data_w (data_w),
    .data_r (data_r),
    .full   (full),
    .empty  (empty)
);

initial begin
    $dumpfile("tb_afifo.vcd");
    $dumpvars(0, tb_afifo);
    arst   = 1;
    we_i   = 0;
    re_i   = 0;
    data_w = '0;
    #(2*CLK_PERIOD);
    arst = 0;
    #(STEP)      data_w = 32'hfeedbeef;
    we_i = 1;
    #(STEP)      data_w = 32'hdeadbeef;
    #(STEP)      data_w = 32'hdeaddead;
    #(STEP)      data_w = 32'hbeefbeef;
    we_i = 0;
    re_i = 1;
    #(STEP)      data_w = 32'hfeedfeed;
    #(STEP*7);
    $finish;
end

always #(CLK_PERIOD/2)      clk_r = ~clk_r;
always #(CLK_PERIOD * 7/10) clk_w = ~clk_w;

endmodule
