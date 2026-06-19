`include "uvm_macros.svh"
import uvm_pkg::*;

`include "asynch_fifo_tx.sv"
`include "asynch_fifo_seq.sv"
`include "asynch_fifo_seqr.sv"
`include "asynch_fifo_drv.sv"
`include "asynch_fifo_mon.sv"
`include "asynch_fifo_sco.sv"
`include "asynch_fifo_agent.sv"
`include "asynch_fifo_env.sv"
`include "asynch_fifo_test.sv"


module top_tb;
  initial begin
	  run_test("asynch_fifo_test");
  end
endmodule
