module twiddleFactorCalculator_tb
(
	output [7:0] output_stream
);

	logic [2:0] factortoConsider;
	
	twiddleFactorCalculator
	tester
	(
		.which_factor(factortoConsider),
		.result(output_stream)
	);
	
	initial
	begin
		factortoConsider = 0;
		
		#25
		
		factortoConsider = 1;
		#25
		
		factortoConsider = 2;		
		#25
		
		factortoConsider = 3;
		
	end

endmodule