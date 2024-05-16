module get_n_samples #(parameter SAMPLES=16, WIDTH=32)
(
	input adc_clk,
	output [(WIDTH-1):0] outcomes [(SAMPLES-1):0]
);

	logic [(WIDTH-1):0] outcomes_temp;
	
	get_microphone_samples #(WIDTH) sampleGetter
	(
		.adc_clk(adc_clk),
		.output_stream(outcomes_temp)
	);
	
	always @(posedge adc_clk)
	begin
		outcomes[SAMPLES-1:1] = outcomes[SAMPLES-2:0];
		outcomes[0] = outcomes_temp;//= {outcomes[(SAMPLES-1):1], outcomes_temp};
	end

endmodule