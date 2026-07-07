
module asynch_fifo_tb;

  parameter D_WIDTH = 8;
  parameter A_WIDTH = 4;
  parameter A_DEPTH = 16;

  
  logic wr_clk, rd_clk;
  logic wr_rstn, rd_rstn;

  logic wr_en, rd_en;

  logic [D_WIDTH-1:0] wr_data;
  logic [D_WIDTH-1:0] rd_data;

  logic full, empty;

  
  asynch_fifo #(
      .D_WIDTH(D_WIDTH),
            .A_DEPTH(A_DEPTH)
  ) dut (
      .wr_clk(wr_clk),
      .rd_clk(rd_clk),
    .wr_rstn(wr_rstn),
    .rd_rstn(rd_rstn),
      .wr_en(wr_en),
      .rd_en(rd_en),
      .wr_data(wr_data),
      .rd_data(rd_data),
      .full(full),
      .empty(empty)
  );

  initial begin
    wr_clk = 0;
    forever #5 wr_clk = ~wr_clk;
  end

 
  initial begin
    rd_clk = 0;
    forever #10 rd_clk = ~rd_clk;
  end

 
  initial begin
    $monitor("TIME=%0t WR_EN=%b RD_EN=%b WR_DATA=%0d RD_DATA=%0d FULL=%b EMPTY=%b",
             $time, wr_en, rd_en, wr_data, rd_data, full, empty);
  end
  
   task reset_fifo();
    begin
      wr_rstn = 1'b1;
      rd_rstn = 1'b1;
      wr_en  = 0;
      rd_en  = 0;

      repeat(3) @(posedge wr_clk);
      repeat(3) @(posedge rd_clk);

      wr_rstn = 1'b0;
      rd_rstn = 1'b0;
    end
  endtask
  
   task fifo_write(input [D_WIDTH-1:0] data);
    begin
      @(posedge wr_clk);
      if(!full) begin
        wr_en   = 1'b1;
        wr_data = data;
      end

      @(posedge wr_clk);
      wr_en = 0;
    end
  endtask
  
   task fifo_read();
    begin
      @(posedge rd_clk);
      if(!empty)
        rd_en = 1'b1;

      @(posedge rd_clk);
      rd_en = 0;
    end
  endtask
  
  initial begin

    reset_fifo();

    // TESTCASE 1 : Single Write
    fifo_write(8'h11);

    // TESTCASE 2 : Single Read
    fifo_read();

    // TESTCASE 3 : Multiple Writes
    fifo_write(8'h22);
    fifo_write(8'h33);
    fifo_write(8'h44);

    // TESTCASE 4 : Multiple Reads
    fifo_read();
    fifo_read();
    fifo_read();

    #100;
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule