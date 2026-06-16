module wr_ptr_logic# (parameter A_WIDTH = 4)

(
   input 	wr_clk,
   input 	wr_rstn,
   input 	wr_en,
   input    [A_WIDTH : 0] gray_rd_ptr_sync,

   output   reg [A_WIDTH:0] g_wptr, //read synchronzer
   output 	full,
   output [A_WIDTH-1 : 0] wr_addr

);
  
   wire [A_WIDTH : 0] b_wptr_next; //
   wire [A_WIDTH : 0] g_wptr_next; //
     
   reg [A_WIDTH : 0] b_wptr;

   assign b_wptr_next = b_wptr +(wr_en & !full);
   assign g_wptr_next = b_wptr_next^(b_wptr_next >> 1);

   always@(posedge wr_clk or negedge wr_rstn) 
   begin
   	if(!wr_rstn) 
		begin
			b_wptr <= 0;
			g_wptr <= 0;
		end
	else 
	begin
		b_wptr <= b_wptr_next;
		g_wptr <= g_wptr_next;
	end
   end
   
 /*  always@(posedge wr_clk or negedge wr_rstn_
   begin
    if(
   end
*/
  assign wr_addr = b_wptr[A_WIDTH -1 :0];

  assign full = (g_wptr_next == {~gray_rd_ptr_sync[A_WIDTH : A_WIDTH -1], gray_rd_ptr_sync[A_WIDTH -2 : 0]});

endmodule

/*
depth = 0-6

g_wptr // read domain
b_wptr = 5 // memory  // 6 

2) b_wptr = 6 

b_wptr_next = 6

g_wptr_next = 6 (gray)
*/



