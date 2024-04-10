module FFT_step #(parameter SAMPLES = 4, WIDTH = 32, TOTAL_STAGES = 4)
(
	input clk,
	input [WIDTH-1:0] sampleInputs [SAMPLES-1:0],
	input [$clog2(SAMPLES)-1:0] stage_number,
	output reg [WIDTH-1:0] display_stream1_1 [SAMPLES-1:0]
);

	logic [$clog2(SAMPLES)-1:0] idx = 0;
	logic [$clog2(SAMPLES)-1:0] jdx = 0;
	reg jdx_finish = 0;
	logic [TOTAL_STAGES:0] which_factor2;
	logic [1:0] signOfMultiplication [1:0];
	logic [WIDTH-1:0] in1, in2, out1, out2;
	logic [$clog2(SAMPLES)-1:0] in1_dx, in2_dx, out1_dx, out2_dx;
	logic [WIDTH-1:0] twiddle_factor_to_use2;
	logic [WIDTH-1:0] dispOut1, dispOut2;
	logic [TOTAL_STAGES:0] which_factor2_MASK;
	assign which_factor2_MASK[TOTAL_STAGES:0] = 1<<<stage_number;

	assign in1_dx = (idx*((1<<stage_number)<<1))+jdx;
	assign in2_dx = (idx*((1<<stage_number)<<1))+jdx+(1<<stage_number);
	assign out1_dx = (idx*((1<<stage_number)<<1))+jdx;
	assign out2_dx = (idx*((1<<stage_number)<<1))+jdx+(1<<stage_number);

	twiddleFactorCalculator #(2**(TOTAL_STAGES+1), WIDTH)
	getTwiddleForIteration2
	(
		.which_factor(which_factor2),
		.result(twiddle_factor_to_use2)
	);

	ButterflyUnit #(SAMPLES, WIDTH)
	butterfly2
	(
		.input1(sampleInputs[in1_dx]),
		.input2(sampleInputs[in2_dx]),
		.twiddle(twiddle_factor_to_use2),
		.output1(dispOut1),
		.output2(dispOut2),
		.signOfMultiplication(signOfMultiplication)
	);

	
	always @(posedge clk) begin
		display_stream1_1[out1_dx] = dispOut1;
		display_stream1_1[out2_dx] = dispOut2;
		if (stage_number!=0)
			which_factor2[TOTAL_STAGES:0] = (idx*(1<<stage_number) + jdx)&which_factor2_MASK;
		which_factor2[stage_number] = 0;

		if (idx < ((SAMPLES >> 1) >> stage_number) && jdx_finish)
			idx <= idx + 1;
		if (jdx < (1<<stage_number)) begin
			jdx <= jdx + 1;
			jdx_finish <= 0;
		end else begin
			jdx <= 0;
			jdx_finish <= 1;
		end
	end

		
endmodule