interface Asynch_intf;
  
	logic wr_clk;
	logic rd_clk;

	logic wr_rstn;
	logic rd_rstn;

	logic wr_en;
	logic rd_en;

  logic [D_WIDTH - 1: 0] wr_data;
  logic [D_WIDTH - 1: 0] rd_data;

	logic full;
	logic empty;

endinterface
