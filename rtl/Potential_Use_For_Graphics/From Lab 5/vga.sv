module vga #(SAMPLES=32, WIDTH=32)
(
	input vgaclk,
	input [7:0] colorPacking,
	// 8-bit color allocates 3 bits for red, 3 for green, 2 for blue
	output [9:0] hc_out,
	output [9:0] vc_out,
	output reg hsync,
	output reg vsync,
	output reg [2:0] red,
	output reg [2:0] green,
	output reg [1:0] blue
);
	
	/* TODO(1): Video protocol constants
    * You can find these described in the VGA specification for 640x480
	 */
	localparam HPIXELS = 640;    // number of visible pixels per horizontal line
	localparam HFP = 16; 	      // length (in pixels) of horizontal front porch
	localparam HSPULSE = 96; 	// length (in pixels) of hsync pulse
	localparam HBP = 48; 	      // length (in pixels) of horizontal back porch
	
	localparam VPIXELS = 480;    // number of visible horizontal lines per frame
	localparam VFP = 10; 	      // length (in pixels) of vertical front porch
	localparam VSPULSE = 2;    // length (in pixels) of vsync pulse
	localparam VBP = 33; 		   // length (in pixels) of vertical back porch


	/* no need to mess with this -- this is a basic sanity check that will
	 * cause the compiler to yell at you if the values above don't add up
	 */
	initial begin
		if (HPIXELS + HFP + HSPULSE + HBP != 800 || VPIXELS + VFP + VSPULSE + VBP != 525) begin
			$error("Expected horizontal pixels to add up to 800 and vertical pixels to add up to 525");
		end
	end
	
	reg [9:0] hc = 0;
	reg [9:0] vc = 0;
	// logic [7:0] colorPacking;
	logic [7:0] x;
	logic [7:0] y;
	//logic write_to_two = 0;
	
	assign x = hc/20;
	assign y = hc/20;
	assign hc_out = hc;
	assign vc_out = vc;
	assign hsync = ~( (hc<(HPIXELS+HFP+HSPULSE)) && ((hc>(HPIXELS+HFP-1)) ) );
	assign vsync = ~( (vc<(VPIXELS+VFP+VSPULSE)) && ((vc>(VPIXELS+VFP-1)) ) );
	
	always_comb begin
		if ( (hc > (HPIXELS-1) ) || (vc > (VPIXELS-1) ) )
		begin
			red = 0; green = 0; blue = 0;
		end
		else
		begin
			red = colorPacking[2:0]; green = colorPacking[5:3]; blue = colorPacking[7:6];
			//red = 7; green = 4; blue = 0;
		end
	end
	
	// in the sequential block, we update hc and vc based on their current values
	always_ff @(posedge vgaclk) begin
		if (hc>=(HPIXELS+HFP+HSPULSE+HBP-1))
		begin
			hc <= 0;
			if (vc >= (VPIXELS+VFP+VSPULSE+VBP-1))
				vc <= 0;
			else
				vc <= vc + 1;
		end
		else
			hc <= hc+1;
	end

endmodule