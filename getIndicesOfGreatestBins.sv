module getIndicesOfGreatestBins #(parameter SAMPLES=32, WIDTH=32)
(
	input clk,
	input [WIDTH-1:0] frequency_bins [SAMPLES-1:0],
	output reg [$clog2(SAMPLES)-1:0] index_holder,
	output reg done,
	input reset
);

	logic [$clog2(SAMPLES)-1:0] indexTracker = 0;

	always @(posedge clk)
	begin
		if (reset)
		begin
			indexTracker <= 0;
			done <= 0;
		end
		
		else
		begin
			if (indexTracker == 0)
			begin
				index_holder <= 0;
				done <= 0;
			end
			
			else
				if (frequency_bins[index_holder] < frequency_bins[indexTracker])
				begin
					index_holder <= indexTracker;
				end
				
				if (indexTracker < SAMPLES-1)
				begin
					indexTracker <= indexTracker+1;
					done <= 0;
				end
				else
					done <= 1;
		end
	end

endmodule