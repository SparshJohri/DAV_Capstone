module prepareForFFT_tb #(parameter SAMPLES = 4, parameter WIDTH = 4)
(
	output [WIDTH-1:0] output_stream [SAMPLES-1:0]
);

	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] new_indices [SAMPLES-1:0];
	
	
	
	assign sampleInputs [0] = 3'b110;
	assign sampleInputs [1] = 3'b010;
	assign sampleInputs [2] = 3'b000;
	assign sampleInputs [3] = 3'b111;
	
	
	
	scrambleForFFT_tb #(SAMPLES, $clog2(SAMPLES)) get_new_indices
		(
			.display_stream(new_indices)
		);
	
	prepareForFFT #(SAMPLES, WIDTH) getNewOrder
	(
		.input_stream(sampleInputs),
		.new_indices(new_indices),
		.output_stream(output_stream)
	);

endmodule