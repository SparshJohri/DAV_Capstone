module Bit_Reversal_tb #(parameter WIDTH = 4)
(
	output [WIDTH-1:0] C
);

	logic [WIDTH-1:0] D;
	//logic [WIDTH-1:0] numbers [WIDTH-1:0];
	
	Bit_Reversal #(4) E
	(
		.input_stream (D),
		.output_stream(C)
	);
	
	initial begin
		D = 0;
		#10;
		D = 1;
		#10;
		D = 2;
		#10;
		D = 3;
		#10;
		D = 4;
		#10;
		D = 5;
		#10;
		D = 6;
		#10;
		D = 0;
	end

endmodule