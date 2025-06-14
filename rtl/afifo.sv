`timescale 1ns / 1ps

module afifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 8,
    parameter PTR_WIDTH  = $clog2(DEPTH)
) (
    input  logic                  clk_w,
    input  logic                  clk_r,
    input  logic                  arst,
    input  logic                  we_i,
    input  logic                  re_i,
    input  logic [DATA_WIDTH-1:0] data_w,
    output logic [DATA_WIDTH-1:0] data_r,
    output logic                  full,
    output logic                  empty
);

logic [PTR_WIDTH:0] b_wptr, g_wptr;
logic [PTR_WIDTH:0] b_rptr, g_rptr;
logic [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;

wire [PTR_WIDTH-1:0] waddr = b_wptr[PTR_WIDTH-1:0];
wire [PTR_WIDTH-1:0] raddr = b_rptr[PTR_WIDTH-1:0];

synchronizer #(PTR_WIDTH) sync_wptr (
    .*, .clk(clk_r), .d_in(g_wptr), .d_out(g_wptr_sync)
);

synchronizer #(PTR_WIDTH) sync_rptr (
    .*, .clk(clk_w), .d_in(g_rptr), .d_out(g_rptr_sync)
);

wptr_handler #(PTR_WIDTH) wptr_h (
    .*, .w_en(we_i)
);

rptr_handler #(PTR_WIDTH) rptr_h (
    .*, .r_en(re_i)
);

fifo_mem #(DATA_WIDTH, DEPTH) fifo_mem_i (
    .*, .w_en(we_i), .r_en(re_i), .data_in(data_w), .data_out(data_r)
);

assign full  = (g_wptr == {~g_rptr_sync[PTR_WIDTH], g_rptr_sync[PTR_WIDTH-1:0]});
assign empty = (g_rptr == g_wptr_sync);

endmodule
