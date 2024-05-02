module simple_graphics_controller_tb
(
	output [7:0] pixelPacking
);


	logic [9:0] x_coord_of_current_block;
	logic [9:0] y_coord_of_current_block;
	logic whichRAM;
	
	simple_graphics_controller_for_demo tester
	(
		x_coord_of_current_block,
		y_coord_of_current_block,
		whichRAM,
		pixelPacking
	);
	
	initial
	begin
		whichRAM = 0;
		#5
		whichRAM = 1;
	end

endmodule