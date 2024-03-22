module prepareForFFT_tb #(parameter SAMPLES = 4, parameter WIDTH = 3)
(
	output [WIDTH-1:0] output_stream [SAMPLES-1:0]
);

	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	
	assign sampleInputs [0] = 3'b110;
	assign sampleInputs [1] = 3'b010;
	assign sampleInputs [2] = 3'b000;
	assign sampleInputs [3] = 3'b111;
	
	
	prepareForFFT #(SAMPLES, WIDTH) getNewOrder
	(
		.input_stream(sampleInputs),
		.output_stream(output_stream)
	);
	//assign output_stream[0] = sampleInputs[0][WIDTH-1:0];

endmodule