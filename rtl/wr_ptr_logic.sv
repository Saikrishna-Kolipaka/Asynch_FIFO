module wr_ptr_logic# (parameter A_WIDTH = 4)

(
   input 	wr_clk,
   input 	wr_rstn,
   input 	wr_en,
   input    [A_WIDTH : 0] g_rd_ptr_sync,

   output   reg [A_WIDTH:0] g_wptr, //read synchronzer
   output 	full,
   output [A_WIDTH-1 : 0] wr_addr

);
  
   wire [A_WIDTH : 0] b_wptr_next; //
   wire [A_WIDTH : 0] g_wptr_next; //
 

   wire [A_WIDTH : 0] b_wptr_inc; //
   wire [A_WIDTH : 0] g_wptr_inc; //

   reg [A_WIDTH : 0] b_wptr;

   wire wfull;

   //prdict incremented pointer
   assign b_wptr_inc = b_wptr + 1'b1;
   assign g_wptr_inc = b_wptr_inc ^ (b_wptr_inc >> 1);


   assign b_wptr_next = b_wptr +(wr_en & !wfull);
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
   
  assign wr_addr = b_wptr[A_WIDTH -1 :0];

  assign wfull = (g_wptr_inc == {~g_rd_ptr_sync[A_WIDTH : A_WIDTH -1], g_rd_ptr_sync[A_WIDTH -2 : 0]});

  assign full = wfull;

endmodule

/*
depth = 0-6

g_wptr // read domain
b_wptr = 5 // memory  // 6 

2) b_wptr = 6 

b_wptr_next = 6

g_wptr_next = 6 (gray)

full  = current status

wfull = "if I write now, will I become full?"

b_wptr_inc    → predicted incremented pointer

g_wptr_inc    → gray of predicted pointer

wfull         → will fifo become full after increment?

b_wptr_next   → actual next pointer
g_wptr_next   → actual next gray pointer
*/



