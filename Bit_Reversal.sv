module Bit_Reversal #(parameter WIDTH = 32)
(
         input [WIDTH-1:0] input_stream,
         output [WIDTH-1:0] output_stream
);
	 genvar i;
	 
    generate
        for (i = 0; i < WIDTH; i++) begin : REVERSE_LOOP
            assign output_stream[i] = input_stream[WIDTH - 1 - i];
        end
    endgenerate
	
endmodule