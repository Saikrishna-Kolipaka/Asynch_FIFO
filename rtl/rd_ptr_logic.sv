module rd_ptr_logic# (parameter A_WIDTH = 4) //
(
   input rd_clk,
   input rd_en,
   input rd_rstn,
   input [A_WIDTH : 0] g_wr_ptr_sync,

   output reg empty,
   output [A_WIDTH-1 : 0] rd_addr, 
   output reg [A_WIDTH : 0] g_rdptr
	);
       
    reg [A_WIDTH : 0] b_rdptr;
    
	wire rempty;

    wire [A_WIDTH : 0] b_rdptr_next; 
    wire [A_WIDTH : 0] g_rdptr_next; 
 
    assign b_rdptr_next = b_rdptr + (!rempty & rd_en);
    assign g_rdptr_next = b_rdptr_next ^(b_rdptr_next >> 1);

    always@(posedge rd_clk or negedge rd_rstn) 
    begin
    if(!rd_rstn)
    begin
	b_rdptr <= 0;
	g_rdptr <= 0;
    end
    else
    begin
	b_rdptr <= b_rdptr_next;
	g_rdptr <= g_rdptr_next;
    end
    end

   always@(posedge rd_clk or negedge rd_rstn) begin
    if(!wrst_n) empty <= 1'b1;;
    else        empty <= rempty;
   end


    assign rd_addr = b_rdptr[A_WIDTH - 1 : 0];

  assign rempty = (g_rdptr_next == g_wr_ptr_sync);

endmodule
