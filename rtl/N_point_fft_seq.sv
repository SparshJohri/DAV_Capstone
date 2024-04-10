// below is the sequential version without a 3d array
module N_point_fft_seq #(
	parameter WIDTH = 0,
	parameter SAMPLES = 0
)(
	input clk, input rst,
	input [WIDTH-1:0] sampleInputs [SAMPLES-1:0],
	output out_valid,
	output [WIDTH-1:0] outputs [SAMPLES-1:0]
);


	logic [$clog2(SAMPLES)-1:0] new_indices [SAMPLES-1:0];
	reg [WIDTH-1:0] fft_in [SAMPLES-1:0];
	reg [WIDTH-1:0] fft_out [SAMPLES-1:0];
	wire [WIDTH-1:0] prepped_out [SAMPLES-1:0];

	scrambleForFFT_tb #(SAMPLES, $clog2(SAMPLES)) get_new_indices
	(
		.display_stream(new_indices)
	);
	
	prepareForFFT #(SAMPLES, WIDTH) getNewOrder
	(
		.input_stream(sampleInputs),
		.new_indices(new_indices),
		.output_stream(prepped_out)
	);

	FFT_step #(SAMPLES, WIDTH, cycle_cntr) takeStep
	(
		.sampleInputs(fft_in), 
		.display_stream1_1(fft_out) 
	);

	// state management
	localparam IDLE = 0;
	localparam RUN = 0;
	localparam FINISH = 0;

	logic [1:0] state, next_state;
	logic [$clog2(SAMPLES)-1:0] cycle_cntr, cycle_cntr_d;

	assign out_valid = state == FINISH ? 1'b1 : 1'b0; 
	assign outputs = fft_out;

	always @(*) begin
		cycle_cntr_d  = 0;
		case (state)
			IDLE: begin
				fft_in = prepped_out;
				next_state = RUN;
			end
			RUN: begin
				cycle_cntr_d = cycle_cntr + 1;
				if (cycle_cntr == $clog2(SAMPLES)) begin
					next_state = FINISH;
				end
			end
			FINISH: begin
				next_state = IDLE;
			end
			default:
				next_state = IDLE;
		endcase
	end

	always @(clk) begin
		if (rst) begin
			state <= IDLE;
		end else begin
			state <= next_state;
			cycle_cntr <= cycle_cntr_d; 
		end
		if (state == RUN) begin
			fft_in <= fft_out;
		end
	end

	
endmodule