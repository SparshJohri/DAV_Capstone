`timescale 1ns/1ns

module Testbenching_VGA_display 
(
	output [31:0] outputs_out [15:0],
	output [31:0] sampleRec_not_reg [15:0],
	output [7:0] colorToDisplay,
	output [17:0] magnitudes_out [15:0]
);
	//Variables used in module
		logic clk;
		logic prev_out_valid;
		logic prev_done;

		//indicate when the FFT and color determiner modules (respectively) finish
			logic out_valid, done;
	
		//control the reset of the aforementioned modules
			logic [9:0] counter;
			logic reset, reset_color_determiner;
	
		//throwaway variable
			logic whichRAM;

		//Getting results from the FFT
			reg [31:0] test_memory [31:0]; //holds the samples I'm sending to the mic
			reg [4:0] memory_tracker; //indicates which sample should be sent to the mic
			logic [15:0] mic_stream; //latest sample from the mic
			reg [31:0] sampleRec [15:0]; //record of samples
			logic [31:0] outputs [15:0]; //output of FFT
			logic [31:0] outputs_FFT_true [15:0]; //stores the valid outputs of the FFT
			logic [17:0] magnitudes [15:0]; //L1-norm of the FFT output
			logic [4:0] index_holder; //will hold the index of the highest-magnitude value
	
	initial
	begin
		test_memory[0] = 0; test_memory[1] = 200; test_memory[2] = 400; test_memory[3] = 800;
		test_memory[4] = 1600; test_memory[5] = 800; test_memory[6] = 400; test_memory[7] = 200;
		
		test_memory[8] = 0; test_memory[9] = 200; test_memory[10] = 400; test_memory[11] = 200;
		test_memory[12] = 0; test_memory[13] = 200; test_memory[14] = 400; test_memory[15] = 200;

		
		test_memory[16] = 100; test_memory[17] = 200; test_memory[18] = 300; test_memory[19] = 400;
		test_memory[20] = 500; test_memory[21] = 600; test_memory[22] = 700; test_memory[23] = 800;	
		test_memory[24] = 900; test_memory[25] = 800; test_memory[26] = 700; test_memory[27] = 600;
		test_memory[28] = 500; test_memory[29] = 400; test_memory[30] = 300; test_memory[31] = 200;
		
		memory_tracker = 0; counter = 0; clk = 0;
	end
	
	
	always #1 clk = ~clk;
	always @(posedge clk)
	begin
		//scoot the list of samples and load the next sample into the mic stream
		if (out_valid)
			outputs_FFT_true <= outputs;
			
		sampleRec[15:1] <= sampleRec[14:0];
		sampleRec[0] <= mic_stream;
		mic_stream <= test_memory[memory_tracker];
		memory_tracker <= memory_tracker + 1;
		
		//resets: counter controls the the FFT; reset_color_determiner controls the histogram
		counter <= counter+1;
		reset_color_determiner <= ( (~prev_out_valid) && (out_valid) );
		reset <= ((~prev_done) && (done));
		prev_out_valid <= out_valid;
		prev_done <= done;
	end
	
	N_point_fft_seq #(.WIDTH(32),.SAMPLES(16)) 
	N_point_fft_seq_inst (clk, reset, sampleRec, out_valid, outputs);
	
	
	genvar i;
	generate
		for (i = 0; i < 16; i++) 
		begin : PEACE
			logic [15:0] addend1;
			logic [15:0] addend2;
			assign addend1 = (outputs_FFT_true[i][31]) ? -1*outputs_FFT_true[i][31:16] : outputs_FFT_true[i][31:16];
			assign addend2 = (outputs_FFT_true[i][15]) ? -1*outputs_FFT_true[i][15:0]  : outputs_FFT_true[i][15:0];
			assign magnitudes[i] = addend1 + addend2;								
		end
	endgenerate
	
	logic [7:0] emptyBackgroundForHistogram;
	assign emptyBackgroundForHistogram = 7<<3; //38
	getIndicesOfGreatestBins #(16, 18) maxBinGetter
	(clk, magnitudes, index_holder, done, reset_color_determiner);
	
	colorDeterminer #(16) colorDeterminerInstance
	(index_holder, whichRAM, done, emptyBackgroundForHistogram, colorToDisplay);

	//looking at the values inside registers by adding wires that map to them
	assign magnitudes_out = magnitudes;
	assign sampleRec_not_reg = sampleRec;
	assign outputs_out = outputs_FFT_true;
	
endmodule