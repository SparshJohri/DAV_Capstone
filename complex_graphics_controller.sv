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
	input go_left,
	input go_right,
	input go_up,
	input go_down,
	input [WIDTH-1:0] frequency_bins [SAMPLES-1:0],
	input [9:0] x_coord_of_current_block,
	input [9:0] y_coord_of_current_block,
	output [7:0] pixelPacking_out,
	input [7:0] colorToDisplay, input [7:0] emptyBackgroundForHistogram,
	
	
	output [5:0] playerX_out,
	output [5:0] playerY_out,
	
	
	
	
	input auto_win, //implementation complete
	input freeze_zombies, //implementation complete
	input gain_dominance,
	input kill_within_range,
	input move_mine_to_player_location //implementation complete
);


	logic [7:0] pixelPacking;

	//Put the basic histogram display code here
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
	assign max_y_to_display = frequency_bins[curr_bin];	
	
																		
																		logic [2:0] gameStatus = 1; //1 --> game is in progress; 2 --> user won; 3 --> user lost
																		reg [5:0] mine_X = 20;
																		reg [5:0] mine_Y = 18;
																		reg [BITS_FOR_COORD-1:0] playerX = 8; reg [BITS_FOR_COORD-1:0] playerY = 18;
																		reg [5:0] zombie1_X = 6; reg [5:0] zombie1_Y = 25;
																		reg [5:0] zombie2_X = 20; reg [5:0] zombie2_Y = 27;
																		reg [5:0] zombie3_X = 22; reg [5:0] zombie3_Y = 22;
																		
																		reg [5:0] updatePlayerX = 1; reg [5:0] updatePlayerY = 0;
																		reg [5:0] update_zombie1_X = 0; reg [5:0] update_zombie1_Y = 0;
																		reg [5:0] update_zombie2_X = 0;  reg [5:0] update_zombie2_Y = 0;
																		reg [5:0] update_zombie3_X = 0; reg [5:0] update_zombie3_Y = 0;
																		
																		
																		
																		reg [22:0] movementCoordinator = 0;
																		always @(posedge clk)
																		begin
																			movementCoordinator <= movementCoordinator+1;
																			
																			if (gameStatus==1)
																			begin
																				if (auto_win) gameStatus <= 2;
																				else if (((playerX==zombie1_X)&&(playerY==zombie1_Y)) || 
																				      (  ((playerX==zombie2_X)&&(playerY==zombie2_Y)) || 
																					      ((playerX==zombie3_X)&&(playerY==zombie3_Y)) 
																				      ) 
																				        )
																				begin
																					if (~gain_dominance)
																						gameStatus <= 3;
																					//else
																					//begin
																					//	the zombie should disappear and never reappear
																					//end																					
																				end
																			end
																		end
																		
																		always @(posedge movementCoordinator[19])
																		begin
																			playerY <= playerY + updatePlayerY;
																			
																			if (((playerX<MAX_X)&&(playerX>=MIN_X))&&
																				 ((playerY<MAX_Y)&&(playerY>=MIN_Y)))
																			begin
																				playerX <= mine_X;
																				playerY <= mine_Y;
																			end
																			
																			else
																			begin
																				if (move_mine_to_player_location)
																				begin
																					mine_X <= playerX;
																					mine_Y <= playerY;
																				end
																				
																				if (((playerX < 31) && (go_right)) && (~go_left))
																					playerX <= playerX+1;
																				else if (((playerX > 1) && (~go_right)) && (go_left))
																					playerX <= playerX-1;
																				
																				if (((playerY < 23) && (go_up)) && (~go_down))
																					playerY <= playerY+1;
																				else if (((playerY > 1) && (~go_up)) && (go_down))
																					playerY <= playerY-1;
																			end
																		end
																		

																		always @(posedge movementCoordinator[22])
																		begin	
																			zombie1_Y <= zombie1_Y + update_zombie1_Y;
																			zombie2_Y <= zombie2_Y + update_zombie1_Y;
																			zombie3_Y <= zombie3_Y + update_zombie1_Y;
																			
																			if (~freeze_zombies)
																			begin
																				//if (zombie1_Y > 2) 
																					update_zombie1_Y <= -1;
																				//else
																				//	update_zombie1_Y <= 0;
																				//if (zombie2_Y > 2)
																					update_zombie2_Y <= -1;
																				//else
																				//	update_zombie2_Y <= 0;
																				//if (zombie3_Y > 2) 
																					update_zombie3_Y <= -1;
																				//else
																				//	update_zombie3_Y <= 0;
																			end
																			else
																			begin
																					update_zombie1_X <= 0;
																					update_zombie2_X <= 0;
																					update_zombie3_X <= 0;	
																					
																					update_zombie1_Y <= 0;
																					update_zombie2_Y <= 0;
																					update_zombie3_Y <= 0;																	
																			end
																			//If any zombie steps on the mine, they should immediately die unless the player is there too
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
						if (gameStatus == 1)
						begin
								if ((x_coord_of_current_block==mine_X)&&(y_coord_of_current_block==mine_Y)) //check for mine
									pixelPacking = 7;
								else if ((x_coord_of_current_block=={4'b0, playerX})&&(y_coord_of_current_block=={4'b0, playerY})) //check for player
									pixelPacking = colorToDisplay;
								else if (((x_coord_of_current_block==zombie1_X)&&(y_coord_of_current_block==zombie1_Y)) || 
										 ( ((x_coord_of_current_block==zombie2_X)&&(y_coord_of_current_block==zombie2_Y)) || 
											((x_coord_of_current_block==zombie3_X)&&(y_coord_of_current_block==zombie3_Y)) 
										 ) 
										  )
									pixelPacking = 'b11011000;
								else
									pixelPacking = 0;
						end
						else if (gameStatus == 2)
						begin
								pixelPacking = 'b00111000; //Victory color
						end
						else
						begin
								pixelPacking = 'b00000111; //loss color
						end
				end
		
	end
	
	assign pixelPacking_out = pixelPacking;
	assign playerX_out = playerX;
	assign playerY_out = playerY;
	
endmodule