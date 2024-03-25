module FFT_step1_tb #(parameter SAMPLES = 4, WIDTH = 3)
(
	output [$clog2(SAMPLES)-1:0] display_stream [SAMPLES-1:0]
);


	logic [WIDTH-1:0] sampleInputs [SAMPLES-1:0];
	logic [$clog2(SAMPLES)-1:0] stage;
	
	
	assign sampleInputs [0] = 3'b110; //6
	assign sampleInputs [1] = 3'b010; //2
	assign sampleInputs [2] = 3'b000; //0
	assign sampleInputs [3] = 3'b111; //7
	
	FFT_step1 #(SAMPLES) tester
		(
			.stage(stage),
			.display_stream(display_stream)
		);
	
	initial
	begin
		stage = 0;
		#100
		stage = 1;
	end

endmodule