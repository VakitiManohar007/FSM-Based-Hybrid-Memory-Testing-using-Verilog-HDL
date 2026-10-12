`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2026 18:20:26
// Design Name: 
// Module Name: HYB
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


module HYB(
     input  clk,
    input  rst,
    input  start,
    input  rd_data,
    input  [3:0] addr,
    input  done_up,
    input  done_down,
    output wr_en,
    output rd_en,
    output wr_data,
    output inc,
    output dec,
    output fail,
    output reg done,
    output reg [1:0] phase,
    output [3:0]state,
    output reg [3:0] fault_count,
    output reg [3:0] last_fault_addr, 
    output reg [31:0] total_cycles ,
    output [2:0] fault_type
);
 reg mc_start, cb_start, addr_rst;
    reg [1:0] wait_cnt;
    reg timer_active; // Internal flag to manage cycle counting
wire [3:0]mc_state,cb_state;
    wire mc_wr_en, mc_rd_en, mc_wr_data, mc_inc, mc_dec, mc_fail, mc_done;
    wire cb_wr_en, cb_rd_en, cb_wr_data, cb_inc, cb_fail, cb_done,cb_dec;
    reg[15:0]signature;
    wire [2:0]m_fault_type,c_fault_type;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            phase           <= 2'd0;
            mc_start        <= 0;
            cb_start        <= 0;
            addr_rst        <= 0;
            wait_cnt        <= 0;
            done            <= 0;
            fault_count     <= 0;
            last_fault_addr <= 0;
            total_cycles    <= 0;
            timer_active    <= 0;
        end
        else begin
            mc_start <= 0;
            cb_start <= 0;
            addr_rst <= 0;

            // Tracking logic
            fault_count <= fault_count + mc_fail + cb_fail;
            
            if (mc_fail || cb_fail) 
                last_fault_addr <= addr;
                

            if (start) 
                timer_active <= 1;
            else if (done)
                timer_active <= 0;

            if (timer_active)
                total_cycles <= total_cycles + 1;

            case(phase)
                2'd0: begin
                    done <= 0;
                    if(start) begin
                        phase    <= 2'd1;
                        mc_start <= 1;
                    end
                end

                2'd1: begin
                    if(mc_done) begin
                        phase    <= 2'd2;
                        addr_rst <= 1;
                        wait_cnt <= 2'd2;
                    end
                end

                2'd2: begin
                    if(wait_cnt > 0) begin
                        wait_cnt <= wait_cnt - 1;
                        if(wait_cnt == 2'd1)
                            cb_start <= 1;
                    end
                    else if(cb_done) begin
                        phase <= 2'd3;
                        done  <= 1;
                    end
                end

                2'd3: begin
                    done <= 1;
                end
            endcase
        end
    end
    wire mc_active = (phase == 2'd1);
    wire cb_active = (phase == 2'd2) && (wait_cnt == 0);

    assign wr_en   = mc_active ? mc_wr_en   : (cb_active ? cb_wr_en   : 1'b0);
    assign rd_en   = mc_active ? mc_rd_en   : (cb_active ? cb_rd_en   : 1'b0);
    assign wr_data = mc_active ? mc_wr_data : (cb_active ? cb_wr_data : 1'b0);
    assign inc     = mc_active ? mc_inc      : (cb_active ? cb_inc      : 1'b0);
    assign dec     = mc_active ? mc_dec      : (cb_active?cb_dec:1'b0);
    assign fail    = mc_fail | cb_fail;
    march_c MC(
        .clk(clk), .rst(rst), .start(mc_start), .rd_data(rd_data),
        .done_up(done_up), .done_down(done_down), .addr(addr),.state(mc_state),
        .wr_en(mc_wr_en), .rd_en(mc_rd_en), .wr_data(mc_wr_data),
        .inc(mc_inc), .dec(mc_dec), .fail(mc_fail), .done(mc_done),.fault_type(m_fault_type)
    );

    check_b CB(
        .clk(clk), .rst(rst | addr_rst), .start(cb_start), .rd_data(rd_data),
        .addr(addr), .done_up(done_up),.done_down(done_down),.cb_state(cb_state), .wr_en(cb_wr_en), .rd_en(cb_rd_en),
        .wr_data(cb_wr_data), .inc(cb_inc),.dec(cb_dec), .fail(cb_fail), .done(cb_done),.fault_type(c_fault_type)
    );
    always @(posedge clk or posedge rst)
begin
    if(rst)
        signature <= 16'h0000;

    else if(rd_en&& rd_data!==1'bx)
    begin
        signature[0]  <= signature[15] ^ rd_data;
        signature[1]  <= signature[0];
        signature[2]  <= signature[1] ^ addr[0];
        signature[3]  <= signature[2];
        signature[4]  <= signature[3] ^ addr[1];
        signature[5]  <= signature[4];
        signature[6]  <= signature[5];
        signature[7]  <= signature[6] ^ addr[2];
        signature[8]  <= signature[7];
        signature[9]  <= signature[8];
        signature[10] <= signature[9] ^ addr[3];
        signature[11] <= signature[10];
        signature[12] <= signature[11];
        signature[13] <= signature[12];
        signature[14] <= signature[13];
        signature[15] <= signature[14];
    end
end
always@(posedge clk)begin
$display("signature:%h rd_data=%b",signature,rd_data);
end
 assign state=mc_active?mc_state:cb_state;
 assign fault_type=mc_active?m_fault_type:c_fault_type;
endmodule
