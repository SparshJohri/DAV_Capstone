module get_microphone_samples #(parameter WIDTH=32)
(
	input adc_clk,
	output [WIDTH-1:0] output_stream,
	output [9:0] led_debugging
);

	wire [11:0] mic_output;
	ADC mic_adc(
		.CLOCK(adc_clk),
		.RESET(0),
		.CH0(mic_output)
	);
	
	assign output_stream [WIDTH-1:(WIDTH/2)] = 0; //imaginary part is zero
	assign output_stream[((WIDTH/2)-1):12] = 0; //sign extending the value received from the microphone
	assign output_stream[11:0] = (mic_output >> 6); //value received from the microphone
	assign led_debugging = output_stream[9:0];

endmodule