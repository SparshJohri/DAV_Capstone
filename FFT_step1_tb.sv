module FFT_step1_tb #(parameter SAMPLES = 8, WIDTH = 4)
(
	output [WIDTH-1:0] display_stream1 [SAMPLES-1:0],
	output [WIDTH-1:0] display_stream2 [SAMPLES-1:0],
	output [WIDTH-1:0] display_stream3 [SAMPLES-1:0],
	
	output [WIDTH-1:0] display_stream1_1 [SAMPLES-1:0],
	output [WIDTH-1:0] display_stream2_1 [SAMPLES-1:0],
	output [WIDTH-1:0] display_stream3_1 [SAMPLES-1:0]
);


	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] newOrder1 [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] newOrder2 [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] newOrder3 [SAMPLES-1:0];
	
	assign sampleInputs [0] = 0<<2; // 2	8
	assign sampleInputs [1] = 1<<2; // 2	8
	assign sampleInputs [2] = 1<<2; // 3	c
	assign sampleInputs [3] = 3<<2; // 3	c
	assign sampleInputs [4] = 0<<2; // 1   4
	assign sampleInputs [5] = 1<<2; // 3 	c
	assign sampleInputs [6] = 1<<2; // 0 	0
	assign sampleInputs [7] = 1<<2; // 2 	8
	
	
	logic [WIDTH-1:0] twiddles [(SAMPLES>>1)-1:0];
	assign twiddles[0] = 2 << 2;
	assign twiddles[1] = 2 << 2;
	assign twiddles[2] = 1 << 2;
	assign twiddles[3] = 3 << 2;
	
	FFT_step1 #(SAMPLES, WIDTH) tester1
		(
			.STAGE_num(0),
			.sampleInputs(sampleInputs),
			.display_stream3(newOrder1),
			.display_stream(display_stream1)
		);
	
	
	/*FFT_step2 #(SAMPLES, WIDTH) tester2
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
		);*/
	
	genvar i;
	generate
		for (i=0; i<SAMPLES; i=i+2) 
		begin : GET_END_OF_STAGE
			ButterflyUnit #(SAMPLES, WIDTH) butterfly
			(
				.input1(display_stream1[i]),
				.input2(display_stream1[i+1]),
				.twiddle(twiddles[i>>1]),
				.output1(display_stream1_1[i]),
				.output2(display_stream1_1[i+1])
			);
		end
	endgenerate
		
endmodule