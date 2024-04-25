module graphicsController #(parameter SAMPLES=32, WIDTH=32)
(
	input [9:0] rect_corners [SAMPLES:0],
	input [9:0] coordinates  [1:0],
	input [(WIDTH-1):0] value [SAMPLES:0],
	
	output [7:0] RGB
);
/*
Inputs: the x-coordinates of the corners of n+1 rectanges, value, xy
Outputs: a single byte encoding the RGB value of the given pixel
*/

	logic [9:0] index_of_rectangle;
	logic [9:0] maxVal;
	
	
	getRightRect #(SAMPLES)
	(
		.x_coordinate(coordinates[0]), 
		.rect_corners(rect_corners),
		.index(index_of_rectangle)
	); //Finds the index of the rectangle in question
	
	calculateMaxVal #(SAMPLES, WIDTH)
	(
		value[index_of_rectangle], 
		maxVal
	); //Figures out what the height of the rectangle should be
	
	always_comb //If the current y value is above what the height of the rectangle should be, make the screen black
	begin	
		if (coordinates[1] > maxVal)
			RGB = 0;
		else
			RGB = 100;
	end

endmodule