module assignmentOperator #(parameter WIDTH = 32)
(
	output [WIDTH-1:0] recipient,
	output [WIDTH-1:0] original
);

	/*always_comb
	begin
			for (int i=0; i<WIDTH; i++)
			begin
				assign recipient[i] = original[i];
			end
	end*/
	//genvar i;
	//assign recipient = new [WIDTH] (original);
endmodule