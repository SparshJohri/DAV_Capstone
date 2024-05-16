module vga_top 
(
     input clk, input adc_clk,
	 input go_left, input go_right, input go_up, input go_down,
     output [2:0] red, output [2:0] green, output [1:0] blue,
     output hsync, output vsync,
	 output [9:0] led_debugging
);
	 logic [7:0] updated_value_of_block;
	 logic [9:0] x, y;
	 
	 logic [2:0] input_red = 6;
	 logic [2:0] input_green = 0;
	 logic [1:0] input_blue = 0;
	 logic [7:0] color;
	 
	 wire res_clock;
     wire [$clog2(526)-1:0]  vc_count;
     wire [$clog2(801)-1:0]  hc_count;
	 
	 assign x = hc_count/20;
	 assign y = vc_count/20;

	 
	 logic [32-1:0] sampleRec [8-1:0];
	 logic [32-1:0] loadNextSamples [8-1:0];
	 logic [32-1:0] frequencyBins [8-1:0];
	 logic [32-1:0] frequencyBins_perm [8-1:0];
	 logic reset;
	 logic out_valid;
	 
	 always @(posedge adc_clk)
	 begin
		sampleRec[7:1] <= sampleRec[6:0];
		sampleRec[0] <= mic_stream;
	 end
	 
	 always @(posedge clk)
	 begin
		if (out_valid)
		begin
			frequencyBins_perm <= frequencyBins;
			reset <= 1;
		end
		
		if (reset)
		begin
			reset <= 0;
			loadNextSamples <= sampleRec;
		end
	 end
	 
	 pll_2 DataClock //get the clock for the VGA 
	 (
		clk,
		res_clock
	 );
	 
	
	 N_point_fft_seq #(32, 8) tester
	 (
		.sampleInputs(loadNextSamples),
		.clk(clk),
		.rst(reset),
		.out_valid(out_valid),
		.outputs(frequencyBins)
	 );
	 
	 
	 logic [5:0] playerX_out;
	 complex_graphics_controller #(8, 32, 0, 32, 0, 10) getColor //calculate the next pixel for the given block
	 (
		.clk(res_clock),
		.go_left(go_left),
		.go_right(go_right),
		.go_up(go_up),
		.go_down(go_down),
		.frequency_bins(sampleRec),
		.x_coord_of_current_block(x),
		.y_coord_of_current_block(y),
		.whichRAM(write_to_two),
		.pixelPacking_out(updated_value_of_block),
		.reset(reset),
		.playerX_out(playerX_out)
	 );
	 
	 ping_pong #(8, 32) color_getter //update the internal array for the given block and get the current value for the given block
	 (
		.clk(res_clock),
		.hc(hc_count),
		.vc(vc_count),
		.updated_value_of_block(updated_value_of_block),
		.pixel_to_display(color)
	 );
	 
	 vga #(8, 32) VGA //calculate the hsync, vsync, and the three colors from the pixel packing
	 (
        .vgaclk(res_clock),
		  .colorPacking(color),
        .hc_out(hc_count),
        .vc_out(vc_count),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );
	 
	 
	 logic [31:0] mic_stream;
	 get_microphone_samples microphoneInputDisplayer
	 (
		adc_clk,
		mic_stream,
		led_debugging
	 );

endmodule