module calculateMaxVal #(parameter SAMPLES=32, WIDTH=32)
(
	input [(WIDTH-1):0] value,
	output [9:0] maxVal
);

	always_comb
	begin
		if (value < 500)
			maxVal[9:0] = value[9:0];
		else
			maxVal[9:0] = 500;
	end
endmodule