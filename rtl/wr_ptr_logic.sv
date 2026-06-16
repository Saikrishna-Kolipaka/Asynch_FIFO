module wr_ptr_logic# (parameter A_WIDTH = 4);

(
   input 	wr_clk,
   input 	wr_rstn,
   input 	wr_en,
   input [A_WIDTH : 0] gray_rd_ptr_sync,

   output reg [A_WIDTH:0] gray_wr_ptr,
   output 	full,
   output [A_WIDTH-1 : 0] wr_addr
	);

   reg [A_WIDTH : 0] bin_wr_ptr; //current state registers
   
   wire [A_WIDTH : 0] bin_wr_ptr_next; //next state wires
   wire [A_WIDTH : 0] gray_wr_ptr_next;


   assign gray_wr_ptr_next = bin_wr_ptr_next ^(bin_wr_ptr_next >> 1); // gray to bin conversion


   always@(posedge wr_clk or negedge wr_rstn)
   begin
	if(!wr_rstn)
       	begin
	     bin_wr_ptr <= 0;
	     gray_wr_ptr <= 0;
	end
	else 
	begin
	 	if(wr_en && !full) bin_wr_ptr_next <= bin_wr_ptr + 1;
		else bin_wr_ptr_next <= bin_wr_ptr;
	     end
   end


  assign wr_addr = bin_wr_ptr[A_WIDTH -3 :0];
  assign full = (gray_wr_ptr_next == {~gray_rd_ptr_sync[A_WIDTH : A_WIDTH -1], gray_rd_ptr_sync[A_WIDTH -2 : 0]});

endmodule
