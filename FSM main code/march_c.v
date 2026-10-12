`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 17:26:28
// Design Name: 
// Module Name: march_c
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


module march_c(
 input  clk,
    input  rst,
    input  start,
    input  rd_data,
    input  done_up,
    input  done_down,
    input  [3:0] addr,
    output reg[3:0]state,
    output reg wr_en,
    output reg rd_en,
    output reg wr_data,
    output reg inc,
    output reg dec,
    output reg fail,
    output reg done,
    output reg [2:0] fault_type
    );
    parameter IDLE=4'd0,W0=4'd1,R0=4'd2,C0=4'd3,W1=4'd4,R1=4'd5,
C1=4'd6,W0D=4'd7,R0D=4'd8,C0D=4'd9,W1D=4'd10,R1D=4'd11,C1D=4'd12,DONE=4'd13;
reg prev_state,rd_l;
always@(posedge clk)begin prev_state<=state;rd_l<=rd_data;end
always@(posedge clk or posedge rst)begin
if(rst)state<=IDLE;
else begin
case(state)
IDLE:if(start)state<=W0;
W0:state<=R0;
R0:state<=C0;
C0:begin if(done_up)state<=W1D; else state<=W0;end
W1D:state<=R1D;
R1D:state<=C1D;
C1D:begin   if(done_down)state<=W1;else state<=W1D; end 
W1:state<=R1;
R1:state<=C1;
C1:begin if(done_up)state<=W0D; else state<=W1;end
W0D:state<=R0D;
R0D:state<=C0D;
C0D:begin if(done_down)state<=DONE; else state<=W0D;end
DONE:state<=DONE;
default:state<=IDLE;
endcase
end
end
   always@(*)begin
   wr_en=0;
   rd_en=0;wr_data=0;inc=0;dec=0;done=0;
   case(state)
   W0:begin wr_en=1;wr_data=0;end
   R0:rd_en=1;
   C0:inc=1;
   W1D:begin wr_en=1;wr_data=1;end
   R1D:rd_en=1;
   C1D:dec=1;
   W1:begin wr_en=1;wr_data=1;end
   R1:rd_en=1;
   C1:inc=1;
   W0D:begin wr_en=1;wr_data=0;end
   R0D:rd_en=1;
   C0D:dec=1;
   DONE:done=1;
   endcase
   end
   always@(posedge clk or posedge rst)begin
   if(rst)fail<=0;
   else begin
   case(state)
  C0:if(rd_data!=1'b0) begin
   fail<=1'b1;fault_type<=3'd1;end
  C1D:if(rd_data!=1'b1)begin fail<=1'b1;fault_type<=3'b0;end
  C1:if(rd_data!=1'b1)begin fail<=1'b1;fault_type<=3'b0;end
  C0D:if(rd_data!=1'b0)begin fail<=1'b1;fault_type<=3'd1;end
  default:fail<=0;
  endcase
   end
   end
endmodule
