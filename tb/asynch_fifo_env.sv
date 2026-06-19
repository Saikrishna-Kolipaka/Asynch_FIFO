class asynch_fifo_env extends uvm_environment;

 `uvm_component_utils(asynch_fifo_env)

  asynch_fifo_agent agnt;

 function new (string name = "asynch_fifo_env", uvm_component parent = null);
	 super.new(name, parent);
 endfunction

 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 agnt = asynch_fifo_agent::type_id::create("agnt", this);
 endfunction

endclass
