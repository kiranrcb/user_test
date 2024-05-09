/*
ASYNC FIFO TB	

Testcases
1. normal read and write
2. full condition
3. empty condition
*/
`timescale 1ns/1ps

module tb;
	parameter DEPTH = 4,
			  DATA_WIDTH = 8;
			  
	reg wr_clk;
	reg rd_clk;
	reg rst;
	reg [DATA_WIDTH-1:0] wr_data;
	reg wr_en;
	reg rd_en;
	
	wire full;
	wire empty;
	wire [DATA_WIDTH-1:0] rd_data;


	async_fifo #(
			  .DEPTH (DEPTH),
			  .DATA_WIDTH (DATA_WIDTH) 
			)
			dut
			(
				.wr_clk		(wr_clk), 
				.rd_clk     (rd_clk),
				.rst        (rst),
				.wr_data    (wr_data),
				.wr_en      (wr_en),
				.rd_en      (rd_en),
				.full       (full),
				.empty      (empty),
				.rd_data    (rd_data)
			);
			
	initial begin
		rst = 1'b1;
		wr_en = 1'b0;
		rd_en = 1'b0;
		wr_data = 'd0;	
		wr_clk = 0;
		rd_clk = 0;	
	#15 rst =0;
	//#20	wr_data_task();
	//#20 rd_data_task();
	#20 basic_read_write_task;
	#20 $finish;
	end	
	
    always #5 wr_clk = ~wr_clk;

	initial begin
		 forever #5 rd_clk = ~rd_clk;
	end
	
	task basic_read_write_task;
	begin
	   wr_data_task;
	   #20;
	   rd_data_task;
	end
	endtask
	
	task wr_data_task;
	begin
		@ ( posedge wr_clk)
			begin
				wr_en = 1'b1;
		        wr_data = 'd1;	
			end
			
		@(posedge wr_clk)
			begin
				wr_en = 1'b1;
		        wr_data = 'd2;	
			end	
			
		@(posedge wr_clk)
			begin
				wr_en = 1'b1;
		        wr_data = 'd3;	
			end	
			
			@(posedge wr_clk)
			begin
				wr_en = 1'b1;
		        wr_data = 'd4;	
			end		

			
			@(posedge wr_clk)
			begin
				wr_en = 1'b0;
		        wr_data = 'd5;		
			end	
			
	end		
	endtask
	
	task rd_data_task;
	begin
		@(posedge rd_clk)
			begin
				rd_en = 1'b1;
		        //rd_en = 1'b0;
			end
	
		@(posedge rd_clk)
			begin
				rd_en = 1'b1;
		        //rd_en = 1'b0;
			end
			
			@(posedge rd_clk)
			begin
				rd_en = 1'b1;
		        //rd_en = 1'b0;
		        end

			@(posedge rd_clk)
			begin
				rd_en = 1'b1;
		        //rd_en = 1'b0;
		        end	
			
			@(posedge rd_clk)
			begin
				//rd_en = 1'b1;
		        rd_en = 1'b0;
		        end		        
		       	       
	end
	endtask

endmodule