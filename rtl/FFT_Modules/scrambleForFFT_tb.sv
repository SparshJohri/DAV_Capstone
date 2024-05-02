module scrambleForFFT_tb #(parameter SAMPLES = 8, parameter WIDTH = 3)
(
	output [WIDTH-1:0] display_stream [SAMPLES-1:0]
);

	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	
	genvar i;
	generate
        for (i = 0; i < SAMPLES; i++) begin : SCRAMBLE_INPUTS
            assign sampleInputs[i] = i;
        end
   endgenerate
	
	
	scrambleForFFT #(SAMPLES, WIDTH) tester
	(
		.input_stream(sampleInputs),
		.output_stream(display_stream)
	);
	
endmodule