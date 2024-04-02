module FFT_step #(parameter SAMPLES = 4, WIDTH = 32, STAGE = 0)
(
	input [WIDTH-1:0] sampleInputs [SAMPLES-1:0],
	output [WIDTH-1:0] display_stream1_1 [SAMPLES-1:0]
);

	genvar i;
	generate
		for(i=0; i<((SAMPLES >> 1) >> STAGE); i++)
		begin : OUTER_LOOP
			genvar j;
			for(j=0; j<(1<<STAGE); j++)
			begin : INNER_LOOP
				logic [(WIDTH-1):0] twiddle_factor_to_use2;
				logic [STAGE:0] which_factor2;
				logic [1:0] signOfMultiplication [1:0];
				
				
				
				//if (STAGE==0) assign which_factor2 = 0;
				//else			  assign which_factor2 = (i*(1<<STAGE) + j);
				if (STAGE!=0) assign which_factor2[STAGE-1:0] = (i*(1<<STAGE) + j);
				assign which_factor2[STAGE] = 0;
				
				
				twiddleFactorCalculator #(2**(STAGE+1), WIDTH)
				getTwiddleForIteration2
				(
					.which_factor(which_factor2),
					.result(twiddle_factor_to_use2)
				);
				
				ButterflyUnit #(SAMPLES, WIDTH)
				butterfly2
				(
					.input1(sampleInputs[(i*((1<<STAGE)<<1))+j]),
					.input2(sampleInputs[(i*((1<<STAGE)<<1))+j+(1<<STAGE)]),
					.twiddle(twiddle_factor_to_use2),
					.output1(display_stream1_1[(i*((1<<STAGE)<<1))+j]),
					.output2(display_stream1_1[(i*((1<<STAGE)<<1))+j+(1<<STAGE)]),
					.signOfMultiplication(signOfMultiplication)
				);
			end
		end
	endgenerate
	
	
		
endmodule