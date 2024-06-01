/*
Remaining Tasks
1) Verify that the histogram is correct by having the microphone set up
2) Ensure that the color determiner module is working correctly (there should be three possible colors)
3) Have more colors in the color determiner module
4) Have auto_win, input freeze_zombies, input gain_dominance, input kill_within_range, and input move_mine_to_player_location
	determined by the heights of specific bins in the histogram (although the current implementation should remain in commented out form)
5) Further cosmetic changes
*/

module vga_top #(parameter SAMPLES=16, WIDTH = 32)
(
    input clk, input adc_clk,
	 input go_left, input go_right, input go_up, input go_down,
    output [2:0] red, output [2:0] green, output [1:0] blue,
    output hsync, output vsync,
	 output [9:0] led_debugging,
	 
	 input auto_win, input freeze_zombies, input gain_dominance, input kill_within_range, input move_mine_to_player_location
);
	 /*
	 1) Get the latest microphone sample
	 2) Get the values for the histogram and the index of the highest value
	 3) Get the right color for the histogram
	 4) Display the appropriate value for the current pixel-group on the VGA given the player inputs and the histogram information (internally maintain game logic)
	 */
	 
	 logic [WIDTH-1:0] magnitudes [SAMPLES-1:0];
	 
	 wire res_clock;

	 //Task 1
	 logic [31:0] mic_stream;
	 get_microphone_samples microphoneInputDisplayer (adc_clk, mic_stream, led_debugging);
	 
	 
	 //Task 2
	 logic [WIDTH-1:0] outputs_FFT_true [SAMPLES-1:0];
	 logic [WIDTH-1:0] next_inputs_to_FFT [SAMPLES-1:0];
	 logic [(WIDTH/2)+1:0] defaultHistogramValues [SAMPLES-1:0];
	 logic [$clog2(SAMPLES)-1:0] index_holder;
	 logic done;
	 getHistFromMic #(SAMPLES, WIDTH, 6) histogramInfoGenerator
	 (
		.adc_clk(adc_clk), .mic_stream(mic_stream),
		.clk(clk), .outputs_FFT_true(outputs_FFT_true), .sampleRec_yes_reg(next_inputs_to_FFT),
		.magnitudes(defaultHistogramValues), .index_holder(index_holder),
		.done(done)
	 );
	 
	 //Task 3
	 logic [7:0] emptyBackgroundForHistogram;
	 logic [7:0] colorToDisplay;
	 assign emptyBackgroundForHistogram = 7<<3;
	 colorDeterminer #(SAMPLES) colorDeterminerInstance
	 (
		index_holder, whichRAM, done,
		emptyBackgroundForHistogram, colorToDisplay
	 );
	 
	 //All VGA-related Modules
	 logic [7:0] updated_value_of_block, color;
	 wire [$clog2(526)-1:0]  vc_count;
	 wire [$clog2(801)-1:0]  hc_count;
	 logic [9:0] x, y;
	 logic [5:0] playerX_out, playerY_out;
	 
			 pll_2 DataClock (clk, res_clock);
			 //calculate the hsync, vsync, and the three colors from the pixel packing
			 vga #(SAMPLES, WIDTH) VGA
			 (
				  .vgaclk(res_clock),
				  .hc_out(hc_count), .vc_out(vc_count), .hsync(hsync), .vsync(vsync), //jump to the line reading "assign x = hc_count / 20;"
				  
				  .colorPacking(color),
				  .red(red), .green(green), .blue(blue)
			 );
			 
			 //Task 4
			 assign x = hc_count/20;
			 assign y = vc_count/20;
			 
			 /*
			 logic auto_win, freeze_zombies, gain_dominance, kill_within_range, move_mine_to_player_location;
			 assign auto_win = 0;
			 assign freeze_zombies = 0;
			 assign gain_dominance = 0;
			 assign kill_within_range = 0;
			 assign move_mine_to_player_location = 0;
			 */
			 complex_graphics_controller #(SAMPLES, WIDTH, 0, 32, 0, 10) getColor
			 (
				.clk(res_clock), //clock to sync to
				.go_left(go_left), .go_right(go_right), .go_up(go_up), .go_down(go_down), //player controls
				.frequency_bins(defaultHistogramValues), .colorToDisplay(colorToDisplay), .emptyBackgroundForHistogram(emptyBackgroundForHistogram), //histogram controls
				.x_coord_of_current_block(x), .y_coord_of_current_block(y), //current pixel-group coordinate on VGA
				
				.pixelPacking_out(updated_value_of_block), //what the next value of the current pixel-group coordinate will be
				.playerX_out(playerX_out), .playerY_out(playerY_out), //current x and y coordinates of the player
				
				.auto_win(auto_win), .freeze_zombies(freeze_zombies), .gain_dominance(gain_dominance), .kill_within_range(kill_within_range), .move_mine_to_player_location(move_mine_to_player_location)
			 );
			 
			 //update the internal array for the given block and get the current value for the given block
			 ping_pong #(SAMPLES, WIDTH) color_getter
			 (
				.clk(res_clock), .hc(hc_count), .vc(vc_count), .updated_value_of_block(updated_value_of_block), 
				.pixel_to_display(color) //jump to the line reading ".colorPacking(color)"
			 );

endmodule