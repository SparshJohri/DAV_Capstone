module ping_pong_tb
(
	output [7:0] pixel_to_display
);

	logic clk; //only because the RAM IP requires it
	logic [9:0] hc;
	logic [9:0] vc;
	logic write_to_two;

	always #1 clk = ~clk;
	
	initial
	begin
		clk = 0;
		hc = 1;
		vc = 1;
		write_to_two = 0;
	
		#1	
		write_to_two = 1;
		
		#1
		write_to_two = 0;
		
		#3
		write_to_two = 1;
	
	end
	
	ping_pong table_tennis_tester
	(
		.clk(clk),
		.hc(hc),
		.vc(vc),
		.pixel_to_display(pixel_to_display),
		.write_to_two(write_to_two)
	);


endmodule