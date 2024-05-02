module vga_top (
    input clk,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output hsync,
    output vsync,
	 output [3:0] led_debugging
);
	
	 logic [2:0] input_red = 6;
	 logic [2:0] input_green = 0;
	 logic [1:0] input_blue = 0;
	 
	 wire res_clock;
    wire [$clog2(526)-1:0]  vc_count;
    wire [$clog2(801)-1:0]  hc_count;

    vga VGA(
        .vgaclk(res_clock),
        .rst(rst),
        .hc_out(hc_count),
        .vc_out(vc_count),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );
	 
	 pll_2 DataClock 
	 (
		clk,
		res_clock
	 );
	 
	 assign led_debugging = red;

endmodule