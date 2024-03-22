module scrambleForFFT #(parameter SAMPLES = 8, parameter WIDTH = 3)
(
	input [WIDTH-1:0] input_stream [SAMPLES-1:0],
	input [WIDTH-1:0] output_stream [SAMPLES-1:0]
);

	genvar i;
	generate
        for (i = 0; i < SAMPLES; i++) begin : SCRAMBLE_INPUTS
            Bit_Reversal #(WIDTH) E
				(
					.input_stream (input_stream [i]),
					.output_stream(output_stream[i])
				);
        end
   endgenerate
endmodule