module absolute_value_tb #(parameter WIDTH = 4)
(
	output [WIDTH-1:0] output_stream
);

	logic [WIDTH-1:0] sampleInput;
	
	initial
	begin
		sampleInput = 'h4;
		#10
		sampleInput = 'hc;
		#10
		sampleInput = 'h1;
		#10
		sampleInput = 'h9;
	end
	
	absolute_value #(WIDTH) tester
	(
		.input1(sampleInput),
		.output1(output_stream)
	);

endmodule