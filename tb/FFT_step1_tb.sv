`timescale 1ps/1ps
module FFT_step1_tb #(parameter SAMPLES = 4, WIDTH = 32, STAGE = 0)
(
	output [WIDTH-1:0] display_stream1_1 [SAMPLES-1:0]
);


	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	logic clk = 0;
	/*
	assign sampleInputs[0] = 'h12c;
	assign sampleInputs[1] = 'hff9c;
	assign sampleInputs[2] = 'h190;
	assign sampleInputs[3] = 'hff9c;
	*/
	
	assign sampleInputs[0] = 100;
	assign sampleInputs[1] = 150;
	assign sampleInputs[2] = 200;
	assign sampleInputs[3] = 250;
	
	FFT_step #(SAMPLES, WIDTH, STAGE)
	tester
	(
		.clk(clk),
		.sampleInputs(sampleInputs),
		.stage_number(0),
		.display_stream1_1(display_stream1_1)
	);

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0);
		forever begin
			#1 clk = ~clk;
		end
	end

	initial begin
		#100 $finish;
	end

		
endmodule