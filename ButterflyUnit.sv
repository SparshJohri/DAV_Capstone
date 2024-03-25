module ButterflyUnit #(parameter SAMPLES = 2, WIDTH = 3)
(
	input [WIDTH-1:0] input1,
	input [WIDTH-1:0] input2,
	output [WIDTH-1:0] output1,
	output [WIDTH-1:0] output2
);

		assign output1 = input1;
		assign output2 = input2;

endmodule