/*
Full logic
*/

module full_logic 
#(
	parameter DATA_WIDTH = 8
)
(
	input [DATA_WIDTH-1:0] wr_gray_in,	//it is at the write domain
	input [DATA_WIDTH-1:0] rd_gray_out,	//it is from read domain, should be passed through 2ff sync to this module
	
	output full 
	//output almost_full 
);

	//full condition - calculated based on write_domain pointer and read_domain pointer
	assign full = (
					( wr_gray_in[DATA_WIDTH-1] != rd_gray_out[DATA_WIDTH-1]) && 
					( wr_gray_in[DATA_WIDTH-2] != rd_gray_out[DATA_WIDTH-2]) &&
					( wr_gray_in[DATA_WIDTH-3:0] == rd_gray_out[DATA_WIDTH-3:0])
				  ) ? 1'b1 : 1'b0;


endmodule