`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 17:30:17
// Design Name: 
// Module Name: check_b
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


module check_b(
 input  clk,
    input  rst,
    input  start,
    input  rd_data,
    input  [3:0] addr,
    input  done_up,
    input done_down,
   output  reg [3:0] cb_state,
    output reg wr_en,
    output reg rd_en,
    output reg wr_data,
    output reg inc,
    output reg dec,
    output reg fail,
    output reg done,
    output reg [2:0]fault_type
    );
     parameter CB_IDLE = 4'd0,
              CB_W    = 4'd1,
              CB_R    = 4'd2,
              CB_RC   = 4'd3,
              CB_WI   = 4'd4,
              CB_RI   = 4'd5,
              CB_RIC  = 4'd6,
              CB_FIN  = 4'd7;

    reg [3:0] addr_latch;
    always @(posedge clk or posedge rst) begin
        if(rst)
            addr_latch <= 4'd0;
        else if(cb_state == CB_R || cb_state == CB_RI)
            addr_latch <= addr;
    end

    always @(posedge clk or posedge rst) begin
        if(rst)
            cb_state <= CB_IDLE;
        else begin
            case(cb_state)
                CB_IDLE: if(start)   cb_state <= CB_W;
                CB_W:    cb_state <= CB_R;
                CB_R:     cb_state <= CB_RC;
                CB_RC:   if(done_up) cb_state <= CB_WI;
                         else        cb_state <= CB_W;
                CB_WI:  cb_state <= CB_RI;
                CB_RI:   cb_state <= CB_RIC;
                CB_RIC:  if(done_down) cb_state <= CB_FIN;
                         else        cb_state <= CB_WI;
                CB_FIN:cb_state <= CB_FIN;
                default:cb_state <= CB_IDLE;
            endcase
        end
    end

    always @(*) begin
        wr_en   = 0;
        rd_en   = 0;
        wr_data = 0;
        inc     = 0;
        done    = 0;
        dec=0;

        case(cb_state)
            CB_W:   begin wr_en=1; wr_data=addr[0]; end
            CB_R:   rd_en=1;
            CB_RC:  inc=1;
            CB_WI:  begin wr_en=1; wr_data=~addr[0]; end
            CB_RI:  begin rd_en=1; end
            CB_RIC: dec=1;
            CB_FIN: begin done=1; end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst)
            fail <= 1'b0;
        else begin
            fail <= 1'b0;
            case(cb_state)
            CB_RC:
             begin
                if(addr_latch[0] == 1'b0 && rd_data !== 1'b0)begin  fail <= 1'b1;fault_type<=3'd1;end
                if(addr_latch[0] == 1'b1 && rd_data !== 1'b1)begin fail <= 1'b1;fault_type<=3'b0;end
            end
            CB_RIC:
            begin
                if(addr_latch[0] == 1'b0 && rd_data !== 1'b1) begin fail <= 1'b1;fault_type<=3'b0;end
                if(addr_latch[0] == 1'b1 && rd_data !== 1'b0)begin fail <= 1'b1;fault_type<=3'd1;end
            end
            endcase
        end
    end
endmodule
