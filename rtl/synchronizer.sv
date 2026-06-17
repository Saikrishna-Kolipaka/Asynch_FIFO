module synchronizer# (parameter A_WIDTH = 4)

(
	input clk,
	input rstn,
	input [A_WIDTH : 0] data_in,


	output reg [A_WIDTH : 0] data_out
); 

        reg [A_WIDTH : 0] data_1;

  always@(posedge clk or negedge rstn) 
  begin
      if(!rstn)
      begin
	 data_1 <= 0;
	 data_out <= 0;
      end
      else
      begin
	 data_1 <= data_in;
         data_out <= data_1;
      end
  end

endmodule
