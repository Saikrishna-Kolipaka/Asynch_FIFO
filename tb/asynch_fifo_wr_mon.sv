class asynch_fifo_mon extends uvm_monitor;

 `uvm_component_utils(asynch_fifo_mon)

 function new (string name = "asynch_fifo_mon", uvm_component parent = null);
	 super.new(name, parent);
 endfunction

 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 endfunction

// task run_phase();

 //endtask


endclass
