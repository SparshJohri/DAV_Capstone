module FFT_step1 #(parameter SAMPLES = 2, STAGE = 0)
(
	output [$clog2(SAMPLES)-1:0] display_stream [SAMPLES-1:0]
);


	logic [$clog2(SAMPLES)-1:0] display_stream2 [SAMPLES-1:0];

	
	logic [$clog2(SAMPLES)-1:0] i;
	logic [$clog2(SAMPLES)-1:0] j;
	logic [$clog2(SAMPLES)-1:0] k;
	logic [$clog2(SAMPLES)-1:0] l;
	
	logic [$clog2(SAMPLES)-1:0] stage1;
	initial begin
		stage1 = STAGE;
		l=0;
		k=0;
		for(i=0; i<((SAMPLES >> 1) >> stage1); i++)
		begin
			for(j=0; j<(1<<stage1); j++)
			begin
				display_stream2[k] = (l+j);
				display_stream2[k+1] = (l+j+(1<<stage1));
				k=k+2;
			end
			l = l+((1<<stage1)<<1);
		end
	end
	
	assign display_stream = display_stream2;

endmodule