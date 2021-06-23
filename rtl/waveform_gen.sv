/*
 * waveform_gen.sv
 *
 *  Created on: 2021-05-25 18:57
 *      Author: Jack Chen <redchenjs@live.com>
 */

module waveform_gen(
    input logic clk_i,
    input logic rst_n_i,

    input logic [23:0] ram_rd_data_ch0_i,
    input logic [23:0] ram_rd_data_ch1_i,

    output logic [15:0] ram_rd_addr_o,

    output logic       hub75e_oe_o,
    output logic       hub75e_r0_o,
    output logic       hub75e_g0_o,
    output logic       hub75e_b0_o,
    output logic       hub75e_r1_o,
    output logic       hub75e_g1_o,
    output logic       hub75e_b1_o,
    output logic       hub75e_clk_o,
    output logic       hub75e_lat_o,
    output logic [3:0] hub75e_addr_o
);

typedef enum logic [1:0] {
    IDLE,
    READ_RAM,
    WAIT_BIT,
    NEXT_FRM
} state_t;

state_t ctl_sta;

logic clk_en;

logic hub75e_s_p;
logic hub75e_s_n;

logic [1:0] clk_cnt;

logic [7:0] bit_set;
logic [7:0] bit_cnt;
logic [2:0] bit_sel;

logic [7:0] byte_cnt;

logic [15:0] ram_rd_addr;

logic hub75e_r0;
logic hub75e_g0;
logic hub75e_b0;
logic hub75e_r1;
logic hub75e_g1;
logic hub75e_b1;
logic hub75e_oe;
logic hub75e_lat;
logic [2:0] hub75e_addr;

wire ram_rd_data_r0 = ram_rd_data_ch0_i[23:16];
wire ram_rd_data_g0 = ram_rd_data_ch0_i[15:8];
wire ram_rd_data_b0 = ram_rd_data_ch0_i[7:0];

wire ram_rd_data_r1 = ram_rd_data_ch1_i[23:16];
wire ram_rd_data_g1 = ram_rd_data_ch1_i[15:8];
wire ram_rd_data_b1 = ram_rd_data_ch1_i[7:0];

wire next_ram = bit_sel[0];
wire next_line = (byte_cnt == 8'hff) & next_ram;

wire scan_h_done = (byte_cnt == 8'hff) & next_ram;
wire scan_v_done = hub75e_addr == 5'h0f;
wire scan_done = scan_h_done & scan_v_done;

assign ram_rd_addr_o = ram_rd_addr;

assign hub75e_r0_o = hub75e_r0;
assign hub75e_g0_o = hub75e_g0;
assign hub75e_b0_o = hub75e_b0;
assign hub75e_r1_o = hub75e_r1;
assign hub75e_g1_o = hub75e_g1;
assign hub75e_b1_o = hub75e_b1;
assign hub75e_oe_o = hub75e_oe;
assign hub75e_lat_o = hub75e_lat;
assign hub75e_clk_o = clk_cnt[1];
assign hub75e_addr_o = hub75e_addr;

edge2en hub75e_s_en(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .data_i(hub75e_clk_o),
    .pos_edge_o(hub75e_clk_p),
    .neg_edge_o(hub75e_clk_n)
);

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        clk_en <= 1'b1;
        clk_cnt <= 2'b00;

        hub75e_r0 <= 1'b0;
        hub75e_g0 <= 1'b0;
        hub75e_b0 <= 1'b0;
        hub75e_r1 <= 1'b0;
        hub75e_g1 <= 1'b0;
        hub75e_b1 <= 1'b0;

        byte_cnt <= 8'h00;

        hub75e_oe <= 1'b0;
        hub75e_lat <= 1'b0;
        hub75e_addr <= 5'h00;
    end else begin
        clk_cnt <= clk_en ? clk_cnt + 1'b1 : 2'b00;

        hub75e_r0 <= (byte_cnt < 8'd8) ? 1'b0 : 1'b0;
        hub75e_g0 <= (byte_cnt < 8'd8) ? 1'b1 : 1'b0;
        hub75e_b0 <= (byte_cnt < 8'd8) ? 1'b0 : 1'b0;
        hub75e_r1 <= (byte_cnt < 8'd8) ? 1'b1 : 1'b0;
        hub75e_g1 <= (byte_cnt < 8'd8) ? 1'b0 : 1'b0;
        hub75e_b1 <= (byte_cnt < 8'd8) ? 1'b1 : 1'b0;

        byte_cnt <= hub75e_clk_p ? ((byte_cnt == 8'd64) ? 8'h00 : byte_cnt + 1'b1) : byte_cnt;

        // hub75e_oe <= hub75e_lat ? 1'b1 : 1'b0;
        hub75e_lat <= (byte_cnt == 8'd63) ? 1'b1 : 1'b0;
        hub75e_addr <= hub75e_clk_p & (byte_cnt == 8'd63) ? hub75e_addr + 1'b1 : hub75e_addr;
    end
end

endmodule
