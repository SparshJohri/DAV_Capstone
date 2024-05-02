module vga_top_top
(
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output hsync,
    output vsync
);
	
	reg [2:0] sample_green = 3;
	reg [2:0] sample_red = 0;
	reg [1:0] sample_blue = 0;
	reg sample_rst = 0;
	
	
	reg clk = 0;
	
	always #1 clk = ~clk;

	wire [$clog2(526)-1:0]  vc_count;
	wire [$clog2(801)-1:0]  hc_count;
		
   vga VGA(
        .vgaclk(clk),
		  .rst(sample_rst),
        .hc_out(hc_count),
        .vc_out(vc_count),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );


endmodule