module get_microphone_samples #(parameter WIDTH=32)
(
	input adc_clk,
	output [WIDTH-1:0] output_stream
);

	wire [11:0] mic_output;
	ADC mic_adc(
		.CLOCK(adc_clk),
		.RESET(0),
		.CH0(mic_output)
	);
	
	assign output_stream [WIDTH-1:(WIDTH/2)] = 0; //imaginary part is zero
	assign output_stream[((WIDTH/2)-1):12] = 0; //sign extending the value received from the microphone
	assign output_stream[11:0] = mic_output>>5; //value received from the microphone

endmodule