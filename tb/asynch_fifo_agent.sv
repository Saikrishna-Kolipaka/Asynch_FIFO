class asynch_fifo_agent extends uvm_agent;

 `uvm_component_utils(asynch_fifo_agent)

 asynch_fifo_drv drv;
 asynch_fifo_seqr seqr;

 function new (string name = "asynch_fifo_agent", uvm_component parent = null);
	 super.new(name, parent);
 endfunction

 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 drv = asynch_fifo_drv::type_id::create("drv", this);
 seqr = asynch_fifo_seqr::type_id::create("seqr", this);
 endfunction

 function void connect_phase(uvm_phase phase);
	 super.connect_phase(phase);
	 drv.seq_item_port.connect(seqr.seq_item_export);
 endfunction


endclass
