`timescale 1ns/1ns

module getIndicesOfGreatestBins_tb #(parameter SAMPLES=8, WIDTH=32)
(
	output [$clog2(SAMPLES)-1:0] tb_output,
	output [7:0] outColor
);

	logic clk;
	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	logic done;
	logic whichRAM;
	logic rst;
	
	logic [7:0] backgroundColor;

	always #1 clk = ~clk;
	
	/*
	 assign frequency_bins[0] = 20;
	 assign frequency_bins[1] = 40;
	 assign frequency_bins[2] = 60;
	 assign frequency_bins[3] = 80;
	 assign frequency_bins[4] = 10;
	 assign frequency_bins[5] = 40;
	 assign frequency_bins[6] = 0;
	 assign frequency_bins[7] = 100;
	*/
	
	initial
	begin
		rst = 0;
		clk = 0;
		whichRAM = 0;
		backgroundColor = 7<<3;
		
		/*
		sampleInputs[0] = 20;
		sampleInputs[1] = 40;
		sampleInputs[2] = 60;
		sampleInputs[3] = 80;
		sampleInputs[4] = 10;
		sampleInputs[5] = 40;
		sampleInputs[6] = 100;
		sampleInputs[7] = 0;
		
		#40
		
		rst = 1;
		#2
		rst = 0;
		sampleInputs[1] = 200;

		#40

		rst = 1;
		#2
		rst = 0;
		sampleInputs[4] = 300;	
		*/
	  sampleInputs[0] = 20;
	  sampleInputs[1] = 0;
	  sampleInputs[2] = 60;
	  sampleInputs[3] = 80;
	  sampleInputs[4] = 10;
	  sampleInputs[5] = 40;
	  sampleInputs[6] = 30;
	  sampleInputs[7] = 100;
		
	end
	
	getIndicesOfGreatestBins #(SAMPLES, WIDTH) tester
	(
		clk,
		sampleInputs,
		tb_output,
		done,
		rst
	);
	
	colorDeterminer #(SAMPLES) colorTester
	(
		tb_output,
		whichRAM,
		done,
		backgroundColor,
		outColor
	);

endmodule