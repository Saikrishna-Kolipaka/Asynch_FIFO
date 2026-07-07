interface Asynch_intf;
  
	logic wr_clk;
	logic rd_clk;

	logic wr_rstn;
	logic rd_rstn;

	logic wr_en;
	logic rd_en;

	logic [] wr_data;
	logic [] rd_data;

	logic full;
	logic empty;

endinterface
