module FFT_step1_tb #(parameter SAMPLES = 8, WIDTH = 3)
(
	output [WIDTH-1:0] display_stream1 [SAMPLES-1:0],
	output [WIDTH-1:0] display_stream2 [SAMPLES-1:0],
	output [WIDTH-1:0] display_stream3 [SAMPLES-1:0]
);


	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] newOrder1 [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] newOrder2 [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] newOrder3 [SAMPLES-1:0];
	
	
	assign sampleInputs [0] = 0;
	assign sampleInputs [1] = 1;
	assign sampleInputs [2] = 2;
	assign sampleInputs [3] = 3;
	assign sampleInputs [4] = 4;
	assign sampleInputs [5] = 5;
	assign sampleInputs [6] = 6;
	assign sampleInputs [7] = 7;
	
	FFT_step1 #(SAMPLES, WIDTH) tester1
		(
			.sampleInputs(sampleInputs),
			.display_stream3(newOrder1),
			.display_stream(display_stream1)
		);
	
	
	FFT_step2 #(SAMPLES, WIDTH) tester2
		(
			.sampleInputs(sampleInputs),
			.display_stream3(newOrder2),
			.display_stream(display_stream2)
		);

	FFT_step3 #(SAMPLES, WIDTH) tester3
		(
			.sampleInputs(sampleInputs),
			.display_stream3(newOrder3),
			.display_stream(display_stream3)
		);
		
endmodule