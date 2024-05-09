/*
ASYNC FIFO - top module
*/

module async_fifo
#(
	parameter DEPTH = 16,
			  DATA_WIDTH = 8
)
(
	input wr_clk,
	input rd_clk,
	input rst,
	
	input [DATA_WIDTH-1:0] wr_data,
	
	input wr_en,
	input rd_en,
	
	output full,
	output empty,
	//output almost_full,
	//output almost_empty,
	
	output [DATA_WIDTH-1:0] rd_data
);
	
	/*****************************************************************
		WRITE OPERATION
		first we need to convert wr_ptr from binary to gray
		then we convert rd_ptr from binary to gray
		then we pass rd_ptr through 2ff sync 
		and then compare with gray value
	*****************************************************************/
	
	//pointer declaration
	localparam ADDR_WIDTH = ($clog2(DEPTH)+1);
	wire [ADDR_WIDTH-1:0] wr_ptr_bin;
	wire [ADDR_WIDTH-1:0] wr_ptr_gray;
	wire [ADDR_WIDTH-1:0] rd_ptr_bin;
	wire [ADDR_WIDTH-1:0] rd_ptr_gray;	
	
	//synchronizer output declaration
	wire [ADDR_WIDTH-1:0] 	rd_ptr_gray_sync_out;
	wire [ADDR_WIDTH-1:0] 	wr_ptr_gray_sync_out;


	//wr_ptr binary to gray 
	bin_to_gray #(.DATA_WIDTH(ADDR_WIDTH))
				wr_ptr_bin_to_gray 
				(
				.bin_in    (wr_ptr_bin)  ,
				.gray_out  (wr_ptr_gray)
				);
	
	//rd_ptr binary to gray 
	bin_to_gray #(.DATA_WIDTH(ADDR_WIDTH))
				rd_ptr_bin_to_gray 
				(
				.bin_in    (rd_ptr_bin)  ,
				.gray_out  (rd_ptr_gray)
				);	
	
	// 2ff synchronizer for full condition (rd_ptr should be passed)
	two_flop_sync #(.DATA_WIDTH(ADDR_WIDTH))
					two_flop_sync_full 
					(
					  .clk       (rd_clk     ),
					  .rst       (rst     ),
					  .data_in   (rd_ptr_gray ),
					  .data_out  (rd_ptr_gray_sync_out)									  
					 );	
	
	
	//full logic instantiation
	full_logic #(.DATA_WIDTH(ADDR_WIDTH))
					full_logic_inst 
					(
					.wr_gray_in     (wr_ptr_gray),
					.rd_gray_out    (rd_ptr_gray_sync_out),
					.full           (full)
					);
	

	/*****************************************************************
		READ OPERATION
	*****************************************************************/
	
	// 2ff synchronizer for empty condition (wr_ptr should be passed)
	two_flop_sync #(.DATA_WIDTH(ADDR_WIDTH))
					two_flop_sync_empty 
					(
					  .clk       (wr_clk     ),
					  .rst       (rst     ),
					  .data_in   (wr_ptr_gray ),
					  .data_out  (wr_ptr_gray_sync_out)									  
					 );	
		
	
	//empty logic instantiation
	empty_logic #(.DATA_WIDTH(ADDR_WIDTH))
				empty_logic_inst
				(
				.rd_gray_in  (rd_ptr_gray),
				.wr_gray_out (wr_ptr_gray_sync_out),
				.empty       (empty)
				);
				
	/*****************************************************************
		Memory instantiation and connection to pointers
	*****************************************************************/				

	memory #(
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH)
			) 
			memory_inst 
			(
			.wr_clk	  (wr_clk),
	        .rd_clk   (rd_clk),
	        .rst      (rst),
	        .rd_en    (rd_en),
	        .wr_en    (wr_en),
	        .wr_data  (wr_data),
	        .rd_data  (rd_data),
			.wr_ptr  (wr_ptr_bin),
			.rd_ptr  (rd_ptr_bin)
	);

endmodule