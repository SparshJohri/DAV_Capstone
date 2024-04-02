module ButterflyUnit #(parameter SAMPLES = 2, WIDTH = 4)
(
	input [WIDTH-1:0] input1,
	input [WIDTH-1:0] input2,
	input [WIDTH-1:0] twiddle,
	output [WIDTH-1:0] output1,
	output [WIDTH-1:0] output2,
	output [1:0] signOfMultiplication [1:0]
	
);

	localparam DIVIDER = 2**( (WIDTH/2) - 1);
	localparam SHIFTER = (WIDTH/2) -1;
	
	logic [(WIDTH>>1)-1:0] input1_real;
	logic [(WIDTH>>1)-1:0] input1_imag;
	logic [(WIDTH>>1)-1:0] input2_real;
	logic [(WIDTH>>1)-1:0] input2_imag;
	logic [(WIDTH>>1)-1:0] twiddle_real;
	logic [(WIDTH>>1)-1:0] twiddle_imag;
	
	
	logic [(WIDTH>>1)-1:0] input1_real_abs;
	logic [(WIDTH>>1)-1:0] input1_imag_abs;
	logic [(WIDTH>>1)-1:0] input2_real_abs;
	logic [(WIDTH>>1)-1:0] input2_imag_abs;
	logic [(WIDTH>>1)-1:0] twiddle_real_abs;
	logic [(WIDTH>>1)-1:0] twiddle_imag_abs;
	
	logic input1_real_sign;
	logic input1_imag_sign;
	logic input2_real_sign;
	logic input2_imag_sign;
	logic twiddle_real_sign;
	logic twiddle_imag_sign;
	
	assign input1_imag = input1[WIDTH-1:WIDTH>>1];
	assign input1_real = input1[(WIDTH>>1)-1:0];
	assign input2_imag = input2[WIDTH-1:WIDTH>>1];
	assign input2_real = input2[(WIDTH>>1)-1:0];
	assign twiddle_imag = twiddle[WIDTH-1:WIDTH>>1];
	assign twiddle_real = twiddle[(WIDTH>>1)-1:0];
	
	absolute_value #(WIDTH/2) input1_real_getter
	(.input1(input1_real), .output1(input1_real_abs), .negativeSign(input1_real_sign));

	absolute_value #(WIDTH/2) input1_imag_getter
	(.input1(input1_imag), .output1(input1_imag_abs), .negativeSign(input1_imag_sign));
	
	absolute_value #(WIDTH/2) input2_real_getter
	(.input1(input2_real), .output1(input2_real_abs), .negativeSign(input2_real_sign));

	absolute_value #(WIDTH/2) input2_imag_getter
	(.input1(input2_imag), .output1(input2_imag_abs), .negativeSign(input2_imag_sign));

	absolute_value #(WIDTH/2) twiddle_real_getter
	(.input1(twiddle_real), .output1(twiddle_real_abs), .negativeSign(twiddle_real_sign));

	absolute_value #(WIDTH/2) twiddle_imag_getter
	(.input1(twiddle_imag), .output1(twiddle_imag_abs), .negativeSign(twiddle_imag_sign));
	
	assign signOfMultiplication[0][0] =  input2_real_sign+twiddle_real_sign;
	assign signOfMultiplication[0][1] =  input2_real_sign+twiddle_imag_sign;
	assign signOfMultiplication[1][0] =  input2_imag_sign+twiddle_real_sign;
	assign signOfMultiplication[1][1] =  input2_imag_sign+twiddle_imag_sign;

	
	
	logic [(WIDTH>>1)-1:0] output_real_B_times_W_with_twiddle_real;
	logic [(WIDTH>>1)-1:0] output_imag_B_times_W_with_twiddle_real;
	logic [(WIDTH>>1)-1:0] output_real_B_times_W_with_twiddle_imag;
	logic [(WIDTH>>1)-1:0] output_imag_B_times_W_with_twiddle_imag;
	logic [(WIDTH>>1)-1:0] output_real_B_times_W;
	logic [(WIDTH>>1)-1:0] output_imag_B_times_W;
	
	assign output_real_B_times_W_with_twiddle_imag = (input2_imag*twiddle_imag/DIVIDER);//*(signOfMultiplication[1][1]*-1);
	assign output_imag_B_times_W_with_twiddle_imag = (input2_real*twiddle_imag/DIVIDER);//*(signOfMultiplication[0][1]*-1);
	assign output_real_B_times_W_with_twiddle_real = (input2_real*twiddle_real);//DIVIDER);//*(signOfMultiplication[0][0]*-1);
	assign output_imag_B_times_W_with_twiddle_real = (input2_imag*twiddle_real);//DIVIDER);//*(signOfMultiplication[1][0]*-1);

	assign output_real_B_times_W = output_real_B_times_W_with_twiddle_real + output_real_B_times_W_with_twiddle_imag;
	assign output_imag_B_times_W = output_imag_B_times_W_with_twiddle_real - output_imag_B_times_W_with_twiddle_imag;
	
	assign output1[WIDTH-1:WIDTH>>1] = input1_imag+output_imag_B_times_W;//+(input2_real*twiddle_real/DIVIDER)+(input2_imag*twiddle_imag/DIVIDER);
	assign output1[(WIDTH>>1)-1:0] = input1_real+output_real_B_times_W;//-(input2_real*twiddle_imag/DIVIDER)+(input2_imag*twiddle_real/DIVIDER);
	assign output2[WIDTH-1:WIDTH>>1] = input1_imag-output_imag_B_times_W;//-(input2_real*twiddle_real/DIVIDER)-(input2_imag*twiddle_imag/DIVIDER);
	assign output2[(WIDTH>>1)-1:0] = input1_real-output_real_B_times_W;//+(input2_real*twiddle_imag/DIVIDER)-(input2_imag*twiddle_real/DIVIDER);
	
endmodule//