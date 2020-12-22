onerror {quit -f}
vlib work
vlog -work work RISC_CPU.vo
vlog -work work RISC_CPU.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.RISC_CPU_TPO_vlg_vec_tst
vcd file -direction RISC_CPU.msim.vcd
vcd add -internal RISC_CPU_TPO_vlg_vec_tst/*
vcd add -internal RISC_CPU_TPO_vlg_vec_tst/i1/*
add wave /*
run -all
