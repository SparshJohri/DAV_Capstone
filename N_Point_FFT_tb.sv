module N_Point_FFT_tb #(parameter SAMPLES = 8, WIDTH = 32)
(
	output [WIDTH-1:0] testBenchOutput [SAMPLES-1:0]
);

	logic [WIDTH-1:0] intermediates [$clog2(SAMPLES):0] [SAMPLES-1:0];
	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	
	initial
	begin
		sampleInputs[0] = 80;
		sampleInputs[1] = 70;
		sampleInputs[2] = 50;
		sampleInputs[3] = 40;
		sampleInputs[4] = 60;
		sampleInputs[5] = 10;
		sampleInputs[6] = 80;
		sampleInputs[7] = 90;
	end
	
	
	N_Point_FFT #(SAMPLES, WIDTH) tester
	(
		.sampleInputs(sampleInputs),
		.outputs(testBenchOutput),
		.intermediates(intermediates)
	);

endmodule