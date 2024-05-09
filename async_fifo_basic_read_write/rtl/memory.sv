/*
Memory with variable depth N
*/

module memory 
#(
	parameter DEPTH = 16,
			  DATA_WIDTH = 8,
			  ADDR_WIDTH = ($clog2(DEPTH)+1)			  
)
(
	input wr_clk,
	input rd_clk,
	input rst,
	input rd_en,
	input wr_en,

	input [DATA_WIDTH-1:0] wr_data,
	output reg [DATA_WIDTH-1:0] rd_data,
	
	output [ADDR_WIDTH-1:0] wr_ptr,
	output [ADDR_WIDTH-1:0] rd_ptr

);

	reg [ADDR_WIDTH-1:0] wr_addr;
	reg [ADDR_WIDTH-1:0] rd_addr;

	reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];
	integer i;
	
	//write operation
	always @(posedge wr_clk) begin
		if(rst) begin
			for(i=0; i<=DEPTH-1; i++) begin
				mem[i] <= 'b0;
			end
			wr_addr <= 'd0;
		end
		else if(wr_en) begin
			mem[wr_addr] <= wr_data;
			//write pointer increment
			wr_addr <= wr_addr + 1'b1;
		end
	end
	
	//read operation
	always @(posedge rd_clk) begin
		if(rst) begin 
		    rd_addr <= 'd0;
			rd_data <= 'b0;
		
		end
		else if(rd_en) begin
			rd_data <= mem[rd_addr];
			//read pointer increment
			rd_addr <= rd_addr + 1'b1;
		end
		
	end
	
	assign wr_ptr = wr_addr;
	assign rd_ptr = rd_addr;

endmodule