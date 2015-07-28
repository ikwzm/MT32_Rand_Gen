create_clock -period 5.000 -name CLK -waveform {0.000 2.500} [get_ports CLK]

set_input_delay -clock [get_clocks *] 2.000 [get_ports {RND_RUN}]
set_input_delay -clock [get_clocks *] 2.000 [get_ports {TBL_INIT}]
set_input_delay -clock [get_clocks *] 2.000 [get_ports {TBL_RPTR[*]}]
set_input_delay -clock [get_clocks *] 2.000 [get_ports {TBL_WPTR[*]}]
set_input_delay -clock [get_clocks *] 2.000 [get_ports {TBL_WDATA[*]}]
set_input_delay -clock [get_clocks *] 2.000 [get_ports {TBL_WE[*]}]

