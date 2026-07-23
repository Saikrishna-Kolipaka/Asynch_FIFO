class asynch_fifo_seq_item extends uvm_sequence_item;

 
  
  rand bit wr_en;
  rand bit rd_en;
  
  rand [D_WIDTH - 1 : 0] bit wr_data;
  [D_WIDTH - 1 : 0] bit rd_data;
  

  `uvm_object_utils_begin(asynch_fifo_seq_item)
  `uvm_field_int(wr_en, UVM_ALL_ON)
  `uvm_field_int(rd_en, UVM_ALL_ON)
  `uvm_field_int(wr_data, UVM_ALL_ON)
  `uvm_field_int(rd_data, UVM_ALL_ON)
  `uvm_object_utils_end
 function new (string name = "asynch_fifo_seq_tem");
	 super.new(name);
 endfunction


endclass

