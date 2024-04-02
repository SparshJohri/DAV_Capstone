module N_Point_FFT_tb #(parameter SAMPLES = 16, WIDTH = 32)
(
	output [WIDTH-1:0] testBenchOutput [SAMPLES-1:0]
);

	logic [WIDTH-1:0] intermediates [$clog2(SAMPLES):0] [SAMPLES-1:0];
	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	
	initial
	begin
		sampleInputs[0] = 0;
		sampleInputs[1] = 100;
		sampleInputs[2] = 200;
		sampleInputs[3] = 300;
		sampleInputs[4] = 400;
		sampleInputs[5] = 500;
		sampleInputs[6] = 600;
		sampleInputs[7] = 700;
		sampleInputs[8] = 800;
		sampleInputs[9] = 900;
		sampleInputs[10] = 1000;
		sampleInputs[11] = 1100;
		sampleInputs[12] = 1200;
		sampleInputs[13] = 1300;
		sampleInputs[14] = 1400;
		sampleInputs[15] = 1500;
	end
	
	
	N_Point_FFT #(SAMPLES, WIDTH) tester
	(
		.sampleInputs(sampleInputs),
		.outputs(testBenchOutput),
		.intermediates(intermediates)
	);

endmodule