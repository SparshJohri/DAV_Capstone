module complex_graphics_controller #(parameter SAMPLES = 32, 
												           WIDTH = 32, 
												           MIN_X=4, //0
												           MAX_X=28, //32
												           MIN_Y=0, //0
												           MAX_Y=8, //24
															  BITS_FOR_COORD=6
												)
(
	input clk,
	input [WIDTH-1:0] frequency_bins [SAMPLES-1:0],
	input [9:0] x_coord_of_current_block,
	input [9:0] y_coord_of_current_block,
	input whichRAM,
	output [7:0] pixelPacking,
	input reset
);

	logic [7:0] colorToDisplay;
	logic [7:0] emptyBackgroundForHistogram;

	//Put the basic histogram display code here
	//For setting up a basic histogram display
	
	
	logic [9:0] curr_bin;
	
	/*
	always_comb
	begin
		if ( (x_coord_of_current_block >= MIN_X) && (x_coord_of_current_block < MAX_X) )
			curr_bin = (SAMPLES*(x_coord_of_current_block - MIN_X) / (MAX_X - MIN_X)); //[$clog2(SAMPLES)-1:0];//0; //((SAMPLES*(x_coord_of_current_block-MIN_X))/(MAX_X - MIN_X));
		else
			curr_bin = 0;
	end
	*/
	assign curr_bin = x_coord_of_current_block;
	logic [9:0] max_y_to_display;
	localparam maxPowerToShow = 100;
	//assign max_y_to_display = ((MAX_Y-MIN_Y)*frequency_bins[curr_bin]/maxPowerToShow)+MIN_Y;//8;//(frequency_bins[curr_bin]/maxPowerToShow)*(MAX_Y-MIN_Y);
	assign max_y_to_display = 8*frequency_bins[curr_bin]/100;
	
	
	//assign colorToDisplay = 7; //comment out after color-changing code is put in
	assign emptyBackgroundForHistogram = 7<<3;

	
	//Put the color changing code here
	
	//For changing the color depending on which frequency is detected
	logic [$clog2(SAMPLES)-1:0] index_holder;
	logic done;
	
	getIndicesOfGreatestBins #(SAMPLES, WIDTH) maxBinGetter
	(
		clk, //input
		frequency_bins, //input
		index_holder, //output
		done,	//output
		reset //input
	);

	colorDeterminer #(SAMPLES) colorDeterminerInstance
	(
		index_holder, //input
		whichRAM, //input
		done, //input
		emptyBackgroundForHistogram, //input; note: I can put in some other color here as well; it doesn't have to be backgroundColor
		colorToDisplay //output
	);
	
	reg [BITS_FOR_COORD-1:0] playerX = 8;
	reg [BITS_FOR_COORD-1:0] playerY = 18;

	reg [5:0] mine_X = 20;
	reg [5:0] mine_Y = 18;
	
	reg [5:0] updatePlayerX = 1;
	reg [5:0] updatePlayerY = 0;
	reg [19:0] movementCoordinator = 0;
	
	
	always @(posedge clk)
	begin
		movementCoordinator <= movementCoordinator+1;
	end
	
	always @(posedge movementCoordinator[19])
	begin
		playerX <= playerX+updatePlayerX;
		playerY <= playerY + updatePlayerY;
		
		
		if (playerX < 16)
			updatePlayerX <= 1;
		else if (playerX > 16);
			updatePlayerX <= -1;
		
		//updatePlayerY <= 0;
	end
	
	always_comb
	begin
		if (((x_coord_of_current_block<MAX_X)&&(x_coord_of_current_block>=MIN_X))&&
			 ((y_coord_of_current_block<MAX_Y)&&(y_coord_of_current_block>=MIN_Y)))
		begin
			if (y_coord_of_current_block <= max_y_to_display)
				pixelPacking = colorToDisplay;
			else
				pixelPacking = emptyBackgroundForHistogram;
		end
		
		else
		begin
			//While this is set to zero for now, if we have time, this is where our game would go
			if ((x_coord_of_current_block==mine_X)&&(y_coord_of_current_block==mine_Y))
				pixelPacking = 7;
			else if ((x_coord_of_current_block=={4'b0, playerX})&&(y_coord_of_current_block=={4'b0, playerY}))
				pixelPacking = colorToDisplay;
			else
				pixelPacking = 0;
		end
	end

endmodule