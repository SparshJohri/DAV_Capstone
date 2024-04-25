module getRightRect #(parameter SAMPLES=32)
(
	input [9:0] x_coordinate,
	input [9:0] rect_corners [SAMPLES:0],
	output [$clog2(SAMPLES):0] index
);
	
	always_comb
	begin
		if ((x_coordinate < rect_corners[0]) || (x_coordinate >= rect_corners[SAMPLES]))
			index = SAMPLES;
		else
		begin
			index = (x_coordinate - rect_corners[0]) / ((rect_corners[SAMPLES]-rect_corners[0])/SAMPLES);
		end
	end
	
endmodule