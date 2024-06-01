`timescale 1ns/1ns

module getHistFromMic_tb
(output logic [31:0] outputs_FFT_true [15:0], output [31:0] sampleRec [15:0], output [17:0] magnitudes [15:0]);

	logic clk;
	logic [15:0] mic_stream;
	logic [31:0] outputs_out [15:0]; logic [31:0] sampleRec_not_reg [15:0];
	logic [17:0] magnitudes_temp [15:0];
	logic [3:0] index_holder;
	logic done;
	
	always #1 clk = ~clk;
	
	getHistFromMic tester
	(clk, clk, mic_stream, outputs_out, sampleRec_not_reg, outputs_FFT_true, sampleRec, magnitudes_temp, index_holder, done);
	
	
	reg [31:0] test_memory [31:0]; //holds the samples I'm sending to the mic
	reg [4:0] memory_tracker; //indicates which sample should be sent to the mic
	initial
	begin
	
		test_memory[0] = 0; test_memory[1] = 200; test_memory[2] = 400; test_memory[3] = 800;
		test_memory[4] = 1600; test_memory[5] = 800; test_memory[6] = 400; test_memory[7] = 200;
		test_memory[8] = 0; test_memory[9] = 200; test_memory[10] = 400; test_memory[11] = 200;
		test_memory[12] = 0; test_memory[13] = 200; test_memory[14] = 400; test_memory[15] = 200;
		test_memory[16] = 100; test_memory[17] = 200; test_memory[18] = 300; test_memory[19] = 400;
		test_memory[20] = 500; test_memory[21] = 600; test_memory[22] = 700; test_memory[23] = 800;	
		test_memory[24] = 900; test_memory[25] = 800; test_memory[26] = 700; test_memory[27] = 600;
		test_memory[28] = 500; test_memory[29] = 400; test_memory[30] = 300; test_memory[31] = 200;
		
		
		test_memory[0] = 0; test_memory[1] = 200; test_memory[2] = 0; test_memory[3] = 200;
		test_memory[4] = 0; test_memory[5] = 200; test_memory[6] = 0; test_memory[7] = 200;
		test_memory[8] = 0; test_memory[9] = 200; test_memory[10] = 400; test_memory[11] = 200;
		test_memory[12] = 0; test_memory[13] = 100; test_memory[14] = 200; test_memory[15] = 100;
		test_memory[16] = 0; test_memory[17] = 100; test_memory[18] = 200; test_memory[19] = 100;
		test_memory[20] = 0; test_memory[21] = 100; test_memory[22] = 200; test_memory[23] = 100;	
		test_memory[24] = 0; test_memory[25] = 100; test_memory[26] = 200; test_memory[27] = 300;
		test_memory[28] = 400; test_memory[29] = 300; test_memory[30] = 200; test_memory[31] = 100;
		
		memory_tracker = 0; clk = 0;
	end

	genvar i;
	generate
		for (i = 0; i < 16; i++) 
		begin : PEACE
			assign magnitudes[i] = magnitudes_temp[i] >> 8;					
		end
	endgenerate

	always @(posedge clk)
	begin
		mic_stream <= test_memory[memory_tracker];
		memory_tracker <= memory_tracker + 1;
	end

endmodule