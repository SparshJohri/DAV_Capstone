module colorDeterminer #(parameter SAMPLES=32)
(
	input [$clog2(SAMPLES)-1:0] index_holder,
	input whichRAM, //unused
	input done,
	input [7:0] backgroundColor,
	output [7:0] outColor
);

	logic [7:0] outColor_a;
	
	always_comb
	begin
		if (~done)
		begin
			outColor_a = backgroundColor;
		end
		
		else
		begin
			if (index_holder > (SAMPLES*2/3))
				outColor_a = 'b11000000; //c0
			else
			begin
				if (index_holder < (SAMPLES*1/3))
					outColor_a = 'b00101011; //2b
				else
					outColor_a = 'b11111111; //ff     //'b00111111
			end
		end
	end
	
	assign outColor = outColor_a;

endmodule