/*
Empty logic
*/

module empty_logic 
#(
	parameter DATA_WIDTH = 8
)
(
	input [DATA_WIDTH-1:0] rd_gray_in,	//it is at the read domain
	input [DATA_WIDTH-1:0] wr_gray_out,	//it is from write domain, should be passed through 2ff sync to this module
	
	output empty 
	//output almost_empty
);

	//empty condition - calculated based on write_domain pointer and read_domain pointer
	assign empty = (rd_gray_in == wr_gray_out) ? 1'b1 : 1'b0;


endmodule