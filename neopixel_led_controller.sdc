derive_clock_uncertainty
derive_pll_clocks -create_base_clocks

set_false_path -from [get_ports {rst_n_i}]

set_false_path -from [get_ports {dc_i}]
set_false_path -from [get_ports {spi_sclk_i}]
set_false_path -from [get_ports {spi_mosi_i}]
set_false_path -from [get_ports {spi_cs_n_i}]

set_false_path -to [get_ports {spi_miso_o}]

# FPS Counter
set_false_path -to [get_ports {segment_led_1_o[*]}]
set_false_path -to [get_ports {segment_led_2_o[*]}]

set_false_path -to [get_ports {hub75e_r0_o}]
set_false_path -to [get_ports {hub75e_g0_o}]
set_false_path -to [get_ports {hub75e_b0_o}]
set_false_path -to [get_ports {hub75e_r1_o}]
set_false_path -to [get_ports {hub75e_g1_o}]
set_false_path -to [get_ports {hub75e_b1_o}]
set_false_path -to [get_ports {hub75e_oe_o}]
set_false_path -to [get_ports {hub75e_clk_o}]
set_false_path -to [get_ports {hub75e_lat_o}]
set_false_path -to [get_ports {hub75e_addr_o[*]}]
