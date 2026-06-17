`include "synchronizer.sv"
`include "wr_ptr_logic.sv"
`include "rd_ptr_logic.sv"
`include "Asynch_fifo_mem.sv"


module asynch_fifo #(parameter A_DEPTH = 16, D_WIDTH = 32)

( 
	input wr_clk,rd_clk,
	input wr_rstn,rd_rstn,
	input wr_en, rd_en,
	input [D_WIDTH-1 :0] wr_data,

	output [D_WIDTH-1 : 0] rd_data,
	output full,empty
);
	parameter A_WIDTH = $clog2(A_DEPTH);

	wire [A_WIDTH-1:0] wr_addr;
	wire [A_WIDTH-1:0] rd_addr;

	wire [A_WIDTH:0] g_wr_ptr_sync, g_rd_ptr_sync;
	wire [A_WIDTH:0] g_wptr, g_rdptr;

	asynch_fifo_mem #(.D_WIDTH(D_WIDTH), .A_DEPTH(A_DEPTH)) asynch_mem (.wr_clk(wr_clk), .rd_clk(rd_clk), .wr_rstn(wr_rstn), .wr_en(wr_en), .wr_addr(wr_addr), .rd_addr(rd_addr), .wr_data(wr_data), .rd_data(rd_data));
	
	wr_ptr_logic #(.A_WIDTH(A_WIDTH)) wptr_uut(.wr_clk(wr_clk), .wr_rstn(wr_rstn), .wr_en(wr_en), .g_rd_ptr_sync(g_rd_ptr_sync), .g_wptr(g_wptr), .full(full), .wr_addr(wr_addr));	

	rd_ptr_logic #(.A_WIDTH(A_WIDTH)) rdptr_uut(.rd_clk(rd_clk), .rd_rstn(rd_rstn), .rd_en(rd_en), .g_wr_ptr_sync(g_wr_ptr_sync), .g_rdptr(g_rdptr), .empty(empty), .rd_addr(rd_addr));	

	synchronizer #(.A_WIDTH(A_WIDTH)) sync_w2r (.clk(rd_clk), .rstn(rd_rstn), .data_in(g_wptr), .data_out(g_wr_ptr_sync));

	synchronizer #(.A_WIDTH(A_WIDTH)) sync_r2w (.clk(wr_clk), .rstn(wr_rstn), .data_in(g_rdptr), .data_out(g_rd_ptr_sync));

endmodule


