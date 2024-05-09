/*
Gray to Binary converter DATA_WIDTH bit
not used in async fifo
*/

module gray_to_bin
#(
	parameter DATA_WIDTH = 4
)
(
	input [DATA_WIDTH-1:0] gray_in,
	output [DATA_WIDTH-1:0] bin_out
);

	always_comb begin
		for(int i=DATA_WIDTH-2; i>=0; i--)
			assign bin_out[i] = bin_out[i+1] ^ gray_in[i];	//can we directly assign or we have to write assign like this?
	end
	
	assign bin_out[DATA_WIDTH-1] = gray_in[DATA_WIDTH-1];	//directly assigning MSB bit

endmodule