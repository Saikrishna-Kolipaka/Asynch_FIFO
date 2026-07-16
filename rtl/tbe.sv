module asynch_fifo_tb;

    parameter D_WIDTH = 32;
    parameter A_DEPTH = 8;
    parameter A_WIDTH = $clog2(A_DEPTH);

    logic wr_clk, rd_clk;
    logic wr_rstn, rd_rstn;
    logic wr_en, rd_en;

    logic [D_WIDTH-1:0] wr_data;
    logic [D_WIDTH-1:0] rd_data;

    logic full, empty;

    // DUT
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

    //---------------------------------------------------------
    // Clock Generation
    //---------------------------------------------------------
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;   //100MHz
    end

    initial begin
        rd_clk = 0;
        forever #10 rd_clk = ~rd_clk;  //50MHz
    end

    //---------------------------------------------------------
    // Scoreboard
    //---------------------------------------------------------
    logic [D_WIDTH-1:0] exp_queue[$];

    //---------------------------------------------------------
    // Monitor
    //---------------------------------------------------------
    initial begin
        $monitor(
        "T=%0t WR_EN=%0b RD_EN=%0b WR_DATA=%0h RD_DATA=%0h FULL=%0b EMPTY=%0b",
        $time,wr_en,rd_en,wr_data,rd_data,full,empty);
    end

    //---------------------------------------------------------
    // Reset
    //---------------------------------------------------------
    task reset_fifo();
    begin
        wr_rstn = 0;
        rd_rstn = 0;
        wr_en   = 0;
        rd_en   = 0;
        wr_data = 0;

        repeat(4) @(posedge wr_clk);
        repeat(4) @(posedge rd_clk);

        wr_rstn = 1;
        rd_rstn = 1;

        $display("\nRESET DONE\n");
    end
    endtask

    //---------------------------------------------------------
    // WRITE TASK
    //---------------------------------------------------------
    task fifo_write(input [D_WIDTH-1:0] data);
    begin
        @(posedge wr_clk);

        if(!full) begin
            wr_en   <= 1;
            wr_data <= data;

            exp_queue.push_back(data);

            $display("[%0t] WRITE : %0h", $time, data);
        end
        else begin
            wr_en <= 0;
            $display("[%0t] WRITE BLOCKED (FULL): %0h",
                     $time,data);
        end

        @(posedge wr_clk);
        wr_en <= 0;
    end
    endtask

    //---------------------------------------------------------
    // READ TASK
    //---------------------------------------------------------
    task fifo_read();
        logic [D_WIDTH-1:0] expected;
    begin

        @(posedge rd_clk);

        if(!empty) begin
            rd_en <= 1;
        end
        else begin
            rd_en <= 0;
            $display("[%0t] READ BLOCKED (EMPTY)",$time);
        end

        @(posedge rd_clk);
        rd_en <= 0;

        if(exp_queue.size()!=0) begin
            expected = exp_queue.pop_front();

            if(rd_data == expected)
                $display("[%0t] READ PASS exp=%0h got=%0h",
                         $time,expected,rd_data);
            else
                $error("[%0t] READ FAIL exp=%0h got=%0h",
                        $time,expected,rd_data);
        end
    end
    endtask

    //---------------------------------------------------------
    // TESTS
    //---------------------------------------------------------
    initial begin

        reset_fifo();

        //-----------------------------------------------------
        // TC1 : Reset Test
        //-----------------------------------------------------
        assert(empty==1 && full==0)
            else $error("RESET TEST FAILED");

        //-----------------------------------------------------
        // TC2 : Single Write
        //-----------------------------------------------------
        fifo_write(32'h11);

        //-----------------------------------------------------
        // TC3 : Single Read
        //-----------------------------------------------------
        fifo_read();

        //-----------------------------------------------------
        // TC4 : Multiple Writes
        //-----------------------------------------------------
        fifo_write(32'h22);
        fifo_write(32'h33);
        fifo_write(32'h44);
        fifo_write(32'h55);
        fifo_write(32'h66);
        fifo_write(32'h77);
        fifo_write(32'h88);

        //-----------------------------------------------------
        // TC5 : Full Test
        //-----------------------------------------------------
        wait(full==1);
        $display("\nFULL ASSERTED\n");

        //-----------------------------------------------------
        // TC6 : Overflow Test
        //-----------------------------------------------------
        fifo_write(32'h99);
        fifo_write(32'hAA);

        //-----------------------------------------------------
        // TC7 : Multiple Reads
        //-----------------------------------------------------
        repeat(A_DEPTH)
            fifo_read();

        //-----------------------------------------------------
        // TC8 : Empty Test
        //-----------------------------------------------------
        wait(empty==1);
        $display("\nEMPTY ASSERTED\n");

        //-----------------------------------------------------
        // TC9 : Underflow Test
        //-----------------------------------------------------
        fifo_read();

        //-----------------------------------------------------
        // TC10 : Simultaneous Read and Write
        //-----------------------------------------------------
        fifo_write(32'h1111);

        fork
            fifo_write(32'h2222);
            fifo_read();
        join

        //-----------------------------------------------------
        // TC11 : Wraparound Test
        //-----------------------------------------------------
        repeat(20)
            fifo_write($random);

        repeat(20)
            fifo_read();

        //-----------------------------------------------------
        // TC12 : Random Traffic
        //-----------------------------------------------------
        repeat(50)
        begin
            case($urandom_range(0,2))

                0:
                    fifo_write($random);

                1:
                    fifo_read();

                2:
                begin
                    fork
                        fifo_write($random);
                        fifo_read();
                    join
                end
            endcase
        end

        #200;

        $display("\n================================");
        $display(" ALL TESTCASES COMPLETED ");
        $display("================================\n");

        $finish;
    end

    //---------------------------------------------------------
    // Dump
    //---------------------------------------------------------
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,asynch_fifo_tb);
    end

endmodule
