module gameController #(parameter SAMPLES=32)
(
	input [9:0] start_x,
	input [9:0] end_x,
	output [9:0] rect_corners [SAMPLES:0]
);
	
	always_comb
	begin
		for(int i=0; i<SAMPLES; i++)
		begin
			assign rect_corners[i] = start_x + ((end_x-start_x)/SAMPLES)*i;
		end		
		rect_corners[SAMPLES] = end_x;
	end
	
endmodule