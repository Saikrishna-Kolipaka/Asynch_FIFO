class asynch_fifo_drv extends uvm_driver #(asynch_fifo_seq_item);

 `uvm_component_utils(asynch_fifo_drv)

 function new (string name = "asynch_fifo_drv", uvm_component parent = null);
	 super.new(name, parent);
 endfunction

 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 endfunction

// task run_phase();

// endtask


endclass
