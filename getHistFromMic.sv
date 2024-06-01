module getHistFromMic #(parameter SAMPLES = 16, WIDTH = 32, SCALER=1)
(
	input clk, input adc_clk, //clocks (one for FFT, one for the microphone input updates)
	input [SAMPLES-1:0] mic_stream, 
	output [WIDTH-1:0] outputs_out [SAMPLES-1:0], output [WIDTH-1:0] sampleRec_not_reg [SAMPLES-1:0],
	output reg [WIDTH-1:0] outputs_FFT_true [SAMPLES-1:0], output reg [WIDTH-1:0] sampleRec_yes_reg [SAMPLES-1:0],
	output [(WIDTH/2)+1:0] magnitudes [SAMPLES-1:0],
	output [$clog2(SAMPLES)-1:0] index_holder,
	output done
);

	logic whichRAM, prev_out_valid, out_valid, prev_done, reset, reset_color_determiner;
	logic [WIDTH-1:0] outputs [SAMPLES-1:0]; //continuous output of FFT
	logic [WIDTH-1:0] sampleRec [SAMPLES-1:0]; //continuously updating the sample list
	
	//Sequential block for dealing with sample updates
	always @(posedge adc_clk)
	begin
		//scoot the list of samples and load the next sample into the mic stream
		sampleRec[SAMPLES-1:1] <= sampleRec[SAMPLES-2:0];
		sampleRec[0] <= mic_stream;
	end
	
	//Sequential block for dealing with FFT updates and index calculation updates
	always @(posedge clk)
	begin
		if (out_valid)
		begin
			sampleRec_yes_reg <= sampleRec; //save inputs to current iteration of FFT
			outputs_FFT_true <= outputs; //save final outputs of the previous iteration of FFT
		end
		reset_color_determiner <= ( (~prev_out_valid) && (out_valid) ); reset <= ((~prev_done) && (done)); //reset the index calculator and the FFT
		prev_out_valid <= out_valid; prev_done <= done;
	end
	
	N_point_fft_seq #(.WIDTH(WIDTH),.SAMPLES(SAMPLES)) N_point_fft_seq_inst (clk, reset, sampleRec, out_valid, outputs);	
	
	//Combinational block for magnitude updates
	genvar i;
	generate
		for (i = 0; i < SAMPLES; i++) 
		begin : PEACE
			logic [(WIDTH/2) - 1:0] addend1;
			logic [(WIDTH/2) - 1:0] addend2;
			assign addend1 = (outputs_FFT_true[i][WIDTH-1]) ? -1*outputs_FFT_true[i][WIDTH-1:WIDTH/2] : outputs_FFT_true[i][WIDTH-1:WIDTH/2];
			assign addend2 = (outputs_FFT_true[i][(WIDTH/2) - 1]) ? -1*outputs_FFT_true[i][(WIDTH/2) - 1:0]  : outputs_FFT_true[i][(WIDTH/2) - 1:0];
			assign magnitudes[i] = (addend1 + addend2)>>(SCALER);						
		end
	endgenerate
	
	getIndicesOfGreatestBins #(SAMPLES, (WIDTH/2) + 2) maxBinGetter (clk, magnitudes, index_holder, done, reset_color_determiner);

	//For looking inside reg variables in Questa
	assign sampleRec_not_reg = sampleRec_yes_reg;
	assign outputs_out = outputs_FFT_true;
	
endmodule