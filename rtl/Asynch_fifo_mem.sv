module asynch_fifo_mem# (parameter D_WIDTH = 32, A_DEPTH = 16, A_WIDTH = $clog2(A_DEPTH));

(
  input 	wr_clk,
  input 	rd_clk,

  input 	wr_rstn,
  input 	wr_en,

  input         [A_WIDTH - 1:0]wr_addr,
  input         [A_WIDTH - 1:0]rd_addr,
  input         [D_WIDTH - 1:0]wr_data,
  output         [D_WIDTH - 1:0]rd_data
  
);
 
 reg [D_WIDTH - 1:0] mem [0:A_DEPTH - 1]; // [data_width] mem [addr_locations]

 always@(posedge wr_clk or negedge wr_rstn) begin
	if(wr_en && wr_rstn) mem[wr_addr] <= wr_data;
end
 	assign rd_data <= mem[rd_addr];

endmodule
