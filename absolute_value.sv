module absolute_value #(parameter WIDTH=32)
(
	input [WIDTH-1:0] input1,
	output [WIDTH-1:0] output1,
	output negativeSign
);

	logic [WIDTH-1:0] mid1;
	logic mid2;
	
	always_comb
	begin
		if (input1 < (2**(WIDTH-1))) begin mid1 = input1; mid2 = 0; end
		else begin mid1 = (~input1)+1; mid2 = 1; end
	end
	
	
	assign output1 = mid1;
	assign negativeSign = mid2;

endmodule