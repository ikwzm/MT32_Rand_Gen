proc implementation_sample_project { project_name report_name } {
    set project_directory       [file dirname [info script]]
    open_project [file join $project_directory $project_name]
    launch_runs synth_1
    wait_on_run synth_1
    launch_runs impl_1
    wait_on_run impl_1
    open_run    impl_1
    report_utilization -file [file join $project_directory $report_name] -cells [get_cells U]
    report_timing      -file [file join $project_directory $report_name] -append
    close_project
}

implementation_sample_project "mt32_rand_gen_artix7_l1_ramb.xpr"  "mt32_rand_gen_artix7_l1_ramb.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l1_lut.xpr"   "mt32_rand_gen_artix7_l1_lut.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l2_ramb.xpr"  "mt32_rand_gen_artix7_l2_ramb.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l2_lut.xpr"   "mt32_rand_gen_artix7_l2_lut.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l4_ramb.xpr"  "mt32_rand_gen_artix7_l4_ramb.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l4_lut.xpr"   "mt32_rand_gen_artix7_l4_lut.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l8_ramb.xpr"  "mt32_rand_gen_artix7_l8_ramb.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l8_lut.xpr"   "mt32_rand_gen_artix7_l8_lut.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l16_ramb.xpr" "mt32_rand_gen_artix7_l16_ramb.rpt"
implementation_sample_project "mt32_rand_gen_artix7_l16_lut.xpr" " mt32_rand_gen_artix7_l16_lut.rpt"
