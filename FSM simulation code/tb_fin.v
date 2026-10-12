`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 17:50:19
// Design Name: 
// Module Name: tb_fin
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


module tb_fin;
reg clk;
reg rst;
reg start;

wire done;
wire fail;
wire [3:0] state;
wire [3:0] addr;
wire [1:0]phase;
wire [3:0]fault_count,last_fault_addr;
wire [31:0]total_cycles;
wire [2:0]fault_type;
TOPF DUT(
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done),
    .fail(fail),
    .state(state),
    .addr(addr),
    .phase(phase),
    .fault_count(fault_count),
    .last_fault_addr(last_fault_addr),
    .total_cycles(total_cycles),
    .fault_type(fault_type)
);

// clock
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    start = 0;

    #20;
    rst = 0;

    #10;
    start = 1;

    #10;
    start = 0;

    // run long enough for both MC + CB
    #5000;

    $display("FINAL DONE=%b FAIL=%b STATE=%d ADDR=%d",
              done, fail, state, addr);

    $finish;
end

// monitor
initial begin
    $monitor("t=%0t state=%d addr=%d fail=%b done=%b",
              $time, state, addr, fail, done);
end

endmodule
