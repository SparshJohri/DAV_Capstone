module prepareForFFT #(parameter SAMPLES = 8, parameter WIDTH = 3)
(
	input [WIDTH-1:0] input_stream [SAMPLES-1:0],
	output [WIDTH-1:0] output_stream [SAMPLES-1:0]
);

	logic [WIDTH-1:0] new_indices [SAMPLES-1:0];
	scrambleForFFT_tb #(SAMPLES, WIDTH) get_new_indices
	(
		.display_stream(new_indices)
	);
	
	genvar i;
	generate
		for (i=0; i<SAMPLES; i++) begin : ASSIGNMENT
			assignmentOperator #(WIDTH) assignment1
			(
				output_stream[i],
				input_stream[i]
			);
		end
	endgenerate

endmodule