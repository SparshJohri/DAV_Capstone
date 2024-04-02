module N_Point_FFT #(parameter SAMPLES = 4, WIDTH = 32)
(
	input [WIDTH-1:0] sampleInputs [SAMPLES-1:0],
	output [WIDTH-1:0] outputs [SAMPLES-1:0],
	output [WIDTH-1:0] intermediates [$clog2(SAMPLES):0] [SAMPLES-1:0]
);

	//logic [WIDTH-1:0] intermediates [$clog2(SAMPLES):0] [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] new_indices [SAMPLES-1:0];



	scrambleForFFT_tb #(SAMPLES, $clog2(SAMPLES)) get_new_indices
		(
			.display_stream(new_indices)
		);
	
	prepareForFFT #(SAMPLES, WIDTH) getNewOrder
	(
		.input_stream(sampleInputs),
		.new_indices(new_indices),
		.output_stream(intermediates[0])
	);

	genvar i;
	generate
		for(i=0; i<$clog2(SAMPLES); i++)
		begin : FFT_LOOP
			FFT_step #(SAMPLES, WIDTH, i) takeStep
			(
				.sampleInputs(intermediates[i]), 
				.display_stream1_1(intermediates[i+1]) 
			);
		end
	endgenerate

	assign outputs = intermediates[$clog2(SAMPLES)];
	

endmodule