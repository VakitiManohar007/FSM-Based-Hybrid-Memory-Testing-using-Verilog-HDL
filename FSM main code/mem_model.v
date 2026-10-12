`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2026 20:57:17
// Design Name: 
// Module Name: mem_model
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


module mem_model(
    input clk,
    input wr_en,
    input rd_en,
    input [3:0] addr,
    input wr_data,
    output reg rd_data
);

    reg mem [0:15];
    integer i;

    initial begin
        for(i = 0; i < 16; i = i + 1)
            mem[i] = 1'b0;
    end

    always @(posedge clk) begin
        if(wr_en)begin
        case(addr)
        4'd10:mem[addr]<=1'b1;
        4'd13:mem[addr]<=1'b0;
        4'd9:mem[addr]<=~wr_data; 
        4'd6:begin mem[6]<=wr_data;mem[7]<=~mem[7];end
        4'd10:begin if(wr_data)mem[10]<=0; else mem[10]<=wr_data;end
        default:mem[addr]<=wr_data;
        endcase
    end
    end
    

    always @(posedge clk) begin
        if(rd_en && (addr !== 4'bx)) begin
            case(addr)
            4'd4:rd_data<=~mem[4];
            4'd15:begin rd_data<=mem[15];mem[15]<=~mem[15];end
            default:rd_data<=mem[addr];
            endcase
        end
    end

endmodule