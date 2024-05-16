`timescale 1ns/1ns

module N_Point_FFT_tb #(parameter SAMPLES = 16, WIDTH = 32)
(
	output [WIDTH-1:0] testBenchOutput [SAMPLES-1:0],
	output reg [WIDTH-1:0] testBenchOutput_actual [SAMPLES-1:0],
	output [WIDTH-1:0] testBenchOutput_actual_actual [SAMPLES-1:0]
);

	logic [WIDTH-1:0] intermediates [$clog2(SAMPLES):0] [SAMPLES-1:0];
	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	logic clk = 0;
	logic rst = 0;
	logic out_valid;

	always #1 clk = ~clk;

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
		
		#100
		//rst = 1;

		sampleInputs[0] = 900;
		sampleInputs[1] = 800;
		sampleInputs[2] = 700;
		sampleInputs[3] = 600;
		sampleInputs[4] = 500;
		sampleInputs[5] = 400;
		sampleInputs[6] = 300;
		sampleInputs[7] = 200;
		sampleInputs[8] = 100;
		sampleInputs[9] = 000;
		sampleInputs[10] = 1100;
		sampleInputs[11] = 1200;
		sampleInputs[12] = 1300;
		sampleInputs[13] = 1400;
		sampleInputs[14] = 1500;
		sampleInputs[15] = 1600;
		
		#100
		
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
		
		#100
		
		sampleInputs[0] = 900;
		sampleInputs[1] = 800;
		sampleInputs[2] = 700;
		sampleInputs[3] = 600;
		sampleInputs[4] = 500;
		sampleInputs[5] = 400;
		sampleInputs[6] = 300;
		sampleInputs[7] = 200;
		sampleInputs[8] = 100;
		sampleInputs[9] = 000;
		sampleInputs[10] = 1100;
		sampleInputs[11] = 1200;
		sampleInputs[12] = 1300;
		sampleInputs[13] = 1400;
		sampleInputs[14] = 1500;
		sampleInputs[15] = 1600;
	end
	
	
	always @(posedge clk)
	begin
		if (out_valid)
		begin
			testBenchOutput_actual <= testBenchOutput;
			rst <= 1;
		end
		
		if (rst)
			rst <= 0;
	end
	
	assign testBenchOutput_actual_actual = testBenchOutput_actual;
	
	N_point_fft_seq #(WIDTH, SAMPLES) tester
	(
		.sampleInputs(sampleInputs),
		.clk(clk),
		.rst(rst),
		.out_valid(out_valid),
		.outputs(testBenchOutput)
	);

endmodule