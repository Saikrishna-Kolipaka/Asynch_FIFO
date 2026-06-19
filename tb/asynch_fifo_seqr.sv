class asynch_fifo_seqr extends uvm_sequencer #(asynch_fifo_seq_item);

 `uvm_component_utils(asynch_fifo_seqr)

 function new (string name = "asynch_fifo_seqr", uvm_component parent = null);
	 super.new(name, parent);
 endfunction


endclass

