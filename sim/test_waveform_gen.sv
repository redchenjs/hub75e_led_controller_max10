/*
 * test_waveform_gen.sv
 *
 *  Created on: 2020-07-08 20:03
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_waveform_gen;

logic clk_i;
logic rst_n_i;

logic hub75e_r0_o;
logic hub75e_g0_o;
logic hub75e_b0_o;
logic hub75e_r1_o;
logic hub75e_g1_o;
logic hub75e_b1_o;
logic hub75e_oe_o;
logic hub75e_lat_o;
logic [4:0] hub75e_addr_o;

waveform_gen waveform_gen(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .hub75e_r0_o(hub75e_r0_o),
    .hub75e_g0_o(hub75e_g0_o),
    .hub75e_b0_o(hub75e_b0_o),
    .hub75e_r1_o(hub75e_r1_o),
    .hub75e_g1_o(hub75e_g1_o),
    .hub75e_b1_o(hub75e_b1_o),

    .hub75e_oe_o(hub75e_oe_o),
    .hub75e_clk_o(hub75e_clk_o),
    .hub75e_lat_o(hub75e_lat_o),
    .hub75e_addr_o(hub75e_addr_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    // bit_vld_i  <= 1'b0;
    // bit_data_i <= 1'b0;

    // reg_t0h_time_i <= 8'h00;
    // reg_t0s_time_i <= 9'h001;
    // reg_t1h_time_i <= 8'h01;
    // reg_t1s_time_i <= 9'h001;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    // #11 bit_vld_i  <= 1'b1;
    //     bit_data_i <= 1'b0;
    // #5  bit_vld_i  <= 1'b0;

    // for (integer i = 0; i < 10; i++) begin
    //     #25 bit_vld_i  <= 1'b1;
    //         bit_data_i <= i % 2;
    //     #5  bit_vld_i  <= 1'b0;
    // end

    #7500 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
