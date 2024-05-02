module connecting_mic_to_FFT #(parameter WIDTH=32)
(
	input adc_clk,
	input clk,
	output reg [WIDTH-1:0] ultimateOutput [31:0]
	output [WIDTH-1:0] output_stream_mic
);

	logic [4:0] micIndex = 0;
	logic [WIDTH-1:0] storeMicOutput [31:0];
	logic [WIDTH-1:0] FFT_output [31:0]
	
	
	wire [WIDTH-1:0] getMicOutput;
	logic rst = 0;
	logic out_valid = 0;
	logic start_fft = 0;
	logic [3:0] pause_after_fft = 1;
	localparam READING_FROM_MIC = 0;
	localparam DOING_FFT = 1;
	
	
	
	get_microphone_samples #(WIDTH)
	mic_reader
	(
		.adc_clk(adc_clk),
		.mic_output(getMicOutput)
	);
	
	N_point_fft_seq #(WIDTH, 32) 
	get_frequencies
	(
		.sampleInputs(storeMicOutput),
		.clk(clk),
		.rst(rst),
		.out_valid(out_valid),
		.outputs(FFT_output)
	);
	
	assign output_stream_mic = getMicOutput;
	
	always @(posedge adc_clk)
	begin
		if ((~micIndex)==0)
		begin
			storeMicOutput = {storeMicOutput[31:1], getMicOutput};
			micIndex <= micIndex+1;
		end
		
		else
		begin
		
			if ( (out_valid==0) || (pause_after_fft>0) )
			begin
				//FFT starts operating
				rst <= 0;
				if (out_valid==1)
					pause_after_fft <= pause_after_fft+1;
			end
		
			else
			begin
				//reset all counter variables to their initial values
				ultimateOutput <= FFT_output;
				rst <= 1;
				micIndex <= -2;
				pause_after_fft <= 1;
			end
		
		end
	end;

endmodule