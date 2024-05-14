module vga_top_tb
(
	output [5:0] led_debugging
);

  reg clk = 0;
  always #1 clk = ~clk;

  logic A = 1;
  logic B = 0;
  logic [2:0] red;
  logic [2:0] green;
  logic [1:0] blue;
  logic hsync;
  logic vsync;
	 //logic [5:0] led_debugging;
	
	vga_top tester
	(
	 clk,
    A,
	 B,
	 red,
    green,
    blue,
    hsync,
    vsync,
	 led_debugging
	);
/*
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output hsync,
    output vsync,
	 output [3:0] led_debugging
*/

endmodule