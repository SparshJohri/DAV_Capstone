module prepareForFFT_tb #(parameter SAMPLES = 8, parameter WIDTH = 3)
(
	output [WIDTH-1:0] output_stream [SAMPLES-1:0]
);

	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	
	assign sampleInputs[0] = 5;
	assign sampleInputs[1] = 3;
	assign sampleInputs[2] = 6;
	assign sampleInputs[3] = 2;
	assign sampleInputs[4] = 7;
	assign sampleInputs[5] = 1;
	assign sampleInputs[6] = 0;
	assign sampleInputs[7] = 4;
	
	prepareForFFT #(SAMPLES, WIDTH) tester
	(
		.input_stream(sampleInputs),
		.output_stream(output_stream)
	);


endmodule