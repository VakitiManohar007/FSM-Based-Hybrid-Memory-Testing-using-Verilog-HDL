`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 17:43:32
// Design Name: 
// Module Name: TOPF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TOPF (
 input clk,
    input rst,
    input start,
    output done,
    output fail,
    output [3:0] state,
    output [3:0] addr,
    output  [1:0]phase,
    output  [3:0] fault_count,
    output  [3:0] last_fault_addr, 
    output  [31:0] total_cycles,
    output [2:0]fault_type
);

wire rd_data;
wire done_up, done_down;
wire wr_en, rd_en, wr_data, inc, dec;

mem_model MEM(
    .clk(clk),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .addr(addr),
    .wr_data(wr_data),
    .rd_data(rd_data)
);


addr_counter ADDR(
    .clk(clk),
    .rst(rst),
    .inc(inc),
    .dec(dec),
    .addr(addr),
    .done_up(done_up),
    .done_down(done_down)
);


HYB DUT(
    clk,rst,start,rd_data,addr,done_up,done_down,wr_en,rd_en,wr_data,inc,dec,fail,done,phase,
    state,
    fault_count,last_fault_addr,total_cycles,fault_type);

endmodule
