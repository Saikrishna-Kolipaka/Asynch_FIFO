class asynch_fifo_sco extends uvm_scoreboard;

 `uvm_component_utils(asynch_fifo_sco)

 function new (string name = "asynch_fifo_sco", uvm_component parent = null);
	 super.new(name, parent);
 endfunction

 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 endfunction

 //task run_phase();

// endtask


endclass
