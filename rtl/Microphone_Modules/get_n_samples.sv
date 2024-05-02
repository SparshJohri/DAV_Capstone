module get_n_samples #(parameter SAMPLES=16, WIDTH=32)
(
	input clk,
	input adc_clk,
	output [(WIDTH-1):0] outcomes [(SAMPLES-1):0]
);

	logic [$clog2(SAMPLES):0] sampleNum;
	logic [$clog2(SAMPLES):0] nextSample;
	logic [(WIDTH-1):0] outcomes_temp [(SAMPLES-1):0];
	
	
	get_microphone_samples #(WIDTH) sampleGetter
	(
		.clk(clk),
		.adc_clk(adc_clk),
		.output_stream(outcomes_temp[sampleNum])
	);
	
	initial
	begin
		sampleNum = 0;
	end

	always_comb
	begin
		if (sampleNum < (SAMPLES-1)) nextSample = sampleNum+1;
		else
		begin
			nextSample = sampleNum;		
		end
	end
	
	
	always @(posedge clk)
	begin
		if (sampleNum >= (SAMPLES-1)) outcomes[(SAMPLES-2):0] <= outcomes[(SAMPLES-1):1]; //to-do
		outcomes[sampleNum] <= outcomes_temp[sampleNum];
		sampleNum <= nextSample;
	end

endmodule