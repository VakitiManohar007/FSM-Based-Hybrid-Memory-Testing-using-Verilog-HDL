`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2026 20:58:32
// Design Name: 
// Module Name: addr_counter
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


module addr_counter(
    input  clk,
    input  rst,
    input  inc,
    input  dec,
    output reg [3:0] addr,
    output done_up,
    output done_down
);

    always @(posedge clk or posedge rst) begin
        if(rst)
            addr <= 4'd0;
        else begin
        case({inc,dec})
        2'b10:if(addr!=4'd15)addr<=addr+1'b1;
        2'b01:if(addr!=4'd0)addr<=addr-1'b1;
        default:addr<=addr;
        endcase
        end      
    end
    assign done_up   = (addr == 4'd15);
    assign done_down = (addr == 4'd0);

endmodule
