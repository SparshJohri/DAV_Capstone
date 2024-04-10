module ButterflyUnit_tb #(parameter STAGE=2, WIDTH = 32)
(
	output [WIDTH-1:0] output1,
	output [WIDTH-1:0] output2
);

	logic [WIDTH-1:0] input1;
	logic [WIDTH-1:0] input2;
	logic [WIDTH-1:0] twiddle;
	logic [STAGE:0] which_factor2;
	
	
	initial
	begin
		which_factor2 = 0;
		input1 = 'h00000001;//'hffe20014;
		input2 = 'h0000000a;//'hffce003c;
		
		#100
		
		which_factor2 = 1;
		
		#100
		
		which_factor2 = 2;
		
		#100
		
		which_factor2 = 3;
	end
	
	twiddleFactorCalculator #(2**(STAGE+1), WIDTH)
	getTwiddleForIteration2
	(
		.which_factor(which_factor2),
		.result(twiddle)
	);
	
	ButterflyUnit #(2, WIDTH)
	tester
	(
		input1,
		input2,
		twiddle,
		output1,
		output2
	);


endmodule