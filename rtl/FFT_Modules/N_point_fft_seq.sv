// below is the sequential version without a 3d array
module N_point_fft_seq #(
	parameter WIDTH = 32, SAMPLES = 16
)(
	input clk, input rst,
	input [WIDTH-1:0] sampleInputs [SAMPLES-1:0],
	output out_valid,
	output [WIDTH-1:0] outputs [SAMPLES-1:0]
);

	logic [$clog2(SAMPLES)-1:0] new_indices [SAMPLES-1:0];
	reg [WIDTH-1:0] fft_in [SAMPLES-1:0];
	reg [WIDTH-1:0] fft_in_d [SAMPLES-1:0];
	reg [WIDTH-1:0] fft_out [SAMPLES-1:0];
	logic cycle_done;
	wire [WIDTH-1:0] prepped_out [SAMPLES-1:0];
	logic start_fft_step;

	// state management
	localparam IDLE = 0;
	localparam RUN = 1;
	localparam FINISH = 2;

	logic [1:0] state = IDLE;
	logic [1:0] next_state;
	logic [$clog2(SAMPLES)-1:0] cycle_cntr = 0;
	logic [$clog2(SAMPLES)-1:0] cycle_cntr_d;

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

	FFT_step #(SAMPLES, WIDTH, $clog2(SAMPLES)) takeStep
	(
		.start(start_fft_step),
		.clk(clk),
		.sampleInputs(fft_in), 
		.stage_number(cycle_cntr),
		.display_stream1_1(fft_out),
		.done(cycle_done)
	);

	assign out_valid = state == FINISH ? 1'b1 : 1'b0; 
	assign outputs = fft_in;

	always @(*) begin
		cycle_cntr_d  = cycle_cntr;
		fft_in_d = fft_in;
		start_fft_step = 0;
		case (state)
			IDLE: begin
                fft_in_d = prepped_out;
				next_state = RUN;
			end
			RUN: begin
				if (cycle_done) begin
					start_fft_step = 0;
					cycle_cntr_d = cycle_cntr + 1;
					fft_in_d = fft_out;
				end else
					start_fft_step = 1;
				if (cycle_cntr == $clog2(SAMPLES)) begin
					next_state = FINISH;
				end
			end
			FINISH: begin
				next_state = FINISH;
			end
			default:
				next_state = IDLE;
		endcase
	end

	always @(posedge clk) begin
		if (rst) begin
			state <= IDLE;
			cycle_cntr <= 0;
			// fft_in <= 0;
		end else begin
			state <= next_state;
			cycle_cntr <= cycle_cntr_d;
			if (state!=FINISH)
				fft_in <= fft_in_d;
		end
	end

	
endmodule