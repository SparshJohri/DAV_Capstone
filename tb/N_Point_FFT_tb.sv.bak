`timescale 1ps/1ps;

module N_Point_FFT_tb #(parameter SAMPLES = 16, WIDTH = 32)
(
	output [WIDTH-1:0] testBenchOutput [SAMPLES-1:0]
);

	logic [WIDTH-1:0] intermediates [$clog2(SAMPLES):0] [SAMPLES-1:0];
	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	logic clk, rst, out_valid;
	
	initial
	begin

		forever begin
			#1 clk = ~clk;
		end

		// run with iverilog
		$dumpfile("dump.vcd");
		$dumpvars(0);


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
	
	
	N_point_fft_seq #(SAMPLES, WIDTH) tester
	(
		.sampleInputs(sampleInputs),
		.clk(clk),
		.rst(rst),
		.out_valid(out_valid),
		.outputs(testBenchOutput),
		.intermediates(intermediates)
	);

endmodule