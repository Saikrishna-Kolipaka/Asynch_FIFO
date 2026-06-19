vlib work
vlog top.v 
vsim work.top_tb +UVM_TESTNAME=asynch_fifo_test +UVM_VERBOSITY=UVM_HIGH -l run.log
run -all 
