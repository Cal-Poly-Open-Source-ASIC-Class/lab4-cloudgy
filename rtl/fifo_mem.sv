`timescale 1ns / 1ps

module fifo_mem #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH       = 8,
    localparam PTR_WIDTH  = $clog2(DEPTH)
) (
    input  logic                  clk_w,
    input  logic                  clk_r,
    input  logic                  arst,
    input  logic                  w_en,
    input  logic                  r_en,
    input  logic [PTR_WIDTH:0]    b_wptr,
    input  logic [PTR_WIDTH:0]    b_rptr,
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic                  full,
    input  logic                  empty,
    output logic [DATA_WIDTH-1:0] data_out
);

logic [DATA_WIDTH-1:0] fifo_mem_array [DEPTH];

always_ff @(posedge clk_w) begin
    if (w_en & !full)
        fifo_mem_array[b_wptr[PTR_WIDTH-1:0]] <= data_in;
end

always_ff @(posedge clk_r) begin
    if (arst)
        data_out <= '0;
    else if (r_en & !empty)
        data_out <= fifo_mem_array[b_rptr[PTR_WIDTH-1:0]];
end

endmodule
