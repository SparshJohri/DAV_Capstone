module assignmentOperator #(parameter WIDTH = 32)
(
	output [WIDTH-1:0] recipient,
	output [WIDTH-1:0] original
);

	genvar i;
	generate
		for (i=0; i<WIDTH; i++) begin : ASSIGNMENT
			assign recipient[i] = original[i];
		end
	endgenerate

endmodule