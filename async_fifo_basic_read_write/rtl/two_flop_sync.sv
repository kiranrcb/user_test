/*
2FF synchronizer with DATA_WIDTH bit width
this DATA_WIDTH bit width depends on the depth of the fifo, it is the pointer value + 1 extra bit to avoid full and empty condition rollover
if fifo depth is 16, then we have 4bit+1bit = 5bit
*/

module two_flop_sync
#(
	parameter DATA_WIDTH = 4
)
(
	input logic clk,
	input logic rst,
	input logic [DATA_WIDTH-1:0] data_in,	//should we pass 4 or 5 directly?
	output logic [DATA_WIDTH-1:0] data_out
);
	
	logic [DATA_WIDTH-1:0] temp;
	
	always_ff @(posedge clk) begin
		if(rst) begin
		temp <= 0;
			data_out <= 'd0;
		end
		else begin
			temp     <= data_in;
			data_out <= temp;
		end
	end

endmodule