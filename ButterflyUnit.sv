module ButterflyUnit #(parameter SAMPLES = 2, WIDTH = 4)
(
	input [WIDTH-1:0] input1,
	input [WIDTH-1:0] input2,
	input [WIDTH-1:0] twiddle,
	output [WIDTH-1:0] output1,
	output [WIDTH-1:0] output2
	
);

	logic [(WIDTH>>1)-1:0] input1_real;
	logic [(WIDTH>>1)-1:0] input1_imag;
	logic [(WIDTH>>1)-1:0] input2_real;
	logic [(WIDTH>>1)-1:0] input2_imag;
	logic [(WIDTH>>1)-1:0] twiddle_real;
	logic [(WIDTH>>1)-1:0] twiddle_imag;
	
	assign input1_real = input1[WIDTH-1:WIDTH>>1];
	assign input1_imag = input1[(WIDTH>>1)-1:0];
	assign input2_real = input2[WIDTH-1:WIDTH>>1];
	assign input2_imag = input2[(WIDTH>>1)-1:0];
	assign twiddle_real = twiddle[WIDTH-1:WIDTH>>1];
	assign twiddle_imag = twiddle[(WIDTH>>1)-1:0];
	
	assign output1[WIDTH-1:WIDTH>>1] = input1_real+(input2_real*twiddle_real)-(input2_imag*twiddle_imag);
	assign output1[(WIDTH>>1)-1:0] = input1_imag+(input2_real*twiddle_imag)+(input2_imag*twiddle_real);
	assign output2[WIDTH-1:WIDTH>>1] = input1_real-(input2_real*twiddle_real)+(input2_imag*twiddle_imag);
	assign output2[(WIDTH>>1)-1:0] = input1_imag-(input2_real*twiddle_imag)-(input2_imag*twiddle_real);
	
endmodule