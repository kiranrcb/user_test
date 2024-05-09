/*
Binary to Gray converter DATA_WIDTH bit
*/

module bin_to_gray
#(
	parameter DATA_WIDTH = 4
)
(
	input [DATA_WIDTH-1:0]  bin_in,
	output [DATA_WIDTH-1:0] gray_out
);

    reg [DATA_WIDTH-1:0] gray_out_temp;
    
	always_comb begin
		for(int i=DATA_WIDTH-2; i>=0; i--)
			gray_out_temp[i] = bin_in[i+1] ^ bin_in[i];	//can we directly assign or we have to write assign like this?
	end
	
	always_comb
	 gray_out_temp[DATA_WIDTH-1] = bin_in[DATA_WIDTH-1];	//directly assigning MSB bit
	
	assign gray_out = gray_out_temp;

endmodule