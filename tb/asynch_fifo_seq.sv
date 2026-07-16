class asynch_fifo_seq extends uvm_sequence#(asynch_fifo_seq_item);

 `uvm_object_utils(asynch_fifo_seq);

 function new (string name = "asynch_fifo_seq");
	 super.new(name);
 endfunction
 
 task body();
   
   asynch_fifo_seq_item tx;
   
   repeat(10)
     begin
       tx = asynch_fifo_seq_item::type_id::create("tx");
       
       start_item(tx);
       tx.wr_en = 1;
       tx.rd_en = 0;
       tx.wr_data = 32'h11;
       finish_item(tx);
     end
 endtask

endclass
