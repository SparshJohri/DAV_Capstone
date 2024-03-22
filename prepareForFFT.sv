module prepareForFFT #(parameter SAMPLES = 4, parameter WIDTH = 2)
(
	input [WIDTH-1:0] input_stream [SAMPLES-1:0],
	output [WIDTH-1:0] output_stream [SAMPLES-1:0]
);

	logic [$clog2(SAMPLES)-1:0] new_indices [SAMPLES-1:0];
	scrambleForFFT_tb #(SAMPLES, $clog2(SAMPLES)) get_new_indices
	(
		.display_stream(new_indices)
	);
	
	genvar i;
	generate
		for (i=0; i<SAMPLES; i++)
		begin : ASSIGNER
			assign output_stream[i] = input_stream[new_indices[i]];
		end
	endgenerate
	
endmodule